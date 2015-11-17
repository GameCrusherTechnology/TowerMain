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
		
		public var gameuid:String;
		public var coin:int;
		
		public var heroData:HeroData;
		
		
	}
}