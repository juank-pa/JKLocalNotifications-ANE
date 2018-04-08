package com.juankpro.ane.localnotif {
  import flash.notifications.*
  import flash.events.*;
  import flash.external.*;
  import flash.utils.*;
  import flash.desktop.*

  /** 
  * Dispatched when the notification has proccessed a call to <code>subscribe</code>. 
  * Because Android doesn't need subscription before sending any notification
  * this event always dispatches successfully allowing all kinds of notification types.
  * @eventType com.juankpro.ane.localnotif.NotificationEvent.SETTINGS_SUBSCRIBED
  * @see #subscribe()
  */ 
  [Event(name="settingsSubscribed", type="com.juankpro.ane.localnotif.NotificationEvent")]

  /** 
  * Dispatched when the user has interacted with the notification by tapping it or any
  * of the notification action buttons. 
  * @eventType com.juankpro.ane.localnotif.NotificationEvent.NOTIFICATION_ACTION
  * @see #subscribe()
  */ 
  [Event(name="notificationAction", type="com.juankpro.ane.localnotif.NotificationEvent")]
  
  /**
   * A class to notify the user of events that happen through notifications; it is used in conjunction
   * with the <code>Notification</code> class. If you want to listen to system notifications,
   * you must register to the <code>NotificationEvent.NOTIFICATION_ACTION</code> event.
   * <p>iOS devices need to register for notifications prior to sending them.</p>
   * <p>Android devices don't need to register before sending notifications unless they define custom
   * action buttons. There is not any harm in registering for notifications on Android devices even if
   * it doesn't define any custom actions. Android will still dispatch the <code>NotificationEvent.SETTINGS_SUBSCRIBED</code> event.</p>
   * <p>If subscription is needed then use the <code>subscribe</code> method to perform the subscription.</p>
   * <p>Supported OS: Android, iOS</p>
   * @see com.juankpro.ane.localnotif.Notification
   * @see com.juankpro.ane.localnotif.NotificationAction
   * @see com.juankpro.ane.localnotif.NotificationEvent
   * @see #needsSubscription
   * @see #subscribe()
   */
  public class NotificationManager extends EventDispatcher {
    CONFIG::device private static var _extensionContext:* = null;
    CONFIG::device private static var _refCount:int = 0;

    CONFIG::device private static const _contextType:String = "LocalNotificationsContext";

    CONFIG::device private static const STATUS:String = "status";
    CONFIG::device private static const NOTIFICATION_SELECTED:String = "notificationSelected";

    CONFIG::android private static var _defaultCategory:NotificationCategory = getDefaultCategory();

    private static function getDefaultCategory():NotificationCategory {
      CONFIG::device {
        CONFIG::android {
          return new NotificationCategory("_DefaultCategory", "Notifications", NotificationImportance.DEFAULT);
        }
      }
      return null;
    }

    CONFIG::test public static function _getDefaultCategory():NotificationCategory {
      CONFIG::android {
        return _defaultCategory;
      }
      return null;
    }

    CONFIG::device private var _disposed:Boolean;
    CONFIG::android private var _registeredCategories:Boolean;

    /**
     * Determines whether notifications are available for this platform or not.
     * Returns true only on mobile devices.
     * <p>Supported OS: Android, iOS</p>
     */
    public static function get isSupported():Boolean {
      CONFIG::device {
        return true;
      }
      return false;
    }

    /**
     * A list of supported notification styles.
     * <p>Supported OS: Android, iOS</p>
     * @see #subscribe()
     */
    public static const supportedNotificationStyles:Vector.<String> =
      Vector.<String>([
          NotificationStyle.BADGE,
          NotificationStyle.SOUND,
          NotificationStyle.ALERT]);

    /**
     * Previous versions returned true on iOS devices only. Currently, because Android devices 
     * may also need to register custom actions, this property returns true for all mobile devices.
     * Legacy code using this property will still work properly because Android devices will always dispatch
     * the <code>Event.SETTINGS_SUBSCRIBED</code> event successfully while subscribing, but for practical
     * cases, you should not use it anymore and depend only on <code>isSupported</code>.
     * <p>Supported OS: Android, iOS</p>
     * @see #subscribe()
     * @see #isSupported
     */
    [Deprecated("isSupported")]
    public static function get needsSubscription():Boolean {
        CONFIG::device {
          return true;
        }
        return false;
    }

    /**
     * Android 7.0 (API level 26) and higher can only send notification through notification channels. 
     * Notification categories translate to Android notification channels.
     * <p>If you haven't previously created any category because you didn't need any custom actions,
     * then a default category/channel will be created for your notifications. This default category
     * with id <code>"_DefaultCategory"</code> is called Notifications and has default importance, 
     * sound and vibration.</p>
     * <p>Use this method if you want to customize your default channel. It must be called before any
     * call to <code>notifyUser</code>. If you have already created your own custom categories then this 
     * method will have no effect.</p>
     * <p>Supported OS: Android</p>
     * @param identifier The default category identifier.
     * @param name The default category name.
     * @param importance The default category importance.
     * @param description The default category description.
     * @param soundName The default category sound.
     * @param shouldVibrate The default category vibration status.
     * @see com.juankpro.ane.localnotif.NotificationCategory
     */
    public static function setupDefaultCategory(identifier:String, name:String, importance:int = NotificationImportance.DEFAULT, description:String = null, soundName:String = null, shouldVibrate:Boolean = true):void {
        CONFIG::device {
          CONFIG::android {
            _defaultCategory.identifier = identifier;
            _defaultCategory.name = name;
            _defaultCategory.description = description;
            _defaultCategory.importance = importance;
            _defaultCategory.soundName = soundName;
            _defaultCategory.shouldVibrate = shouldVibrate;
          }
        }
    }

    /**
     * Initializes the notification manager.
     * <p>Supported OS: Android, iOS</p>
     * @param contextBuilder An optionally injectable ANE context builder. If the <code>contextBuilder</code>
     * is not set then the <code>flash.external.ExtensionContext</code> class will be used.
     */
    public function NotificationManager(contextBuilder:IContextBuilder = null) {
      CONFIG::device {
        if(_extensionContext == null) {
          var builder:* = contextBuilder || ExtensionContext;
          _extensionContext = builder.createExtensionContext("com.juankpro.ane.LocalNotification",
                                                             _contextType);
          CONFIG::android {
            NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
            NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);
          }
        }
        _refCount++;
      }
    }

    CONFIG::device private function activateHandler(e:Event):void {
      _extensionContext.call("activate");
    }

    CONFIG::device private function deactivateHandler(e:Event):void {
      _extensionContext.call("deactivate");
    }

    /**
     * @private
     */
    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
      super.addEventListener(type, listener, useCapture, priority, useWeakReference);

      CONFIG::device {
        if(_disposed) return;

        _extensionContext.addEventListener(StatusEvent.STATUS, onStatusEventReceived);

        if(type != NotificationEvent.NOTIFICATION_ACTION) return;

        _extensionContext.call("checkForNotificationAction");
      }
    }

    /**
     * Cancels the notification specified by the notification code.
     * <p>Supported OS: Android, iOS</p>
     * @param code The code of the notification to cancel
     * @see #cancelAll()
     */
    public function cancel(code:String):void {
      CONFIG::device {
        if(_disposed) return;
        _extensionContext.call("cancel", code);
      }
    }

    /**
     * Cancels all notifications.
     * <p>Supported OS: Android, iOS</p>
     * @see #cancel()
     */
    public function cancelAll():void {
      CONFIG::device {
        if(_disposed) return;

        _extensionContext.call("cancelAll");
      }
    }

    /**
     * Fires the notification with the specified behavior. On Android 7.0 (API level 26) and higher,
     * if no categories have been registered then this method will register a default one. To further
     * customize this default category use <code>setupDefaultCategory</code> before calling this method.
     * <p>Supported OS: Android, iOS</p>
     * @param code An identifier for this notification that is unique to the application.
     * The code can later be used to cancel the notification using the cancel method.
     * @param notification A <code>Notification</code> object describing how to notify the user. Must not be null.
     * @see com.juankpro.ane.localnotif.Notification
     * @see #setupDefaultCategory 
     */
    public function notifyUser(code:String, notification:Notification):void {
      CONFIG::device {
        if(_disposed) return;

        CONFIG::android {
          if(!_registeredCategories) {
            _extensionContext.call("registerDefaultCategory", _defaultCategory);
            _registeredCategories = true;
          }
        }

        withSerializeNotification(notification, function(n:Notification):void {
          _extensionContext.call("notify", code, n);
        });
      }
    }

    private function withSerializeNotification(notification:Notification, handler:Function):void {
      var originalData:* = notification.actionData;
      if (null != notification.actionData) {
        var data:ByteArray = new ByteArray();
        data.writeObject(notification.actionData);
        notification.actionData = data;
      }
      handler(notification);
      notification.actionData = originalData;
    }

    /**
     * @private
     */
    CONFIG::device private function onStatusEventReceived(event:StatusEvent):void {
      switch (event.code) {
      case NOTIFICATION_SELECTED:
        dispatchNotificationEvent();
        break;
      case NotificationEvent.SETTINGS_SUBSCRIBED:
        dispatchSettingsRegisteredEvent();
        break;
      default:
        dispatchEvent(event);
      }
    }

    /**
     * The application badge number. You can read and write this property.
     * This property allows resetting the application badge to zero or
     * any other value anytime. Setting it to zero removes the badge.
     * <p>Supported OS: iOS</p>
     */
    public function get applicationBadgeNumber():int {
      CONFIG::device {
        CONFIG::iphone {
          if(_disposed) return 0;
          return _extensionContext.call("getApplicationBadgeNumber") as int;
        }
      }
      return 0;
    }

    /**
     * @private
     */
    public function set applicationBadgeNumber(value:int):void {
      CONFIG::device {
        CONFIG::iphone {
          if(_disposed) return;
          _extensionContext.call("setApplicationBadgeNumber", value);
        }
      }
    }

    /**
     * Subscribes to receive local notifications. There is no harm in subscribing
     * to notifications on iOS and Android even if the Android version does not implement custom actions.
     * <p>On iOS, you have to subscribe prior to attempting to send
     * notifications otherwise the application will raise exceptions.</p>
     * <p>Android devices will always respond to a subscription positively for all notification types.</p>
     * <p>Once you call this method you can register to the
     * <code>NotificationEvent.SETTINGS_SUBSCRIBED</code> event that will
     * acknowledge your subscription and will also report the notification
     * types the user has accepted to receive.</p>
     * <p>Supported OS: Android, iOS</p>
     * @param options A <code>LocalNotifierSubscribeOptions</code> instance specifying the
     * subscription options.
     * @see com.juankpro.ane.localnotif.NotificationCategory
     * @see com.juankpro.ane.localnotif.NotificationAction
     */
    public function subscribe(options:LocalNotifierSubscribeOptions):void {
      CONFIG::device {
        _extensionContext.call("registerSettings", options);
        CONFIG::android {
            if (options.categories != null && options.categories.length > 0) {
              _registeredCategories = true;
            }
        }
      }
    }

    /**
     * Removes the Notification Manager from memory.
     * Once disposed any calls to the object methods will be ignored.
     * <p>Supported OS: Android, iOS</p>
     */
    public function dispose():void {
      CONFIG::device {
        if(!_disposed) {
          _disposed = true;
          _extensionContext.removeEventListener(StatusEvent.STATUS, onStatusEventReceived);

          _refCount--;
          if(_refCount == 0) {
            _extensionContext.dispose();
            _extensionContext = null;
          }
        }
      }
    }

    private function createAndDispatchEvent(event:String, handler:Function):void {
      var notificationEvent:NotificationEvent = new NotificationEvent(event);
      handler(notificationEvent);
      dispatchEvent(notificationEvent);
    }

    private function dispatchNotificationEvent():void {
      CONFIG::device {
        createAndDispatchEvent(
          NotificationEvent.NOTIFICATION_ACTION,
          function(notification:NotificationEvent):void {
            var data:ByteArray = _extensionContext.call("getSelectedNotificationData") as ByteArray;
            data.position = 0;

            try {
              notification.actionData = data.readObject();
            }
            catch (e:Error){}

            notification.notificationCode = String(_extensionContext.call("getSelectedNotificationCode"));
            notification.notificationAction = String(_extensionContext.call("getSelectedNotificationAction"));
            notification.notificationUserResponse = String(_extensionContext.call("getSelectedNotificationUserResponse"));
          }
        );
      }
    }

    private function dispatchSettingsRegisteredEvent():void {
      CONFIG::device {
        createAndDispatchEvent(
          NotificationEvent.SETTINGS_SUBSCRIBED,
          function(notification):void {
            var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions();
            options.notificationStyleFlags = _extensionContext.call("getSelectedSettings") as uint;
            notification.subscribeOptions = options;
          }
        );
      }
    }
  }
}
