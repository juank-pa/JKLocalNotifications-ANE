package com.juankpro.ane.localnotif {
  import flash.events.IEventDispatcher;

  public interface IContext extends IEventDispatcher {
    function call(...args):*;
    function dispose():void;
  }
}
