package WaterTest 
{
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TestWorld extends World
	{
		[Embed(source = "../../assets/Background.png")]private var image:Class;
		public function TestWorld() 
		{
			
		}
		
		override public function begin():void 
		{
			super.begin();
			var waterSurface:WaterSurfaceEntity = new WaterSurfaceEntity();
			var background:Backdrop = new Backdrop(image);
			
			addGraphic(background, 1);
			add(waterSurface);
		}
		
	}

}