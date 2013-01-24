package {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	//
	public dynamic class colourSensor extends MovieClip {
		public var sensorPoint:Point;
		public function colourSensor(){
			this.sensorPoint = new Point(0,0);
		}
		public function senseStuff(){
			return(decodeColour(pickColorFromStage()));
		}
		
		internal function pickColorFromStage():uint {
		// from http://danikgames.com/blog/?p=379
			var bmd:BitmapData = new BitmapData(1, 1, false, 0xFFFFFF); // set colour to ?doc? background to deal with transparent bits
			var matrix:Matrix = new Matrix();
			var point:Point = localToGlobal(this.sensorPoint);
			matrix.translate(-point.x, -point.y);
			bmd.draw(stage, matrix);
			return bmd.getPixel(0, 0);
		}
		
		internal function decodeColour(sensorColour:uint = 0xFFFFFF):String {
			// colour detect: make B/W, RGB, CMY as points of a cube, sense distance and pick appropriate
			var colourArray:Array = new Array();
			colourArray["Red"] = 		{colour:"Red", dist: 1000000, r:0xFF, g:0x00, b:0x00};
			colourArray["Green"] = 		{colour:"Green", dist: 1000000, r:0x00, g:0xFF, b:0x00};
			colourArray["Blue"] = 		{colour:"Blue", dist: 1000000, r:0x00, g:0x00, b:0xFF};
			colourArray["Cyan"] = 		{colour:"Cyan", dist: 1000000, r:0x00, g:0xFF, b:0xFF};
			colourArray["Magenta"] = 	{colour:"Magenta", dist: 1000000, r:0xFF, g:0x00, b:0xFF};
			colourArray["Yellow"] = 	{colour:"Yellow", dist: 1000000, r:0xFF, g:0xFF, b:0x00};
			colourArray["Black"] = 		{colour:"Black", dist: 1000000, r:0x00, g:0x00, b:0x00};
			colourArray["White"] = 		{colour:"White", dist: 1000000, r:0xFF, g:0xFF, b:0xFF};
			colourArray["Grey"] = 		{colour:"Grey", dist: 1000000, r:0x7F, g:0x7F, b:0x7F}; // NB - do grey last, so that equidistant point is grey. Ha. not gonna work!
			var redComp = ((sensorColour >> 16 ) & 0xFF);
			var greenComp = ((sensorColour >> 8 ) & 0xFF);
			var blueComp = (sensorColour & 0xFF);
			var minDist:Number = 100; // effectively, a sphere around a colourpoint - if the sensed colour is further from this in an RGB cube of side 255, it's unrec.
			var returnColour:String = "Unrecognised"
			// loop through defined colours, looking for closest match, rejecting if none are close enough
			for each (var ob:Object in colourArray) {
				ob.dist = Math.sqrt(Math.pow(ob.r-redComp,2)+Math.pow(ob.b-blueComp,2)+Math.pow(ob.g-greenComp,2)); // distance to colourPoints
				returnColour = (ob.dist <= minDist) ? ob.colour : returnColour; // pick colour if closest (so far) and qualifying
				minDist = (ob.dist <= minDist) ? ob.dist : minDist; // track closest so far
			}
			return(returnColour);
		}
	}	
}
