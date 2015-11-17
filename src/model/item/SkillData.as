package model.item
{
	import controller.SpecController;
	
	import model.gameSpec.SkillItemSpec;

	public class SkillData
	{
		public var id:String;
		public var minLevel:int;
		public function SkillData(_id:String,_l:int)
		{
			id = _id;
			minLevel = _l;
		}
		
		public function get skillItemSpec():SkillItemSpec
		{
			return SpecController.instance.getItemSpec(id) as SkillItemSpec;
		}
	}
}