package model.item
{
	import gameconfig.Configrations;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class HeroData extends EventDispatcher
	{
		public static const HEROSKILLCHANGE:String = "hero_skill_change";
		
		public function HeroData(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in HeroData: HeroData["+str+"]="+data[str]);
				}
			}
		}
		
		public var id:String;
		public var name:String = "sheshou";
		
		private var exp:int;
		private var level:int;
		
		private var _skillPoints:int;
		public function get skillPoints():int
		{
			return _skillPoints;
		}
		public function set skillPoints(i:int):void
		{
			_skillPoints = i;
		}
		
			
		public function addExp(e:int):void
		{
			var oL:int = level;
			exp += e;
			level = Configrations.expToGrade(exp);
			if(level> oL){
				//upGrade
				skillPoints++;
			}
		}
		
		public function get skills():Array
		{
			return [];
		}
		
		//property
		public var healthLevel:int = 0;
		public var healthBase:int = 200;
		public var healthUp:int = 20;
		
		
		public var powerLevel:int = 0;
		public var powerBase:int = 40;
		public var powerUp:int = 2;
		
		public var agilityLevel:int = 0;
		public var agilityBase:int = 100;
		public var agilityUp:int = 5;
		public var rangeBase:int = 100;
		public var rangeUp:int = 10;
		
		public var wisdomLevel:int = 0;
		public var wisdomBase:int = 0;
		public var wisdomUp:int = 2;
		
		
		public var critLevel:int = 0;
		public var critBase:int = 15;
		public var critUp:int = 1;
		public var critHurtBase:int = 200;
		public var critHurtUp:int = 10;
		
		
		public var moneyLevel:int = 0;
		public var moneyBase:int = 100;
		public var moneyUp:int = 5;
		
		//skill
		private var skillItems:Array = [];
		public function set sitems(obj:Object):void
		{
			skillItems = [];
			for each(var ob:Object in obj){
				skillItems.push(new OwnedItem(ob["id"],ob["count"]));
			}
		}
		public function getSkillItem(id:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in skillItems){
				if(ownedItem.item_id == id){
					return ownedItem;
				}
			}
			return new OwnedItem(id,0);
		}
		public function addSkillItem(itemid:String,count:int):Boolean
		{
			var ownedItem :OwnedItem;
			for each(ownedItem in skillItems){
				if(ownedItem.item_id == itemid){
					ownedItem.count += count;
					return true;
				}
			}
			skillItems.push(new OwnedItem(itemid,count));
			dispatchEvent(new Event(HEROSKILLCHANGE));
			return false;
		}
		
		
	}
}