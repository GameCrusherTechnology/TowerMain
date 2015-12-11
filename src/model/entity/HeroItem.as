package model.entity
{
	import controller.GameController;
	
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
			return 30 / (heroData.curAttackSpeed/100 );
		}
		
		override public function get totalLife():int
		{
			return heroData.curHealth;
		}
		
		override public function get hurtPoint():int
		{
			var basep:int =  heroData.curAttackPower;
			
			//暴击
			var sL:int = heroData.curCritRate;
			var bool:Boolean = (Math.random()*100)<= sL;
			if(bool){
				basep = basep*heroData.curCritHurt/100;
			}
			return basep;
		}
		
		
		private function get heroData():HeroData
		{
			return GameController.instance.localPlayer.heroData;
		}
		
	}
}