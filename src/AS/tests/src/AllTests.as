package {
  import asunit.framework.TestSuite;

  public class AllTests extends TestSuite {
    public static var tests:Array = [
      TestLocalNotifierSubscriberOptions,
      TestNotificationManager
    ];
    public function AllTests() {
      super();
      for each(var cls:Class in tests) {
        addTest(new cls());
      }
    }
  }
}
