package
{
  import asunit.textui.TestRunner;
  import asunit.framework.TestResult;
  import flash.display.Sprite;
  import AllTests;

  public class Main extends Sprite
  {
    public function Main()
    {
      var unittests:TestRunner = new TestRunner();
      stage.addChild(unittests);
      var result:TestResult = unittests.start(AllTests, null, TestRunner.SHOW_TRACE);
      result.addListener(new Listener());
    }
  }
}

import asunit.framework.*;
import asunit.errors.*;
import asunit.textui.*;
import flash.utils.*;
import flash.desktop.NativeApplication;

class Listener implements TestListener {
  private var count:int = 0;
  public function addError(test:Test, t:Error):void {}
  public function addFailure(test:Test, t:AssertionFailedError):void {}
  public function endTest(test:Test):void {
    count++;
    if(count == AllTests.tests.length) NativeApplication.nativeApplication.exit();
  }
  public function endTestMethod(test:Test, methodName:String):void {}
  public function run(test:Test):void {}
  public function startTest(test:Test):void {}
  public function startTestMethod(test:Test, methodName:String):void {}
}
