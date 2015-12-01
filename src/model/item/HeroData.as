package model.item
{
	import gameconfig.Configrations;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;

	public class HeroData extends EventDispatcher
	{
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
		
		public var exp:int;
		public var level:int;
		
		private var _skillPoints:int = 100;
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
			return ["30001","30021","30011","30016","30020","30003"];
		}
		
		//property
		public var healthLevel:int = 0;
		public var healthBase:int = 200;
		public var healthUp:int = 20;
		public function get curHealth():int
		{
			return healthBase + healthUp*healthLevel;
		}
		
		
		public var powerLevel:int = 0;
		public var powerBase:int = 40;
		public var powerUp:int = 2;
		public function get curAttackPower():int
		{
			return powerBase + powerUp*powerLevel;
		}
		
		
		public var agilityLevel:int = 0;
		public var agilityBase:int = 100;
		public var agilityUp:int = 5;
		public function get curAttackSpeed():int
		{
			return agilityBase + agilityUp*agilityLevel;
		}
		
		public var rangeBase:int = 100;
		public var rangeUp:int = 10;
		public function get curRange():int
		{
			return rangeBase + rangeUp*agilityLevel;
		}
		
		public var wisdomLevel:int = 0;
		public var wisdomBase:int = 0;
		public var wisdomUp:int = 2;
		public function get curWisdomCD():int
		{
			return wisdomBase + wisdomUp*wisdomLevel;
		}
		
		
		public var critLevel:int = 0;
		public var critBase:int = 15;
		public var critUp:int = 1;
		public function get curCritRate():int
		{
			return critBase + critUp*critLevel;
		}
		public var critHurtBase:int = 200;
		public var critHurtUp:int = 10;
		public function get curCritHurt():int
		{
			return critHurtBase + critHurtUp*critLevel;
		}
		
		
		public var moneyLevel:int = 0;
		public var moneyBase:int = 100;
		public var moneyUp:int = 5;
		
		
		public function get curAttackPoint():int
		{
			var rate:Number = Math.random()*100;
			if(rate < curCritRate){
				return Math.floor(curAttackPower*curCritHurt/100);
			}else{
				return curAttackPower;
			}
		}
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
					userSkill();
					return true;
				}
			}
			skillItems.push(new OwnedItem(itemid,count));
			userSkill();
			return false;
		}
		private function userSkill():void
		{
			skillPoints --;
			dispatchEvent(new HeroChangeEvent(HeroChangeEvent.HEROSKILLCHANGE));
		}
		public function getSkillTypePoint(typr:String):int
		{
			var p:int;
			var ownedItem :OwnedItem;
			for each(ownedItem in skillItems){
				if(ownedItem.itemSpec&&  ownedItem.itemSpec.type == typr){
					 p += ownedItem.count;
				}
			}
			return p;
		}
		
		//被动技能
		
			
		
	}
}