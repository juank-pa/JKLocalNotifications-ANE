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

    private var postXButton:SimpleButton;
    private var postYButton:SimpleButton;
    private var cancelButton:SimpleButton;
    private var codeButton:SimpleButton;
    private var badgeButton:SimpleButton;
    private var clearButton:SimpleButton;
    private var notificationTF:TextField;
    private var contentsScaleFactor:int = 2;

    private var categoryId:String;

    private static const NOTIFICATION_CODE:String = "NOTIFICATION_CODE_001";

    // Use this property to control whether the samples configures or not the default category
    private var shouldConfigureDefaultCategory:Boolean = false;

    // Use this property to enable or disable custom categories, if true configureDefaultCategory will be ignored
    private var useCustomCategories:Boolean = true;

    public function Sample() {
      addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.quality = StageQuality.BEST;

      stage.addEventListener(Event.RESIZE, resizeHandler);
    }

    private function resizeHandler(event:Event):void {
      stage.removeEventListener(Event.RESIZE, resizeHandler);
      initApp();
      printMessage("Resized");
    }

    private function createTextInputAction(icon:String, identifier:String, title:String, buttonTitle:String, placeholder:String, isBackground:Boolean = false):TextInputNotificationAction {
      var action:TextInputNotificationAction = setupAction(new TextInputNotificationAction(identifier, title, icon), isBackground) as TextInputNotificationAction;
      action.textInputButtonTitle = buttonTitle;
      action.textInputPlaceholder = placeholder;
      return action;
    }

    private function createAction(icon:String, identifier:String, title:String, isBackground:Boolean = false):NotificationAction {
      return setupAction(new NotificationAction(identifier, title, icon), isBackground);
    }

    private function setupAction(action:NotificationAction, isBackground:Boolean = false):NotificationAction {
      action.isBackground = isBackground;
      return action;
    }

    private function createCategory(identifier:String, name:String, actions:Vector.<NotificationAction>):NotificationCategory {
      var category:NotificationCategory = new NotificationCategory(identifier, name);
      category.actions = actions;
      if (identifier == "CategoryX") {
        category.soundName = "fx05.wav";
        category.importance = NotificationImportance.HIGH;
      }
      category.shouldVibrate = identifier == "CategoryX";
      category.description = "Cool notifications for " + name;
      category.useCustomDismissAction = true;
      return category;
    }

    private function createCategories():Vector.<NotificationCategory> {
      if (!useCustomCategories) return null;
      return Vector.<NotificationCategory>([
        createCategory(
          "CategoryX",
          "First Category",
          Vector.<NotificationAction>([
            createAction(NotificationIconType.DOCUMENT, "okAction", "OK", true),
            createTextInputAction(NotificationIconType.ALERT, "cancelAction", "Cancel", "Fight!", "Ready..."),
            createAction(NotificationIconType.FLAG, "resetAction", "Reset"),
            createAction(NotificationIconType.INFO, "alertAction", "Alert")
          ])
        ),
        createCategory(
          "CategoryY",
          "Second Category",
          Vector.<NotificationAction>([
            createAction(NotificationIconType.DOCUMENT, "newAction", "New")
          ])
        )
      ]);
    }

    private function configureDefaultCategory():void {
      if (!shouldConfigureDefaultCategory) return;

      categoryId = "MyCategory";
      NotificationManager.setupDefaultCategory(
        categoryId,
        "My Notifications",
        NotificationImportance.HIGH,
        "These are some cool notifications.",
        "fx05.wav", 
        false
      );
    }

    private function initApp():void {
      if (NotificationManager.isSupported) {
        configureDefaultCategory();

        notificationManager = new NotificationManager();

        var options:LocalNotifierSubscribeOptions =
          new LocalNotifierSubscribeOptions(createCategories());
        options.notificationStyles = NotificationManager.supportedNotificationStyles;

        notificationManager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED,
                                              settingsSubscribedHandler);
        notificationManager.subscribe(options);
      }

      initUI();
    }

    private function settingsSubscribedHandler(event:NotificationEvent):void {
      printMessage("Settings: " + event.subscribeOptions.notificationStyles.join("\n"));
      registerEvents();
    }

    private function initUI():void {
      var top1:int = 20 * contentsScaleFactor;
      var top2:int = 80 * contentsScaleFactor;
      postXButton = createButton(useCustomCategories? "Post X" : "Post", 0, top1);
      if (useCustomCategories) {
      	postYButton = createButton("Post Y", 110 * contentsScaleFactor, top1);
        addChild(postYButton);
      }
      cancelButton = createButton("Cancel", stage.stageWidth - 100 * contentsScaleFactor, top1);
      codeButton = createButton("By Code", 0, top2);
      badgeButton = createButton("Clear Badge", stage.stageWidth - 100 * contentsScaleFactor, top2);
      clearButton = createButton("Clear", 0, int(stage.stageHeight / 2) - 30 * contentsScaleFactor);

      addChild(postXButton);
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
      postXButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      if(postYButton != null) postYButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      cancelButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      codeButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      badgeButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      clearButton.addEventListener(MouseEvent.CLICK, buttonClickHandler);
      notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
    }

    private function buttonClickHandler(event:MouseEvent):void {
      switch(event.target) {
        case postXButton: case postYButton:
          var code:String = NOTIFICATION_CODE + (event.target == postXButton? "X" : "Y");

          var notification:Notification = new Notification();
          notification.title = "Sample Title";
          notification.body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque condimentum magna a interdum pharetra. Integer pharetra magna at viverra lobortis.";
          notification.actionLabel = "Rumble";
          if (event.target == postXButton) {
            notification.soundName = "fx05.wav";
          }
          notification.fireDate = new Date((new Date()).time + (10 * 1000));
          notification.numberAnnotation = event.target == postXButton? 3 : 1;
          notification.iconType = event.target == postXButton? "ic_stat_notify_dog_icon" : NotificationIconType.ALERT;
          notification.launchImage = "DefaultPink.png";
          notification.tickerText = "test ticker";
          notification.priority = event.target == postXButton? NotificationPriority.HIGH : NotificationPriority.DEFAULT;
          notification.showInForeground = true;

          if (useCustomCategories) {
           notification.category = event.target == postXButton? "CategoryX" : "CategoryY";
          }
          else if (categoryId) {
            notification.category = categoryId;
          }

          notification.actionData = {sampleData:"Hello World! @ " + notification.category};

          notificationManager.notifyUser(code, notification);
          printNotification('Posted Message', notification, code);
          break;
        case cancelButton:
          notificationManager.cancelAll();
          printMessage("Cancelled all notifications");
          break;
        case codeButton:
          notificationManager.cancel(NOTIFICATION_CODE + "X");
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

    private function printNotification(title:String, notification:Notification, code:String):void {
      printMessage(
        '\nTitle: ' + notification.title +
        '\nBody: ' + notification.body +
        '\nAction: ' + notification.actionLabel +
        '\nCode: ' + code +
        '\nData: {' + notification.actionData.sampleData + '}' +
        '\nAnnotation: ' + notification.numberAnnotation +
        '\nfireDate: ' + notification.fireDate +
        '\nsoundName: ' + notification.soundName,
        title);
    }

    private function notificationActionHandler(event:NotificationEvent):void {
      printMessage("Code: " + event.notificationCode +
        "\nSample Data: {" + event.actionData.sampleData + "}" +
        "\nAction: " + event.notificationAction +
        "\nUser Response: " + event.notificationUserResponse,
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
