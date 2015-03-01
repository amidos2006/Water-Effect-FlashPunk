package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import WaterTest.TestWorld;
	
	/**
	 * ...
	 * @author Amidos
	 */
	public class Main extends Engine
	{
		
		public function Main():void 
		{
			super(640, 480);
			
			FP.world = new TestWorld();
		}	
	}
	
}