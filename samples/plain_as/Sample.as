package {
  import flash.display.Sprite;
  import flash.display.SimpleButton;
  import flash.display.StageScaleMode;
  import flash.display.StageAlign;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.ui.Mouse;
  import flash.notifications.NotificationStyle;
  import com.juankpro.ane.localnotif.NotificationManager;
  import com.juankpro.ane.localnotif.Notification;
  import com.juankpro.ane.localnotif.NotificationEvent;
  import com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions;
  import flash.text.TextField;

  public class Sample extends Sprite {

    private var notificationManager:NotificationManager;

    private var button1:SimpleButton;
    private var button2:SimpleButton;
    private var button3:SimpleButton;
    private var notificationTF:TextField;

    private static const NOTIFICATION_CODE:String = "NOTIFICATION_CODE_001";

    public function Sample() {
      trace("OK");

      addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
      /*if(NotificationManager.isSupported) {
        notificationManager = new NotificationManager();

        if(NotificationManager.needsSubsciption) {
          trace("Subs");
          var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions();
          options.notificationStyles = NotificationManager.supportedNotificationStyles;
          notificationManager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED,
                                               settingsSubscribedHandler);
          notificationManager.subscribe(options);
        }
        else {
          initApp();
        }
      }*/
    }

    private function addedToStageHandler(event:Event):void {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;

      if (NotificationManager.isSupported) {
        notificationManager = new NotificationManager();

        if (NotificationManager.needsSubsciption) {
          var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions();
          options.notificationStyles = NotificationManager.supportedNotificationStyles;
          notificationManager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED,
                                               settingsSubscribedHandler);
          notificationManager.subscribe(options);
        }
      }

      initApp();
    }

    private function settingsSubscribedHandler(event:NotificationEvent):void {
      initApp();
    }

    private function initApp():void {
      addChild(createButton("test", 0, 0));

      //notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
      //button1.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      //button2.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      //button3.addEventListener(MouseEvent.CLICK, buttonClickHandler);
    }

    private function buttonClickHandler(event:MouseEvent):void {
      switch(event.target) {
        case button1:
          trace("button");
          var notification:Notification = new Notification();
          notification.actionLabel = "OK";
          notification.body = "Body sample";
          notification.title = "Title";
          notification.soundName = "fx05.caf";
          notification.fireDate = new Date((new Date()).time + (60 * 3 * 1000));
          notification.numberAnnotation = 1;
          notification.actionData = {sampleData:"Hello World!"}

          notificationManager.notifyUser(NOTIFICATION_CODE, notification);
          break;
        case button2:
          notificationManager.cancel(NOTIFICATION_CODE);
          break;
        case button3:
          notificationManager.applicationBadgeNumber = 0;
          notificationTF.text = "";
          break;
      }
    }

    private function notificationActionHandler(event:NotificationEvent):void {
      notificationTF.text = "Notification Code: " + event.notificationCode +
        "\nSample Data: {" + event.actionData.sampleData + "}\n\n";
    }

    private function createTextField(x:int, y:int, width:int, height:int):TextField {
      var textField:TextField = new TextField();
      textField.width = width;
      textField.height = height;
      textField.x = x;
      textField.y = y;
      return textField;
    }

    private function createButton(label:String, x:int, y:int):SimpleButton {
      var button:SimpleButton = new SimpleButton();
      var w:int = 100;
      var h:int = 30;

      var buttonSprite:Sprite = new Sprite();
      buttonSprite.graphics.lineStyle(1, 0x555555);
      buttonSprite.graphics.beginFill(0xff000, 1);
      buttonSprite.graphics.drawRect(0, 0, w, h);
      buttonSprite.graphics.endFill();

      var buttonLabel:TextField = createTextField(0, 0, w, h);
      buttonLabel.text = label;
      buttonSprite.addChild(buttonLabel);

      button.x = x;
      button.y = y;
      button.overState = button.downState = button.upState = button.hitTestState = buttonSprite;
      return button;
    }
  }
}
