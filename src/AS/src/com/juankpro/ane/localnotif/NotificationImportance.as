package com.juankpro.ane.localnotif {
	/**
	 * A class of constants representing the <code>importance</code> of a
   * <code>NotificationChannel</code>.
	 * <p>Supported OS: Android</p>
   * @see com.juankpro.ane.localnotif.NotificationChannel
	 */
  public class NotificationImportance {
    /**
     * Notification shows everywhere, makes noise, and peeks.
     */
    public static const HIGH:int = 4;

    /**
     * Notification shows everywhere, makes noise, but does not visually intrude.
     */
    public static const DEFAULT:int = 3;

    /**
     * Notification shows everywhere, but is not intrusive.
     */
    public static const LOW:int = 2;

    /**
     * Notification shows only on shade.
     */
    public static const MIN:int = 1;

    /**
     * Notification does not show in the shade.
     */
    public static const NONE:int = 0;
  }
}
