package model.gameSpec
{
	import flash.geom.Point;

	public class MapItemSpec extends ItemSpec
	{
		public function MapItemSpec(data:Object)
		{
			super(data);
		}
		
		public var posiT:String;
		public function get totalT():Array
		{
			var arr:Array = posiT.split(",");
			var vec:Array = [];
			var pArr:Array ;
			for (var i:int=0; i<arr.length; i++){
				pArr = arr[i].split("|");
				vec.push(new Point(pArr[0],pArr[1]));
			}
			
			return vec;
		}
		
		
	}
}