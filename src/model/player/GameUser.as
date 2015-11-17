package model.player
{
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
		public function refresh(data:Object):void
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
		public var gem:int;
		public var login:String;
		public var extra:int;
		
		
		public function changeGem(changeNum:int):void
		{
			gem += changeNum;
		}
		public function changeCoin(changeNum:int):void
		{
			coin += changeNum;
		}
	}
}