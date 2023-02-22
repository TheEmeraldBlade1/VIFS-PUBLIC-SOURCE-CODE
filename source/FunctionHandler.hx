class FunctionHandler
{
	public static var combobreaks:Int = 0;

	public static function combobreak()
	{
		combobreaks += 1;
		trace("broken combo");
	}
}