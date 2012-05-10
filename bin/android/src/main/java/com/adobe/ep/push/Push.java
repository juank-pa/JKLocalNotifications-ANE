/*
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2011 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 *
 */
package com.adobe.ep.push;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

/**
 * The Push class contains methods related to management of the Push mechanism. It's a central hub for initializing and configuring the system.
 */
public abstract class Push
{
	/** Unable to get a registration ID from the cloud. This may be due to incorrect permissions, or may be a transient failure. */
	protected static final String ERROR_CANNOT_GET_REGISTRATION_ID = "CANNOT_GET_REGISTRATION_ID";
	/** Unable to register with the CRX server. It may be unreachable or not configured correctly. */
	protected static final String ERROR_CANNOT_SELF_REGISTER = "CANNOT_SELF_REGISTER";

	/** In initial state. */
	protected static final String STATE_UNREGISTERED = "UNREGISTERED";
	/** Made a successful initial call to REST endpoint. Will automatically attempt to get a registration ID from the cloud. */
	protected static final String STATE_COMPLETED_REST_CALL = "COMPLETED_REST_CALL";
	/** Received a registration ID. Will automatically attempt to self-register with host CRX server next. */
	protected static final String STATE_RECEIVED_REG_ID = "RECEIVED__REG_ID";
	/** Successfully supplied registration ID to host CRX server. Can now receive messages from server. */
	protected static final String STATE_SELF_REGISTERED = "SELF_REGISTERED";

	/** Log with info level */
	protected static final char LOG_INFO = 'i';
	/** Log with error level */
	protected static final char LOG_ERROR = 'e';

	private static final String PROVIDER_ID_PARAM = "providerId";
	private static final String REG_ID_PARAM = "regId";
	private static final String DEVICE_ID_PARAM = "deviceId";
	private static final String APPLICATION_ID_PARAM = "applicationId";
	private static final String OPERATION_PARAM = ":operation";
	private static final String OPERATION = "featureProvision";
	private static final String REASON_PARAM = "reason";
	private static final String REASON = "push";
	private static final String CHARSET_PARAM = "_charset_";
	private static final String LINKS_KEY = "links";
	private static final String PUSH_REGISTRATION_URL_KEY = "pushRegistrationUrl";
	private static final String FEATURE_PROVISIONING_URL_KEY = "featureProvisioningUrl";

	private static final String PREFERENCE_CURRENT_STATE = "CURRENT_STATE";
	private static final String PREFERENCE_APPLICATION_ID = "APPLICATION_ID";
	private static final String PREFERENCE_CLIENTAPPS_API_URL = "CLIENTAPPS_API_URL";
	private static final String PREFERENCE_REGISTERED_SERVER = "REGISTERED_SERVER";
	private static final String PREFERENCE_AUTHENTICATION_TOKEN = "AUTHENTICATION_TOKEN";
	private static final String PREFERENCE_REGISTRATION_URL = "REGISTRATION_URL";
	private static final String PREFERENCE_FEATURE_PROVISIONING_URL = "FEATURE_PROVISIONING_URL";

	private String providerId; // The provider ID, such as c2dm

	/** All public methods are in derived classes. */
	protected Push(String providerId)
	{
		this.providerId = providerId;
	}

	/**
	 * Register for push notifications.
	 * 
	 * @param registrationSettings
	 *            an instance of the {@link RegistrationSettings} class that specifies configuration details. See that class for details.
	 */
	protected void register(RegistrationSettings registrationSettings)
	{
		log(LOG_INFO, "register called");
		registrationSettings.validate();

		// If we're called with different settings from a previous invocation, reset everything.
		if (!matchesCachedSettings(registrationSettings))
		{
			log(LOG_INFO, "register: updating cached registration settings");
			String registrationId = getRegistrationId();

			setState(registrationId.length() == 0 ? STATE_UNREGISTERED : STATE_RECEIVED_REG_ID);
			setPreference(PREFERENCE_APPLICATION_ID, registrationSettings.applicationId);
			setPreference(PREFERENCE_CLIENTAPPS_API_URL, registrationSettings.clientAppsAPIURL);
		}
		// Always store the latest authentication token.
		setPreference(PREFERENCE_AUTHENTICATION_TOKEN, registrationSettings.authenticationToken);
		// Kick off the process of registration.
		advanceStateAsNeeded();
	}

	/**
	 * Unregister for push notifications. Most applications will not need to do this.
	 */
	protected void unregister()
	{
		clearAllPreferences();
	}

	/**
	 * Get the current state.
	 * 
	 * @return one of the STATE_* values. It is safe to test for object equality, eg if (getState() == STATE_SELF_REGISTERED)...
	 */
	protected String getState()
	{
		String currentState = getPreference(PREFERENCE_CURRENT_STATE, STATE_UNREGISTERED);

		// Convert the string value into one of the specific STATE_* object values.
		for (String state : new String[] { STATE_UNREGISTERED, STATE_COMPLETED_REST_CALL, STATE_RECEIVED_REG_ID, STATE_SELF_REGISTERED })
		{
			if (currentState.equals(state))
				return state;

		}
		throw new IllegalStateException("Unexpected state value: " + currentState);
	}

	/*
	 * Advance the current state to the next as needed: STATE_UNREGISTERED to STATE_COMPLETED_REST_CALL to STATE_RECEIVED_REG_ID to STATE_SELF_REGISTERED.
	 */
	private void advanceStateAsNeeded()
	{
		String currentState = getState();
		if (currentState == STATE_UNREGISTERED)
		{
			makeRESTCall();
		}
		else if (currentState == STATE_COMPLETED_REST_CALL)
		{
			requestIdAsync();
		}
		else if (currentState == STATE_RECEIVED_REG_ID)
		{
			String registrationId = getRegistrationId();
			selfRegister(registrationId);
		}
	}

	private void setState(String newState)
	{
		setPreference(PREFERENCE_CURRENT_STATE, newState);
		onStateChange(newState);
	}

	private void makeRESTCall()
	{
		String applicationId = getPreference(PREFERENCE_APPLICATION_ID, "");
		String clientAppsAPIURL = getPreference(PREFERENCE_CLIENTAPPS_API_URL, "");
		String deviceId = getDeviceId();

		try
		{
			String encodedApplicationId = URLEncoder.encode(applicationId, "UTF-8");
			String encodedDeviceId = URLEncoder.encode(deviceId, "UTF-8");
			// The metadataSuffix will cause the REST endpoint to give us a metadata/push/[providerId]/data response where data is providerId-specific.
			String metadataSuffix = "&metadata=push/" + providerId;
			byte[] bytes = getFromServer(clientAppsAPIURL + "?applicationId=" + encodedApplicationId + "&deviceId=" + encodedDeviceId + metadataSuffix);
			if (bytes != null)
			{
				// The server response should be a valid JSON string.
				String jsonString = new String(bytes, "UTF-8");
				log(LOG_INFO, "Received reply from server");
				JSONObject restResponse = new JSONObject(jsonString);
				String pushRegistrationUrl = restResponse.getJSONObject(LINKS_KEY).getString(PUSH_REGISTRATION_URL_KEY);
				String featureProvisioningUrl = restResponse.getJSONObject(LINKS_KEY).getString(FEATURE_PROVISIONING_URL_KEY);
				// If the server is not configured correctly, the metadata will be missing, so try to give a friendlier hint.
				JSONObject metadata = restResponse.optJSONObject("metadata");
				if (metadata == null)
				{
					throw new IllegalStateException("Server appears to be misconfigured.  Expected metadata is missing.");
				}
				processMetadata(metadata.getJSONObject("push").getJSONObject(providerId));
				setPreference(PREFERENCE_REGISTRATION_URL, pushRegistrationUrl);
				setPreference(PREFERENCE_FEATURE_PROVISIONING_URL, featureProvisioningUrl);
				setState(STATE_COMPLETED_REST_CALL);
				advanceStateAsNeeded();
			}
		} catch (Throwable e)
		{
			e.printStackTrace();
			onError(ERROR_CANNOT_SELF_REGISTER, "Unable to understand JSON response:" + e.toString());
		}
	}

	private void selfRegister(String registrationId)
	{
		try
		{
			// Step 1: open up the push registration URL by hitting the feature provisioning URL.
			String featureProvisioningUrl = getPreference(PREFERENCE_FEATURE_PROVISIONING_URL, "");
			log(LOG_INFO, "Attempting to post to: " + featureProvisioningUrl);
			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(5);
			nameValuePairs.add(new BasicNameValuePair(CHARSET_PARAM, "UTF-8"));
			nameValuePairs.add(new BasicNameValuePair(OPERATION_PARAM, OPERATION));
			nameValuePairs.add(new BasicNameValuePair(REASON_PARAM, REASON));
			nameValuePairs.add(new BasicNameValuePair(DEVICE_ID_PARAM, getDeviceId()));
			nameValuePairs.add(new BasicNameValuePair(APPLICATION_ID_PARAM, getPreference(PREFERENCE_APPLICATION_ID, "")));
			if (postToServer(featureProvisioningUrl, nameValuePairs) != null)
			{
				// Step 2: post our registration details to the newly-opened push registration URL.
				String pushRegistrationUrl = getPreference(PREFERENCE_REGISTRATION_URL, "");
				log(LOG_INFO, "Attempting to post registration to: " + pushRegistrationUrl);
				nameValuePairs = new ArrayList<NameValuePair>(3);
				nameValuePairs.add(new BasicNameValuePair(CHARSET_PARAM, "UTF-8"));
				nameValuePairs.add(new BasicNameValuePair(PROVIDER_ID_PARAM, providerId));
				nameValuePairs.add(new BasicNameValuePair(REG_ID_PARAM, registrationId));
				if (postToServer(pushRegistrationUrl, nameValuePairs) != null)
				{
					// Successfully registered.
					String clientAppsAPIURL = getPreference(PREFERENCE_CLIENTAPPS_API_URL, "");
					setPreference(PREFERENCE_REGISTERED_SERVER, clientAppsAPIURL);
					setState(STATE_SELF_REGISTERED);
				}
			}
		} catch (Throwable e)
		{
			e.printStackTrace();
			onError(ERROR_CANNOT_SELF_REGISTER, "Unable to post details to server:" + e.toString());
		}
	}

	/**
	 * Determine if the provided settings match those cached in preferences.
	 * 
	 * @param registrationSettings
	 * @return true if equivalent.
	 */
	private boolean matchesCachedSettings(RegistrationSettings registrationSettings)
	{
		if (!registrationSettings.applicationId.equals(getPreference(PREFERENCE_APPLICATION_ID, "")))
			return false;
		if (!registrationSettings.clientAppsAPIURL.equals(getPreference(PREFERENCE_REGISTERED_SERVER, "")))
			return false;
		return true;
	}

	/**
	 * Post a set of name/value pairs to the server at the specified url.
	 */
	private byte[] postToServer(String url, List<NameValuePair> nameValuePairs)
	{
		return executeHttpRequest(url, nameValuePairs);
	}

	/**
	 * Do a HTTP GET from the server at the specified url.
	 */
	private byte[] getFromServer(String url)
	{
		return executeHttpRequest(url, null);
	}

	/**
	 * Execute a GET (if nameValuePairs is null) or a POST.
	 */
	private byte[] executeHttpRequest(String url, List<NameValuePair> nameValuePairs)
	{
		byte[] bytes = null;
		try
		{
			HttpUriRequest request;
			if (nameValuePairs == null)
			{
				request = new HttpGet(url);
			}
			else
			{
				HttpPost httppost = new HttpPost(url);
				httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs, "UTF-8"));
				request = httppost;
			}

			// Specify the authentication token, if provided.
			String authenticationToken = getPreference(PREFERENCE_AUTHENTICATION_TOKEN, "");
			request.setHeader("Cookie", "login-token=" + authenticationToken);

			HttpClient httpclient = new DefaultHttpClient();

			// Execute HTTP Request
			HttpResponse response = httpclient.execute(request);
			bytes = EntityUtils.toByteArray(response.getEntity());
			int statusCode = response.getStatusLine().getStatusCode();
			if (!isSuccessfulStatusCode(statusCode))
			{
				log(LOG_ERROR, "Error reaching server at " + url);
				log(LOG_ERROR, "Status code: " + statusCode);
				log(LOG_ERROR, "Response: " + new String(bytes));
				onError(ERROR_CANNOT_SELF_REGISTER, "Server gave response code: " + statusCode);
				bytes = null;
			}
		} catch (Throwable e)
		{
			log(LOG_ERROR, "Exception when retrieving data!" + e.toString());
			onError(ERROR_CANNOT_SELF_REGISTER, e.toString());
		}
		return bytes;
	}

	private static boolean isSuccessfulStatusCode(int statusCode)
	{
		return statusCode >= 200 && statusCode < 300;
	}

	/**
	 * Override this method to handle errors.
	 * 
	 * @param errorId
	 *            one of the ERROR_* constants listed above. It is safe to test for object equality, eg if (errorId == ERROR_CANNOT_SELF_REGISTER)...
	 * @param debugText
	 *            text that may be useful in debugging.
	 */
	protected abstract void onError(String errorId, String debugText);

	/**
	 * Override this method to monitor changes in state.
	 * 
	 * @param newState
	 *            one of the STATE_* constants listed above. It is safe to test for object equality, eg if (newState == STATE_SELF_REGISTERED)...
	 */
	protected abstract void onStateChange(String newState);

	/**
	 * Initiate an asynchronous request to fetch the registration ID. onRegistered() should be called when it's available.
	 */
	protected abstract void requestIdAsync();

	/**
	 * Fetch the registrationId (which should be available at the time of this call).
	 * 
	 * @return the registration ID.
	 */
	protected abstract String getRegistrationId();

	/**
	 * Get the device ID.
	 * 
	 * @return the device ID.
	 */
	protected abstract String getDeviceId();

	/**
	 * Clear all preferences in persistent storage.
	 */
	protected abstract void clearAllPreferences();

	/**
	 * Set a preference in persistent storage.
	 * 
	 * @param key
	 *            the key of the preference to set.
	 * @param value
	 *            the value to set.
	 */
	protected abstract void setPreference(String key, String value);

	/**
	 * Get a preference from persistent storage.
	 * 
	 * @param key
	 *            the key of the preference to get.
	 * @param defaultValue
	 *            the default value.
	 * @return the value, or the defaultValue if no value is present.
	 */
	protected abstract String getPreference(String key, String defaultValue);

	/**
	 * @param logLevel
	 *            one of the LOG_* constants above.
	 * @param string
	 *            the string to log with the specified level (severity).
	 */
	protected abstract void log(char logLevel, String string);

	/**
	 * This method should be called once a registration ID has become available.
	 * 
	 * @param registrationId
	 */
	protected void onRegistered(String registrationId)
	{
		setState(STATE_RECEIVED_REG_ID);
		selfRegister(registrationId);
	}

	/**
	 * This method should be called when the push system becomes inactive.
	 */
	protected void onUnregistered()
	{
		setState(STATE_UNREGISTERED);
	}

	/**
	 * Process the metadata node that is provider-specific. Default does nothing.
	 * 
	 * @param jsonObject
	 *            the JSON object to process.
	 * @throws Exception
	 */
	protected void processMetadata(JSONObject jsonObject) throws Exception
	{
	}

	/**
	 * The RegistrationSettings class, which is passed to register().
	 */
	protected static class RegistrationSettings
	{
		/**
		 * The application ID. An application with this ID must have already been configured on the server.
		 */
		public String applicationId;
		/**
		 * The client-apps API URL of the CRX server (eg. "http://my.server.com:4502/aep/clientapps/api.json"). The server must have the server-side Push
		 * component installed.
		 */
		public String clientAppsAPIURL;
		/**
		 * The authentication token. This property both identifies the logged-in user on the CRX system and authenticates that user. It must have been
		 * previously obtained via the security API or by some other means such as basic authentication.
		 */
		public String authenticationToken;

		protected void validate()
		{
			validateNotEmpty(applicationId, "applicationId");
			validateNotEmpty(clientAppsAPIURL, "clientAppsAPIURL");
			validateNotEmpty(authenticationToken, "authenticationToken");
		}

		protected void validateNotEmpty(String s, String desc)
		{
			if (s == null || s.length() == 0)
				throw new IllegalArgumentException(desc + " must be specified");
		}
	}
}
