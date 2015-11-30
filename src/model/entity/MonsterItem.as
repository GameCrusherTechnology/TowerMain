package model.entity
{
	import flash.utils.getDefinitionByName;
	
	import model.item.MonsterData;

	public class MonsterItem extends EntityItem
	{
		private var data:MonsterData;
		public function MonsterItem(_data:MonsterData)
		{
			data = _data;
			super({id:data.id});
		}
		
		public function get speed():int
		{
			return entitySpec.speed;
		}
		
		override public function get armClass():Class
		{
			return 	 getDefinitionByName("view.bullet."+entitySpec.armCls) as Class;
		}
	}
}