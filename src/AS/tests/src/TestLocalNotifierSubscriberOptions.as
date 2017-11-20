package {
  import asunit.framework.TestCase;
  import com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions;
  import flash.notifications.NotificationStyle;
  import com.juankpro.ane.localnotif.NotificationCategory;

  public class TestLocalNotifierSubscriberOptions extends TestCase {
    private var options:LocalNotifierSubscribeOptions;

    public function TestLocalNotifierSubscriberOptions(testName: String = null) {
      super(testName);
    }

    override protected function setUp():void {
      super.setUp();
      options = new LocalNotifierSubscribeOptions();
    }

    public function testInitializationWithActions():void {
      var actions:Vector.<NotificationCategory> = new Vector.<NotificationCategory>();
      options = new LocalNotifierSubscribeOptions(actions);
      assertSame(actions, options.categories);
    }

    public function testInitializationWithNoActions():void {
      options = new LocalNotifierSubscribeOptions();
      assertEquals(0, options.categories.length);
    }

    public function testSetNotificationStyleBadgeFlag():void {
      options.notificationStyleFlags = 1;
      assertEqualsArrays([NotificationStyle.BADGE], Utils.vectorToArray(options.notificationStyles));
    }

    public function testSetNotificationStyleSoundFlag():void {
      options.notificationStyleFlags = 2;
      assertEqualsArrays([NotificationStyle.SOUND], Utils.vectorToArray(options.notificationStyles));
    }

    public function testSetNotificationStyleAlertFlag():void {
      options.notificationStyleFlags = 4;
      assertEqualsArrays([NotificationStyle.ALERT], Utils.vectorToArray(options.notificationStyles));
    }

    public function testSetNotificationStyleFlagCombinations():void {
      options.notificationStyleFlags = 3;
      assertEqualsArrays([NotificationStyle.BADGE,NotificationStyle.SOUND],
        Utils.vectorToArray(options.notificationStyles));

      options.notificationStyleFlags = 5;
      assertEqualsArrays([NotificationStyle.BADGE,NotificationStyle.ALERT],
        Utils.vectorToArray(options.notificationStyles));

      options.notificationStyleFlags = 6;
      assertEqualsArrays([NotificationStyle.SOUND,NotificationStyle.ALERT],
        Utils.vectorToArray(options.notificationStyles));

      options.notificationStyleFlags = 7;
      assertEqualsArrays([NotificationStyle.BADGE,NotificationStyle.SOUND,NotificationStyle.ALERT],
        Utils.vectorToArray(options.notificationStyles));
    }

    public function testSetNotificationStyleUnknownFlag():void {
      options.notificationStyleFlags = 8;
      assertEqualsArrays([], Utils.vectorToArray(options.notificationStyles));

      options.notificationStyleFlags = 0;
      assertEqualsArrays([], Utils.vectorToArray(options.notificationStyles));
    }

    public function testNotificationStyleWithNoFlags():void {
      options.notificationStyles = null;
      assertEquals(0, options.notificationStyleFlags);

      options.notificationStyles = new Vector.<String>();
      assertEquals(0, options.notificationStyleFlags);
    }

    public function testNotificationStyleFlagsForBadge():void {
      options.notificationStyles = Vector.<String>([NotificationStyle.BADGE]);
      assertEquals(1, options.notificationStyleFlags);
    }

    public function testNotificationStyleFlagsForSound():void {
      options.notificationStyles = Vector.<String>([NotificationStyle.SOUND]);
      assertEquals(2, options.notificationStyleFlags);
    }

    public function testNotificationStyleFlagsForAlert():void {
      options.notificationStyles = Vector.<String>([NotificationStyle.ALERT]);
      assertEquals(4, options.notificationStyleFlags);
    }

    public function testNotificationStyleFlagsForCombinations():void {
      options.notificationStyles = Vector.<String>(
        [NotificationStyle.BADGE,NotificationStyle.SOUND]
      );
      assertEquals(3, options.notificationStyleFlags);

      options.notificationStyles = Vector.<String>(
        [NotificationStyle.BADGE,NotificationStyle.ALERT]
      );
      assertEquals(5, options.notificationStyleFlags);

      options.notificationStyles = Vector.<String>(
        [NotificationStyle.SOUND,NotificationStyle.ALERT]
      );
      assertEquals(6, options.notificationStyleFlags);

      options.notificationStyles = Vector.<String>(
        [NotificationStyle.BADGE,NotificationStyle.SOUND,NotificationStyle.ALERT]
      );
      assertEquals(7, options.notificationStyleFlags);
    }
  }
}
