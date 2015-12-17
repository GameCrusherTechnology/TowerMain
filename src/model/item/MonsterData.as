package model.item
{
	import controller.SpecController;
	
	import model.gameSpec.SoldierItemSpec;

	public class MonsterData
	{
		
		public function MonsterData(_id:String,_level:int,_pos:Number,time:int=0)
		{
			id=_id;
			level = _level;
			pos = _pos;
			timeCount = time;
		}
		public var id:String;
		public var level:int;
		public var pos:Number;
		public var timeCount:int;
		public function get monsterSpec():SoldierItemSpec
		{
			return SpecController.instance.getItemSpec(id) as SoldierItemSpec;
		}
			
		public function getSkills():Array
		{
			var skills:Array = [];
			var arr:Array = monsterSpec.skills;
			for each(var data:SkillData in arr){
				if(data.minLevel <= level)
				{
					skills.push(data);
				}
			}
			return skills;
		}
	}
}