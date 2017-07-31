package com.juankpro.ane.localnotif {
  /**
   * This interface must be implemented by any object capable of returning an
   * ANE extension context or a proxy implementing <code>IContext</code>.
   */
  public interface IContextBuilder {
    /**
     * Builds and returns an extension context. The returned object must implement
     * <code>IContext</code>
     * @param contextID Is the id of the ANE extension context to create.
     * @param contextType Is a string identifying the type of extension to use. Optional.
     * @return The created context. Must implement <code>IContext</code>.
     * @see com.juankpro.ane.localnotif.IContext
     */
    function createExtensionContext(contextID: String, contextType: String):*;
  }
}
