package model.player
{
	import model.item.HeroData;
	
	import starling.events.EventDispatcher;

	
	public class GameUser extends EventDispatcher
	{
		public function GameUser(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in GamePlayer: GamePlayer["+str+"]="+data[str]);
				}
			}
		}
		
		public var uid:String;
		public var coin:int;
		public function addCoin(c:int):void
		{
			coin+= c;
			dispatchEvent(new PlayerEvent(PlayerEvent.CoinChange));
		}
			
		public var gem:int;
		public function addGem(g:int):void
		{
			gem += g;
			dispatchEvent(new PlayerEvent(PlayerEvent.GemChange));
		}
		
		public var heroData:HeroData;
		private function set localHero(obj:Object):void
		{
			heroData = new HeroData(obj);
		}
		
		public function getSaveData():Object
		{
			return {
				uid:uid,
				coin:coin,
				gem:gem,
				localHero:heroData.getSaveData()
			};
		}
		
	}
}