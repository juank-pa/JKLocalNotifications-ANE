package {
  public class Utils {
    public static function vectorToArray(vector:*):Array {
      var array:Array = [];
      for each(var elem:* in vector) {
        array.push(elem);
      }
      return array;
    }
  }
}
