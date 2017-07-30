package {
  import flash.display.*;
  import flash.events.*;
  import flash.text.*;
  import flash.ui.Mouse;
  import flash.notifications.NotificationStyle;
  import com.juankpro.ane.localnotif.*;

  [SWF(backgroundColor="#FFFFFF", width="320", height="480", frameRate="30")]
  public class Sample extends Sprite {

    private var notificationManager:NotificationManager;

    private var postButton:SimpleButton;
    private var cancelButton:SimpleButton;
    private var codeButton:SimpleButton;
    private var badgeButton:SimpleButton;
    private var clearButton:SimpleButton;
    private var notificationTF:TextField;
    private var contentsScaleFactor:int = 2;

    private static const NOTIFICATION_CODE:String = "NOTIFICATION_CODE_001";

    public function Sample() {
      addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.quality = StageQuality.BEST;

      stage.addEventListener(Event.RESIZE, resizeHandler);
    }

    private var initialized:Boolean = false;

    private function resizeHandler(event:Event):void {
      initApp();
      printMessage("Resized");
    }

    private function initApp():void {
      if (initialized) return;
      initialized = true;

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

      initUI();
      registerEvents();
    }

    private function settingsSubscribedHandler(event:NotificationEvent):void {
      printMessage("Settings: " + event.subscribeOptions.notificationStyles.join("\n"));
      registerEvents();
    }

    private function initUI():void {
      var top1:int = 20 * contentsScaleFactor;
      var top2:int = 80 * contentsScaleFactor;
      postButton = createButton("Post", 0, top1);
      cancelButton = createButton("Cancel", stage.stageWidth - 100 * contentsScaleFactor, top1);
      codeButton = createButton("By Code", 0, top2);
      badgeButton = createButton("Clear Badge", stage.stageWidth - 100 * contentsScaleFactor, top2);
      clearButton = createButton("Clear", 0, int(stage.stageHeight / 2) - 30 * contentsScaleFactor);

      addChild(postButton);
      addChild(cancelButton);
      addChild(codeButton);
      addChild(badgeButton);
      addChild(clearButton);

      notificationTF = createTextField(0, int(stage.stageHeight / 2),
         stage.stageWidth - 1, int(stage.stageHeight / 2) - 1);
      notificationTF.border = true;
      addChild(notificationTF);
    }

    private function printMessage(message:String, title:String = null):void {
      notificationTF.text += "-----\n" + (title? title + "\n" : "") + message + "\n";
      notificationTF.scrollV = notificationTF.maxScrollV;
    }

    private function clearMessages():void {
      notificationTF.text = "";
    }

    private function registerEvents():void {
      notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
      postButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      cancelButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      codeButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      badgeButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      clearButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
    }

    private function buttonClickHandler(event:MouseEvent):void {
      switch(event.target) {
        case postButton:
          var notification:Notification = new Notification();
          notification.title = "Sample Title";
          notification.body = "Body sample";
          notification.actionLabel = "Rumble";
          notification.soundName = "fx05.caf";
          notification.fireDate = new Date((new Date()).time + (15 * 1000));
          notification.numberAnnotation = 3;
          notification.actionData = {sampleData:"Hello World!"};

          notificationManager.notifyUser(NOTIFICATION_CODE, notification);
          printNotification('Posted Message', notification);
          break;
        case cancelButton:
          notificationManager.cancelAll();
          printMessage("Cancelled all notifications");
          break;
        case codeButton:
          notificationManager.cancel(NOTIFICATION_CODE);
          printMessage("Cancelled notification with code " + NOTIFICATION_CODE);
          break;
        case badgeButton:
          notificationManager.applicationBadgeNumber = 0;
          printMessage("Reset badge number to zero");
          break;
        case clearButton:
          clearMessages();
          break;
      }
    }

    private function printNotification(title:String, notification:Notification):void {
      printMessage(
        '\nTitle: ' + notification.title +
        '\nBody: ' + notification.body +
        '\nAction: ' + notification.actionLabel +
        '\nCode: ' + NOTIFICATION_CODE +
        '\nData: {' + notification.actionData.sampleData + '}' +
        '\nAnnotation: ' + notification.numberAnnotation +
        '\nfireDate: ' + notification.fireDate +
        '\nsoundName: ' + notification.soundName,
        title);
    }

    private function notificationActionHandler(event:NotificationEvent):void {
      printMessage("Code: " + event.notificationCode +
        "\nSample Data: {" + event.actionData.sampleData + "}",
        "Received notification");
    }

    private function createTextField(x:int, y:int, width:int, height:int):TextField {
      var textField:TextField = new TextField();
      textField.width = width;
      textField.height = height;
      textField.x = x;
      textField.y = y;

      var tf:TextFormat = textField.getTextFormat();
      tf.font = '_sans';
      tf.size = 14 * contentsScaleFactor;

      textField.defaultTextFormat = tf;
      textField.setTextFormat(tf);

      return textField;
    }

    private function createButton(label:String, x:int, y:int):SimpleButton {
      var button:SimpleButton = new SimpleButton();
      var w:int = 100 * contentsScaleFactor;
      var h:int = 30 * contentsScaleFactor;

      var buttonSprite:Sprite = new Sprite();
      buttonSprite.graphics.lineStyle(1, 0x555555);
      buttonSprite.graphics.beginFill(0xff000, 1);
      buttonSprite.graphics.drawRect(0, 0, w, h);
      buttonSprite.graphics.endFill();

      var buttonLabel:TextField = createTextField(0, 8 * contentsScaleFactor, w, h);

      var tf:TextFormat = buttonLabel.getTextFormat();
      tf.align = TextFormatAlign.CENTER;
      tf.font = "Helvetica";
      tf.size = 14 * contentsScaleFactor;

      buttonLabel.defaultTextFormat = tf;
      buttonLabel.setTextFormat(tf);

      buttonLabel.text = label;
      buttonSprite.addChild(buttonLabel);

      button.x = x;
      button.y = y;
      button.overState = button.downState = button.upState = button.hitTestState = buttonSprite;
      return button;
    }
  }
}
