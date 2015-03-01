package WaterTest 
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Amidos
	 */
	public class WaterSurfaceEntity extends Entity
	{
		//to draw the water surface dynamicly over it
		private var bitmapBuffer:BitmapData = new BitmapData(FP.width, FP.height, true, 0);
		//the height of the water at each sector
		private var waterHeight:Vector.<Number> = new Vector.<Number>();
		//velocity of the water at each sector
		private var waterVelocity:Vector.<Number> = new Vector.<Number>();
		//how much percentage the water height decrease each frame
		private var waterDamping:Number = 0.95;
		//the response of the water height to the velocity in each frame
		private var waterViscosity:Number = 0.1;
		//height of water when it is calm
		private var calmWaterHeight:Number = 300;
		//make the water surface consists of steps each equal 40
		private var xStep:Number = 40;
		
		//just for smoothing water surface
		private var blurFilter:BlurFilter = new BlurFilter(20, 20);
		
		public function WaterSurfaceEntity() 
		{
			//Just some intialization we can any values as start and I chose a sin wave as a start and zero velocity
			var numberOfWaterNodes:int = bitmapBuffer.width / xStep;
			for (var i:int = 0; i < numberOfWaterNodes; i++) 
			{
				waterHeight.push(Math.sin(i * 2 * Math.PI / numberOfWaterNodes) * 20 + calmWaterHeight);
				waterVelocity.push(0);
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			//to make vibration at mouseX position when mouse is pressed
			if (Input.mousePressed)
			{
				//position of the mouse with respect to the steps of the water surface
				var index:int = Input.mouseX / xStep;
				
				//make the waterheight goes down by 50 and all the neighbours
				if (index > 0 && index < waterHeight.length - 1)
				{
					waterHeight[index - 1] = calmWaterHeight + 40;
					waterHeight[index] = calmWaterHeight + 50;
					waterHeight[index + 1] = calmWaterHeight + 40;
				}
			}
			
			//Update the water surface
			for (var i:int = 1; i < waterVelocity.length - 1; i++) 
			{
				waterVelocity[i] += (waterHeight[i - 1] + waterHeight[i + 1] + calmWaterHeight) / 3 - waterHeight[i];
				waterVelocity[i] *= waterDamping;
				waterHeight[i] += waterVelocity[i] * waterViscosity;
			}
			
			waterHeight[0] = waterHeight[1];
			waterHeight[waterHeight.length - 1] = waterHeight[waterHeight.length - 2];
		}
		
		override public function render():void 
		{
			Draw.setTarget(bitmapBuffer);
			//Clear the bitmap
			bitmapBuffer.fillRect(new Rectangle(0, 0, bitmapBuffer.width, bitmapBuffer.height), 0);
			
			//draw the connected lines of the surface
			for (var i:int = 0; i < waterHeight.length - 1; i++) 
			{
				Draw.line(i * xStep, waterHeight[i], (i + 1) * xStep, waterHeight[i + 1]);
			}
			Draw.line((i) * xStep, waterHeight[i], bitmapBuffer.width, waterHeight[waterHeight.length - 1]);
			
			//fill the water instead of the bottom part of the image to look like water
			bitmapBuffer.floodFill(1, bitmapBuffer.height - 2, 0xFFFFFFFF);
			
			//smooth the surface
			bitmapBuffer.applyFilter(bitmapBuffer, new Rectangle(0, 0, bitmapBuffer.width, bitmapBuffer.height), new Point(), blurFilter);
			//colorize the smooth surface and make it look like water
			bitmapBuffer.threshold(bitmapBuffer, new Rectangle(0, 0, bitmapBuffer.width, bitmapBuffer.height), new Point(), ">", 0x11FFFFFF, 0xAA7DB0E0, 0xFFFFFFFF);
			
			FP.buffer.draw(bitmapBuffer);
		}
	}

}