package model.gameSpec
{
	import model.item.SkillData;

	public class SoldierItemSpec extends ItemSpec
	{
		public function SoldierItemSpec(data:Object)
		{
			super(data);
		}
		
		public var curSkill:String;
		public function get skills():Array
		{
			var arr:Array = [];
			var arr1:Array = curSkill.split(";");
			var arr2:Array ;
			for each(var str:String in arr1)
			{
				arr2 = str.split(":");
				arr.push(new SkillData(arr2[1],arr2[0]));
			}
			return arr;
		}
		
		public var runx:Number;
		public var runy:Number;
		public var attackx:Number;
		public var attacky:Number;
		public var standx:Number;
		public var standy:Number;
		
		public var rectw:Number;
		public var recty:Number;
		
		public var sound:String;
		public var range:int;
		public var attackCycle:int;
		public var speed:int;
		public var baseAttack:int;
		public var attackUp:int;
	}
}