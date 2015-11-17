package model.battle
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import controller.GameController;
	import controller.SpecController;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.HeroData;
	import model.item.MonsterData;
	import model.item.SkillData;
	import model.player.BossPlayer;
	import model.player.GamePlayer;
	import model.player.GameUser;
	import model.player.MonsterPlayer;
	
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	import view.compenent.BattleLoadingScreen;
	import view.screen.BattleScene;

	public class BattleRule
	{
		private var battleSpec:BattleItemSpec;
		private var curMode:String;
		private var curScene:BattleScene;
		public function BattleRule(battle:BattleItemSpec,mode:String)
		{
			battleSpec = battle;
			curMode = mode;
			curScene = new BattleScene(this);
			GameController.instance.showBattle(curScene);
			prepareBattle();
		}
		
		private var loadedTexturesAltas:Object;
		private function prepareBattle():void
		{
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = Game.assets;
			
			loadedTexturesAltas =getAllTextures();
			
			
			var dic:Dictionary = new Dictionary;
			var soldierArr:Array = loadedTexturesAltas['soldier'];
			var i:int;
			var s:*;
			for(i = 0;i<soldierArr.length;i++){
				dic[soldierArr[i]] = true;
			}
			soldierArr = [];
			for(s in dic){
				soldierArr.push(s);
			}
			
			var skillArr:Array = loadedTexturesAltas['skill'];
			dic = new Dictionary;
			for(i = 0;i<skillArr.length;i++){
				dic[skillArr[i]] = true;
			}
			skillArr = [];
			for(s in dic){
				skillArr.push(s);
			}
			
			
			var name:String;
			for each(name in soldierArr){
				assets.enqueue(
					appDir.resolvePath("textures/role/"+name)
				);
			}
			for each(name in skillArr){
				assets.enqueue(
					appDir.resolvePath("textures/skill/"+name)
				);
			}
			assets.loadQueue(curScene.onPrepared);
			
			
		}
		public function getAllTextures():Object
		{
			var soldierArr:Array = [];
			var skillArr:Array = [];
			var obj:Object;
			if(player.heroData){
				obj = getTextureFromPlayer(player.heroData);
				soldierArr = soldierArr.concat(obj['soldier']);
				skillArr = skillArr.concat(obj['skill']);
			}
			
			
			if(battleSpec){
				obj = getTextureFromBattle(battleSpec);
				soldierArr = soldierArr.concat(obj['soldier']);
				skillArr = skillArr.concat(obj['skill']);
			}
			
			
			for(var i:int=0,newSoldier:Array=[];i<soldierArr.length;i++){
				if(newSoldier.indexOf(soldierArr[i])==-1){
					newSoldier.push(soldierArr[i])  
				}
			}
			
			for(var j:int=0,newSkill:Array=[];j<skillArr.length;j++){
				if(newSkill.indexOf(skillArr[j])==-1){
					newSkill.push(skillArr[j])  
				}
			}
			
			
			return {"soldier":newSoldier,"skill":newSkill};
		}
		private function getTextureFromPlayer(data:HeroData):Object
		{
			var id:String;
			var soldierSpec:SoldierItemSpec;
			var soldierLevel:int;
			var textureArr:Array = [];
			var skillArr:Array = [];
			var soldierSkillArr:Array = [];
			var skillId:String;
			var skillSpec:SkillItemSpec;
			
//			textureArr.push(player.characterSpec.name);
			
//			for each(id in data.skillList){
//				skillSpec = SpecController.instance.getItemSpec(id) as SkillItemSpec;
//				if(skillSpec){
//					skillArr.push(skillSpec.name);
//					if(skillSpec.buffName){
//						skillArr.push(skillSpec.buffName);
//					}
//				}
//			
//			}
			return {"soldier":textureArr,"skill":skillArr};
		}
		
		private function getTextureFromBattle(battleStep:BattleItemSpec):Object
		{
			var soldierSpec:SoldierItemSpec;
			var soldierLevel:int;
			var textureArr:Array = [];
			var skillArr:Array = [];
			var soldierSkillArr:Array = [];
			var skillId:String;
			var skillSpec:SkillItemSpec;
			
			var rouds:Array = battleStep.monsterRounds;
			for each(var arr:Array in rouds){
				for each(var monsterData:MonsterData in arr){
					soldierSpec = monsterData.monsterSpec
					textureArr.push(soldierSpec.name);
					var skills:Array = soldierSpec.skills;
					for each(var data:SkillData in skills)
					{
						skillArr.push(data.skillItemSpec.name);
					}
				}
			}
			return {"soldier":textureArr,"skill":skillArr};
		}
		
		public function beginBattle():void
		{
		
		}
			
		
		public function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}