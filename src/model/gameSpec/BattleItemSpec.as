package model.gameSpec
{
	import model.item.MonsterData;

	public class BattleItemSpec extends ItemSpec
	{
		public function BattleItemSpec(data:Object)
		{
			super(data);
		}
		public var rewardCoin:int;		
		public var rewardExp:int;	
		public var baseMonster:String;
		public function get monsterRounds():Array
		{
			var rounds:Array = [];
			var arr1:Array = baseMonster.split(";");
			for (var i:int = 0;i<arr1.length;i++){
				rounds.push(creatMonsters(arr1[i]));
			}
			return rounds;
		}
		private function creatMonsters(str:String):Array
		{
			var arr:Array = str.split("|");
			var monsters:Array = [] ;
			for (var i:int = 0;i<arr.length;i++){
				monsters.push(creatMonster(arr[i]));
			}
			return monsters;
		}
		private function creatMonster(str:String):MonsterData
		{
			var monsterData:MonsterData;
			var arr:Array = str.split(":");
			monsterData = new MonsterData(arr[0],arr[1],arr[2],arr[3]);
			return monsterData;
		}
	}
}