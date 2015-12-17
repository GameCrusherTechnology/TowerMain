package model.item
{
	import gameconfig.Configrations;
	
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
		
		public var name:String = "sheshou";
		
		public var curmap:int = 5;
		
		public var exp:int;
		
		public var level:int;
		
		public var curWeapon:String ;
		public var curDefence:String ;
		
		private var _skillPoints:int ;
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
				skillPoints += (level-oL) ;
			}
		}
		
		public function get skills():Array
		{
			return ["30001","30004","30007","31001","31004","31007"];
		}
		
		//property
		public var healthLevel:int = 0;
		public var healthBase:int = 200;
		public var healthUp:int = 20;
		public function get curHealth():int
		{
			
			var h:int =  healthBase + healthUp*healthLevel;
			
			if(curDefence == "80005"){
				h += 100;
			}
			
			return h;
		}
		
		
		public var powerLevel:int = 0;
		public var powerBase:int = 40;
		public var powerUp:int = 2;
		public function get curAttackPower():int
		{
			var p:int =  powerBase + powerUp*powerLevel;
			if(curWeapon == "80000"){
				p += 5;
			}else if(curWeapon == "80003"){
				p += 20;
			}
			return p;
		}
		
		
		public var agilityLevel:int = 0;
		public var agilityBase:int = 100;
		public var agilityUp:int = 10;
		public function get curAttackSpeed():int
		{
			var a:int =  agilityBase + agilityUp*agilityLevel;
			if(curWeapon == "80000"){
				a += 10;
			}else if(curWeapon == "80003"){
				a += 50;
			}
			return a;
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
			var c:int =  critBase + critUp*critLevel;
			if(curWeapon == "80001"){
				c += 5;
			}else if(curWeapon == "80003"){
				c += 10;
			}
			return c;
		}
		
		public var critHurtLevel:int = 0;
		public var critHurtBase:int = 200;
		public var critHurtUp:int = 10;
		public function get curCritHurt():int
		{
			var c:int =  critHurtBase + critHurtUp*critHurtLevel;
			if(curWeapon == "80001"){
				c += 50;
			}
			return c;
		}
		
		
		
		public function get curAttackPoint():int
		{
			var rate:Number = Math.random()*100;
			if(rate < curCritRate){
				return Math.floor(curAttackPower*curCritHurt/100);
			}else{
				return curAttackPower;
			}
		}
		
		//map
		private var passedMaps:Array = [];
		public function set maps(obj:Object):void
		{
			passedMaps = [];
			for each(var ob:Object in obj){
				passedMaps.push(new OwnedItem(ob["item_id"],ob["count"]));
			}
		}
		public function getMap(id:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in passedMaps){
				if(ownedItem.item_id == id){
					return ownedItem;
				}
			}
			return new OwnedItem(id,0);
		}
		public function addMap(itemid:String,count:int):Boolean
		{
			var ownedItem :OwnedItem;
			for each(ownedItem in passedMaps){
				if(ownedItem.item_id == itemid){
					ownedItem.count += count;
					return true;
				}
			}
			passedMaps.push(new OwnedItem(itemid,count));
			return false;
		}
		
		public function getThreeMaps(index:int):int{
			var arr:Array = [];
			var ownedItem :OwnedItem;
			for each(ownedItem in passedMaps){
				if(ownedItem.count >= 3 &&  int((int(ownedItem.item_id) - 20000)/100) == (index+1)){
					arr.push(ownedItem);
				}
			}
			return arr.length;
		}
		
		//items
		public var owneditems:Array = [];
		public function set items(obj:Object):void
		{
			owneditems = [];
			for each(var ob:Object in obj){
				owneditems.push(new OwnedItem(ob["item_id"],ob["count"]));
			}
		}
		public function getItem(id:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in owneditems){
				if(ownedItem.item_id == id){
					return ownedItem;
				}
			}
			return new OwnedItem(id,0);
		}
		public function addItem(itemid:String,count:int):Boolean
		{
			var ownedItem :OwnedItem;
			for each(ownedItem in owneditems){
				if(ownedItem.item_id == itemid){
					ownedItem.count += count;
					return true;
				}
			}
			owneditems.push(new OwnedItem(itemid,count));
			return false;
		}
		
		
		//skill
		public function resetSkill():void
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in skillItems){
				skillPoints += ownedItem.count;
			}
			skillItems = [];
		}
		private var skillItems:Array = [];
		public function set sitems(obj:Object):void
		{
			skillItems = [];
			for each(var ob:Object in obj){
				skillItems.push(new OwnedItem(ob["item_id"],ob["count"]));
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
		
		public function get curDefense():int
		{
			var dL:int = getSkillItem("30002").count;
			var rate:Number =  Configrations.skill30002Point[dL];
			if(curDefence == "80004"){
				rate += 0.3;
			}else if(curDefence == "80005"){
				rate += 0.1;
			}
			return int(rate*100);
		}
		
		public function getSaveData():Object
		{
			return {
				curmap:curmap,
				exp:exp,
				level:level,
				curWeapon:curWeapon,
				curDefence:curDefence,
				skillPoints:skillPoints,
				
				//property
				healthLevel:healthLevel,
				powerLevel:powerLevel,
				agilityLevel:agilityLevel,
				wisdomLevel:wisdomLevel,
				critLevel:critLevel,
				critHurtLevel:critHurtLevel,
				
				maps:passedMaps,
				items:owneditems,
				sitems:skillItems
			};
		}
	}
}