package model.battle
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import controller.GameController;
	import controller.SpecController;
	
	import model.entity.EntityItem;
	import model.entity.HeroItem;
	import model.entity.MonsterItem;
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.HeroData;
	import model.item.MonsterData;
	import model.item.SkillData;
	import model.player.GameUser;
	
	import starling.utils.AssetManager;
	
	import view.bullet.ArmObject;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;
	import view.screen.BattleScene;

	public class BattleRule
	{
		private var battleSpec:BattleItemSpec;
		private var curMode:String;
		private var curScene:BattleScene;
		public var cScale:Number;
		public function BattleRule(battle:BattleItemSpec,mode:String)
		{
			battleSpec = battle;
			curMode = mode;
			monsterVec = new Vector.<MonsterEntity>;
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
			
			textureArr.push(data.name);
			
			for each(id in data.skills){
				skillSpec = SpecController.instance.getItemSpec(id) as SkillItemSpec;
				if(skillSpec){
					skillArr.push(skillSpec.name);
					if(skillSpec.buffName){
						skillArr.push(skillSpec.buffName);
					}
				}
			
			}
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
			heroEntity = new HeroEntity(new HeroItem(player.heroData));
			curScene.addEntity(heroEntity,0.5,true);
			roundEntities = battleSpec.monsterRounds;
		}
		
		
		public function validate():void
		{
			heroEntity.validate();
			var entity:MonsterEntity;
			for each(entity in monsterVec){
				entity.validate();
			}
			valiEntity();
		}
		
		private var roundEntities:Array = [] ;
		private var curRound:Array = [];
		
		private var entityCD:int = 20;
		private var roundCD:int = 50;
		private function valiEntity():void
		{
			if(curRound.length >0){
				if(entityCD > 0){
					entityCD --;
				}else{
					var mdata:MonsterData = curRound.shift();
					creatMonster(mdata);
					entityCD = 20;
				}
			}else if(roundEntities.length>0){
				if(roundCD > 0){
					roundCD --;
				}else{
					curRound = roundEntities.shift();
					roundCD = 50;
				}
			}else{
			//win	
			}
		}
		
		private function creatMonster(data:MonsterData):void
		{
			var entity:MonsterEntity = new MonsterEntity(new MonsterItem(data));
			curScene.addEntity(entity,data.pos);
			monsterVec.push(entity);
		}
		
		public var heroEntity:HeroEntity;
		public var monsterVec:Vector.<MonsterEntity>;
		
		//arm
		private var armsArr:Array = [];
		public function initArms():void
		{
			clearArms();
		}
		
		public function addArm(arm:ArmObject):void
		{
			curScene.addArm(arm);
			armsArr.push(arm);
		}
		public function removeArm(arm:ArmObject):void
		{
			if(armsArr.indexOf(arm) >= 0){
				armsArr.splice(armsArr.indexOf(arm),1);
			}
			arm.removeFromParent(true);
		}
		
		private function clearArms():void
		{
			var arm:ArmObject;
			for each(arm in armsArr){
				arm.removeFromParent(true);
			}
			armsArr = [];
		}
		
		public function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}