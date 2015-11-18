package model.entity
{
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
	}
}