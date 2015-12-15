package model.battle
{
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.entity.HeroItem;
	import model.entity.MonsterItem;
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.HeroData;
	import model.item.MonsterData;
	import model.player.GameUser;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.utils.AssetManager;
	
	import view.bullet.ArmObject;
	import view.compenent.HeroSkillButton;
	import view.compenent.HurtTip;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;
	import view.panel.BattleResultPanel;
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
			monsterVec = [];
			armsArr = [];
		}
		
		private var loadedTexturesAltas:Object;
		public function prepareBattle():void
		{
			curScene = GameController.instance.curBattleScene;
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
			
			
			var name:String;
			for each(name in soldierArr){
				if(!assets.getTextureAtlas(name)){
					assets.enqueue(
						appDir.resolvePath("textures/role/"+name)
					);
				}
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
			return {"soldier":[data.name]};
		}
		
		private function getTextureFromBattle(battleStep:BattleItemSpec):Object
		{
			var soldierSpec:SoldierItemSpec;
			var textureArr:Array = [];
			
			var rouds:Array = battleStep.monsterRounds;
			for each(var arr:Array in rouds){
				for each(var monsterData:MonsterData in arr){
					soldierSpec = monsterData.monsterSpec
					textureArr.push(soldierSpec.name);
				}
			}
			return {"soldier":textureArr};
		}
		public function beginBattle():void
		{
			heroEntity = new HeroEntity(new HeroItem(player.heroData));
			curScene.addEntity(heroEntity,0.5,true);
			roundEntities = battleSpec.monsterRounds;
			totalRound = roundEntities.length;
		}
		
		private var beStopped:Boolean;
		public function validate():void
		{
			if(!beStopped){
				heroEntity.validate();
				valiEntity();
				
				var armObject:ArmObject;
				for each(armObject in armsArr)
				{
					armObject.refresh();
				}
			}
		}
		
		public var totalRound:int;
		public var roundEntities:Array = [] ;
		private var curRound:Array = [];
		
		private var entityCD:int = 50;
		private var roundCD:int = Configrations.WAVE_LOAD_TIME;
		private function valiEntity():void
		{
			var entity:MonsterEntity;
			for each(entity in monsterVec){
				entity.validate();
			}
			
			if(curRound.length >0){
				if(entityCD > 0){
					entityCD --;
				}else{
					var mdata:MonsterData = curRound.shift();
					creatMonster(mdata);
					entityCD = 50;
				}
			}else if(roundEntities.length>0){
				if(roundCD > 0){
					roundCD --;
				}else{
					curRound = roundEntities.shift();
					roundCD = Configrations.WAVE_LOAD_TIME;
					passRound();
				}
			}else{
			//	no more
				if(monsterVec.length <=0){
					//win
					winGame();
				}
			}
		}
		
		private function winGame():void
		{
			beStopped = true;
			DialogController.instance.showPanel(new BattleResultPanel(battleSpec,curMode,true));
		}
		
		public function loseGame():void
		{
			beStopped = true;
			DialogController.instance.showPanel(new BattleResultPanel(battleSpec,curMode,false));
		}
		public function revive():void
		{
			beStopped = false;
			heroEntity.revive();
		}
		private function passRound():void
		{
			curScene.battleTop.configMonsterPart();
		}
		private function creatMonster(data:MonsterData):void
		{
			var entity:MonsterEntity = new MonsterEntity(new MonsterItem(data));
			curScene.addEntity(entity,data.pos);
			monsterVec.push(entity);
		}
		public function removeMonster(entity:MonsterEntity):void
		{
			removeEntityFromList(entity);
			
			entity.filter = Configrations.grayscaleFilter;
			var t:Tween = new Tween(entity,1);
			t.fadeTo(0.2);
			t.onComplete = function():void{
				Starling.juggler.remove(t);
				curScene.removeEntity(entity);
			};
			Starling.juggler.add(t);
			
		}
		
		public function removeEntityFromList(entity:MonsterEntity):void
		{
			if(monsterVec.indexOf(entity) > -1 ){
				monsterVec.splice(monsterVec.indexOf(entity),1);
			}
		}
		
		
		public var heroEntity:HeroEntity;
		public var monsterVec:Array=[];
		
		//arm
//		public var skillItemSpec:SkillItemSpec; 
		public var curSkillBut:HeroSkillButton;
		
		public function useSkill(touchPoint:Point):void
		{
			if(curSkillBut){
				curSkillBut.userSkill(touchPoint);
				curSkillBut = null;
			}
		}
		
		private var armsArr:Array=[];
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
			arm.removeFromParent();
			arm = null;
		}
		
		private function clearArms():void
		{
			var arm:ArmObject;
			for each(arm in armsArr){
				arm.removeFromParent(true);
			}
			armsArr = [];
		}
		
		public function showHurtBar(bar:HurtTip):void
		{
			curScene.addHurtBar(bar);
		}
		
		
		public function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}