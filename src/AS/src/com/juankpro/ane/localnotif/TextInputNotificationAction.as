package com.juankpro.ane.localnotif {
  /**
   * This class represents an action button that allows the user enter text in a text input
   * before proceeding to interact with the notification. This text can then be processed by
   * the <code>NotificationEvent</code>.
   * <p>Text input notifications are supported since iOS 9.0 and Android 7.0 (API level 24).
   * On previous OS versions, text input actions will gracefully downgrade to normal actions.</p>
   * <p>All actions must be part of a category that must be registered at application
   * startup using <code>NotificationManager.subscribe</code>.</p>
   * <p>Supported OS: Android, iOS</p>
   * @see com.juankpro.ane.localnotif.NotificationManager#subscribe()
   */
  public class TextInputNotificationAction extends NotificationAction {
    /**
     * This is the label used for the button next to the text input that the user
     * taps to accept the entered text. Android devices show a system provided button
     * instead and thus it ignores the button title.
     * <p>Supported OS: iOS</p>
     */
    public var textInputButtonTitle:String;

    /**
     * This is the placeholder text shown inside the text input box when no text
     * has yet been entered by the user.
     * <p>Supported OS: Android, iOS</p>
     */
    public var textInputPlaceholder:String;
  }
}