package model.entity
{
	import controller.SpecController;
	
	import model.gameSpec.SoldierItemSpec;
	
	import view.bullet.Sword;

	public class EntityItem
	{
		public function EntityItem(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in EntityItem: EntityItem["+str+"]="+data[str]);
				}
			}
			
		}
		
		public var id:String;
		
		
		private var _spec:SoldierItemSpec;
		public function get entitySpec():SoldierItemSpec
		{
			if(!_spec){
				_spec = SpecController.instance.getItemSpec(id) as SoldierItemSpec;
			}
			return _spec;
		}
		
		public function get texturecls():String
		{
			return entitySpec.name;
		}
		
		public function get range():Number
		{
			return entitySpec.range;
		}
		
		public function get attackCycle():int
		{
			return entitySpec.attackCycle;
		}
		
		public var armClass:Class = Sword;
		
		
	}
}