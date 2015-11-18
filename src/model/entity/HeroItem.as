package model.entity
{
	import model.item.HeroData;

	public class HeroItem extends EntityItem
	{
		public function HeroItem(data:HeroData)
		{
			id = "10001";
			super(data);
		}
		
		override public function get texturecls():String
		{
			return "sheshou";
		}
		
		override public function get range():Number
		{
			return 100;
		}
		
		override public function get attackCycle():int
		{
			return 100;
		}
		
	}
}