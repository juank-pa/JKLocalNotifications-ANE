package {
  import asunit.framework.TestCase;
  import flash.events.StatusEvent;
  import flash.notifications.NotificationStyle;
  import com.juankpro.ane.localnotif.NotificationManager;
  import com.juankpro.ane.localnotif.Notification;
  import com.juankpro.ane.localnotif.NotificationCategory;
  import com.juankpro.ane.localnotif.NotificationEvent;
  import com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions;
  import flash.utils.ByteArray;

  public class TestNotificationManager extends TestCase {
    private var manager:NotificationManager;
    private var mockContext:MockContext;
    private var mockContextBuilder:MockContextBuilder;

    public function TestNotificationManager(testName: String = null) {
      super(testName);
    }

    override protected function setUp():void {
      super.setUp();
      mockContext = new MockContext();
      mockContextBuilder = new MockContextBuilder();
      mockContextBuilder.expects("createExtensionContext").withArgs(
        "com.juankpro.ane.LocalNotification",
        "LocalNotificationsContext"
      ).willReturn(mockContext);

      manager = new NotificationManager(mockContextBuilder);
    }

    override protected function tearDown():void {
      super.tearDown();
      manager.dispose();
    }

    public function testIsSupported():void {
      CONFIG::device {
        assertTrue("Is supported on device", NotificationManager.isSupported);
        return;
      }
      assertFalse("Is supported on device", NotificationManager.isSupported);
    }

    public function testSupportedNotificationStyles():void {
      assertEqualsArrays(Utils.vectorToArray(NotificationManager.supportedNotificationStyles),
                         [NotificationStyle.BADGE, NotificationStyle.SOUND, NotificationStyle.ALERT]);
      return;
    }

    CONFIG::android public function testSetupDefaultCategory():void {
      var defaultCategory:NotificationCategory = NotificationManager._getDefaultCategory();
      assertEquals(defaultCategory.identifier, "_DefaultCategory");
      assertEquals(defaultCategory.name, "Notifications");
      assertNull(defaultCategory.description);
      assertNull(defaultCategory.soundName);
      assertTrue(defaultCategory.shouldVibrate);
      assertEquals(defaultCategory.importance, 3);

      NotificationManager.setupDefaultCategory(
        "NewId",
        "New Name",
        5,
        "My Description",
        "sound.mp3",
        false
      )

      assertEquals(defaultCategory.identifier, "NewId");
      assertEquals(defaultCategory.name, "New Name");
      assertEquals(defaultCategory.description, "My Description");
      assertEquals(defaultCategory.soundName, "sound.mp3");
      assertFalse(defaultCategory.shouldVibrate);
      assertEquals(defaultCategory.importance, 5);
    }

    public function testInstantiation():void {
      CONFIG::device {
        assertTrue(mockContextBuilder.errorMessage(), mockContextBuilder.success());
        return;
      }

      assertFalse("Should not call context", mockContextBuilder.success());
    }

    public function testCancel():void {
      mockContext.expects("call").withArgs("cancel", "myCode").noReturn();
      manager.cancel("myCode");

      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testCancelAll():void {
      mockContext.expects("call").withArgs("cancelAll").noReturn();
      manager.cancelAll();
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testNotifyUser():void {
      var notification:Notification = new Notification();
      mockContext.expects("call").withArgs("notify", "MyCode", notification).noReturn();
      CONFIG::android {
        mockContext.expects("call").withArgs("registerDefaultCategory", NotificationManager._getDefaultCategory()).noReturn();
      }
      manager.notifyUser("MyCode", notification);
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testNotifyUserWithActionData():void {
      var notification:Notification = new Notification();
      var obj:Array = ["test", "data"];
      notification.actionData = obj;
      mockContext.expects("call").withArgs("notify", "MyCode", notification).noReturn();

      var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions();
      mockContext.expects("call").withArgs("registerSettings", options).noReturn();

      CONFIG::android {
        // Even after subscribing but with no categories
        mockContext.expects("call").withArgs("registerDefaultCategory", NotificationManager._getDefaultCategory()).noReturn();
      }

      manager.subscribe(options);
      manager.notifyUser("MyCode", notification);

      CONFIG::device {
        assertEqualsArrays(notification.actionData, obj);
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertSame(obj, notification.actionData);
      assertFalse("Should not call context", mockContext.success());
    }

    public function testNotifyUserDoesNotSubscribeIfCategoriesWhereAlreadyAdded():void {
      mockContext.expects("call").withArgs("notify", "MyCode", notification).noReturn();

      var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions(
        Vector.<NotificationCategory>([new NotificationCategory()])
      );
      mockContext.expects("call").withArgs("registerSettings", options).noReturn();
      // Not expecting a call to "registerDefaultCategory" (no exception)

      manager.subscribe(options);
      manager.notifyUser("MyCode", notification);
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testNotifyUserShouldRegisterCategoriesOnlyOnce():void {
      var notification:Notification = new Notification();
      var category:NotificationCategory = new NotificationCategory();
      mockContext.expects("call").times(2).withArgs("notify", "MyCode", notification).noReturn();
      CONFIG::android {
        mockContext.expects("call").withArgs("registerDefaultCategory", NotificationManager._getDefaultCategory()).noReturn();
      }
      manager.notifyUser("MyCode", notification);
      manager.notifyUser("MyCode", notification);
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testSetApplicationBadgeNumber():void {
      mockContext.expects("call").withArgs("setApplicationBadgeNumber", 30).noReturn();
      CONFIG::device {
        CONFIG::iphone
        {
          manager.applicationBadgeNumber = 30;
          assertTrue(mockContext.errorMessage(), mockContext.success());
          return;
        }
     }

      assertFalse("Should not call context", mockContext.success());
    }

    public function testGetApplicationBadgeNumber():void {
      mockContext.expects("call").withArgs("getApplicationBadgeNumber").willReturn(10);
      CONFIG::device {
        CONFIG::iphone {
          assertEquals(10, manager.applicationBadgeNumber);
          assertTrue(mockContext.errorMessage(), mockContext.success());
          return;
        }
      }

      assertEquals(0, manager.applicationBadgeNumber);
      assertFalse("Should not call context", mockContext.success());
    }

    public function testAddEventListenerForNotificationActionEvent():void {
      mockContext.expects("call").withArgs("checkForNotificationAction").noReturn();
      manager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, function():void {})
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testAddEventListenerForAnyOtherEvent():void {
      mockContext.expects("call").withArgs("checkForNotificationAction").noReturn();
      manager.addEventListener("anyEvent", function():void {})
      assertFalse("Should not call context", mockContext.success());
    }

    public function testStatusEventNotificationSelected():void {
      var byteArray:ByteArray = new ByteArray();
      var testObject:Object = ["test", "object"];
      byteArray.writeObject(testObject);

      mockContext.expects("call").withArgs("checkForNotificationAction").noReturn();
      mockContext.expects("call").withArgs("getSelectedNotificationData").willReturn(byteArray);
      mockContext.expects("call").withArgs("getSelectedNotificationCode").willReturn("MyCode");
      mockContext.expects("call").withArgs("getSelectedNotificationAction").willReturn("ActionId");
      mockContext.expects("call").withArgs("getSelectedNotificationUserResponse").willReturn("response");

      manager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, function(event:NotificationEvent):void {
        assertEqualsArrays(testObject, event.actionData);
        assertEquals("MyCode", event.notificationCode);
        assertEquals("ActionId", event.notificationAction);
        assertEquals("response", event.notificationUserResponse);
      });

      mockContext.dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "notificationSelected"));
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testStatusEventSettingsSubscribed():void {
      mockContext.expects("call").withArgs("checkForNotificationAction").times(0);
      mockContext.expects("call").withArgs("getSelectedSettings").willReturn(5);

      manager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED, function(event:NotificationEvent):void {
          assertEquals(5, event.subscribeOptions.notificationStyleFlags);
      });

      mockContext.dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "settingsSubscribed"));
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testSubscribe():void {
      var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions();
      options.notificationStyles = Vector.<String>([NotificationStyle.SOUND, NotificationStyle.BADGE]);
      mockContext.expects("call").withArgs("registerSettings", options).noReturn();
      manager.subscribe(options);
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testDispose():void {
      mockContext.expects("dispose").times(1).noReturn();

      (new NotificationManager(new MockContextBuilder())).dispose();
      manager.dispose();
      CONFIG::device {
        assertTrue(mockContext.errorMessage(), mockContext.success());
        return;
      }
      assertFalse("Should not call context", mockContext.success());
    }

    public function testEventsNotDispatchedAfterDispose():void {
      var dispatchedEvent:Boolean = false;
      manager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED, function(event:NotificationEvent):void {
        dispatchedEvent = true;
      });
      manager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, function(event:NotificationEvent):void {
        dispatchedEvent = true;
      });
      manager.dispose();
      mockContext.dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "settingsSubscribed"));
      mockContext.dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, "notificationAction"));
      assertFalse("Dispatched event", dispatchedEvent);
    }

    public function testDisabledNotifyUserWhenDisposed():void {
      var notification:Notification = new Notification();
      mockContext.expects("call").withArgs("notify", "code", notification);
      manager.dispose();
      manager.notifyUser("code", notification);
      assertFalse("Should not call context", mockContext.success());
    }

    public function testDisabledCancelWhenDisposed():void {
      mockContext.expects("call").withArgs("cancel", "code");
      manager.dispose();
      manager.cancel("code");
      assertFalse("Should not call context", mockContext.success());
    }

    public function testDisabledCancelAllWhenDisposed():void {
      mockContext.expects("call").withArgs("cancelAll");
      manager.dispose();
      manager.cancelAll();
      assertFalse("Should not call context", mockContext.success());
    }

    public function testDisabledCheckNotificationsWhenDisposed():void {
      mockContext.expects("call").withArgs("checkForNotificationAction");
      manager.dispose();
      manager.addEventListener("any", function():void {});
      assertFalse("Should not call context", mockContext.success());
    }

    public function testDisabledSetApplicationBadgeNumberWhenDisposed():void {
      mockContext.expects("call").withArgs("setApplicationBadgeNumber", 10);
      manager.dispose();
      manager.applicationBadgeNumber = 10;
      assertFalse("Should not call context", mockContext.success());
    }

    public function testDisabledGetApplicationBadgeNumberWhenDisposed():void {
      mockContext.expects("call").withArgs("getApplicationBadgeNumber").willReturn(10);
      manager.dispose();
      assertEquals(0, manager.applicationBadgeNumber);
      assertFalse("Should not call context", mockContext.success());
    }
  }
}

import flash.events.EventDispatcher;
import flash.events.Event;
import com.juankpro.ane.localnotif.IContext;
import com.juankpro.ane.localnotif.IContextBuilder;
import com.juankpro.ane.localnotif.Notification;
import org.mock4as.Mock;

class MockContextBuilder extends Mock implements IContextBuilder {
  public function createExtensionContext(contextId:String, contextType:String):* {
    record("createExtensionContext", contextId, contextType);
    return expectedReturnFor("createExtensionContext");
  }
}

class MockContext extends Mock implements IContext {
  private var dispatcher:EventDispatcher;

  public function MockContext():void {
    dispatcher = new EventDispatcher(this);
  }

  public function call(...args):* {
    record.apply(this, ["call"].concat(args));
    return expectedReturnFor("call");
  }
  public function dispose():void {
    record("dispose");
  }

  public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
    dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
  }
  public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
    dispatcher.removeEventListener(type, listener, useCapture);
  }
  public function dispatchEvent(event:Event):Boolean {
    return dispatcher.dispatchEvent(event);
  }
  public function hasEventListener(type:String):Boolean {
    return dispatcher.hasEventListener(type);
  }
  public function willTrigger(type:String):Boolean {
    return dispatcher.willTrigger(type);
  }
}
