package com.juankpro.ane.localnotif {
  public interface IContextBuilder {
    function createExtensionContext(contextID: String, contextType: String):*;
  }
}
