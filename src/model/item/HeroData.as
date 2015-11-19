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
		public var powerLevel:int = 0;
		public var agilityLevel:int = 0;
		public var wisdomLevel:int = 0;
		public var critLevel:int = 0;
		public var moneyLevel:int = 0;
		
	}
}