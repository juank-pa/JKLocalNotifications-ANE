package com.juankpro.ane.localnotif {
  import flash.events.IEventDispatcher;

  /**
   * This interface must be implemented by objects that will
   * send messages to native applications through an extension context.
   * Objects returned by <code>IContextBuilder.createExtensionContext</code> must
   * implement this methods.
   * @see com.juankpro.ane.localnotif.IContextBuilder
   */
  public interface IContext extends IEventDispatcher {
    /**
     * Calls a function in the native context.
     */
    function call(...args):*;
    /**
     * Disposes the native context.
     */
    function dispose():void;
  }
}
