package view.entity
{
	import model.entity.HeroItem;

	public class HeroEntity extends GameEntity
	{
		public function HeroEntity(heroItem:HeroItem)
		{
			super(heroItem);
		}
		
		override protected function initFace():void
		{
			showState(GameEntity.ATTACK);
			showSound();
		}
		
	}
}