class MyOwnCodeTypedWithMyOwnHands
{
  public static var lmfao:Float = 0.00;
  public static var bisexual:Int = 0;
  public static var pansexual:Float = 0.00;
  public static var lesbian:Int = 0;
  public static function ratingUpdate(gay:Int, gay2:Int, gay3:Float, gay4:Float)
  {
    if (PlayState.SONG.player2 == 'starved'){
      lmfao += gay3;
      pansexual += gay4;
      bisexual += gay;
      lesbian += gay2;
      trace('main accuracy:' + gay);
      trace('2nd accuracy:' + gay2);
    }
  }
}
