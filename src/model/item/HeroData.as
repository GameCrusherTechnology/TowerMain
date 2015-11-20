package model.item
{
	public class HeroData extends Object
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
	}
}