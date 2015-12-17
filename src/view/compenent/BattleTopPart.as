package view.compenent
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.battle.BattleRule;
	import model.item.HeroData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.entity.HeroEntity;

	public class BattleTopPart extends Sprite
	{
		private var rule:BattleRule;
		private var pWidth:Number ;
		private var pHeight:Number ;
		public function BattleTopPart()
		{
			rule = GameController.instance.curBattleRule;
			pWidth = Configrations.ViewPortWidth;
			pHeight= Configrations.ViewPortHeight*0.1;
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.5;
			blackSkin.width = pWidth;
			blackSkin.height = pHeight;
			
			configHeroPart();
			configMonsterPart();
			var vsIcon:Image = new Image(Game.assets.getTexture("VSIcon"));
			vsIcon.height = pHeight*0.85;
			vsIcon.scaleX =vsIcon.scaleY;
			addChild(vsIcon);
			vsIcon.x = pWidth/2 - vsIcon.width/2;
			vsIcon.y = pHeight/2-vsIcon.height/2;
			
			addEventListener(Event.ENTER_FRAME,onFrame);
			touchable = false;
			
		}
		private function onFrame(e:Event):void
		{
			setBar();
			setTime();
		}
		private var heroHealthBar:GreenProgressBar;
		private function configHeroPart():void
		{
			heroHealthBar = new GreenProgressBar( pWidth*0.4 - pWidth*0.05 - pHeight*0.8,pHeight*0.4,1,0xCD8500,0xCD3700);
			addChild(heroHealthBar);
			
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			skin.width = skin.height = pHeight*0.8;
			addChild(skin);
			skin.y = pHeight/2 - skin.height/2;
			skin.x = pWidth*0.05;
			
			var icon:Image = new Image(Game.assets.getTexture("sheshouHeadIcon"));
			icon.width = icon.height = pHeight*0.68;
			addChild(icon);
			icon.x = skin.x + skin.width/2 - icon.width/2;
			icon.y = skin.y + skin.height/2 -icon.height/2;
			
			heroHealthBar.x = skin.x + skin.width - pWidth*0.01;
			heroHealthBar.y = skin.y + skin.height/2 - heroHealthBar.height/2;
			
			setBar();
		}
		
		private function setBar():void
		{
			var curLife:int = hero.heroItem.curLife;
			var tLife:int = hero.heroItem.totalLife;
			heroHealthBar.progress = curLife/tLife;
			heroHealthBar.comment = hero.heroItem.curLife +"/"+hero.heroItem.totalLife;
			
		}
		
		private var monsterPart:Sprite;
		private var waveText:TextField;
		private var waveTime:int;
		private var bar:GreenProgressBar;
		public function configMonsterPart():void
		{
			if(waveText){
				waveText.removeFromParent(true);
				waveText = null;
			}
			if(monsterPart){
				monsterPart.removeFromParent(true)
				monsterPart = null;
			}
			monsterPart = new Sprite;
			addChild(monsterPart);
			monsterPart.x = pWidth *0.6;
			
			if(!bar){
				bar = new GreenProgressBar(pWidth*0.35,pHeight*0.25,0,0xB8860B,0xEEDC82);
				bar.progress = 0;
				bar.x = 0;
				bar.y = pHeight *0.6 ;
			}
			monsterPart.addChild(bar );
			
			var rounds:Array = rule.roundEntities;
			var l:int = rule.totalRound;
			var curL:int = l - rounds.length;
			var le:Number;
			var mIcon:Image ;
			var posx:Number = bar.x;
			
			if(l==1){
				le = pWidth*0.35;
				bar.progress = 1;
				mIcon = new Image(Game.assets.getTexture("DemonIcon"));
				mIcon.height = pHeight*0.5;
				mIcon.scaleX = mIcon.scaleY;
				monsterPart.addChild(mIcon);
				mIcon.x = bar.x + bar.width - mIcon.width/2;
				mIcon.y = bar.y + bar.height - mIcon.height;
				
			}else{
				le = pWidth*0.35/(l-1);
				for (var i:int = 0;i<l;i++){
					mIcon = new Image(Game.assets.getTexture("DemonIcon"));
					mIcon.height = pHeight*0.5;
					mIcon.scaleX = mIcon.scaleY;
					monsterPart.addChild(mIcon);
					if(i > curL){
						mIcon.filter = Configrations.grayscaleFilter;
					}
					mIcon.x = posx - mIcon.width/2;
					mIcon.y = bar.y +bar.height - mIcon.height;
					
					posx += le;
				}
			}
			waveTime = Configrations.WAVE_LOAD_TIME;
			waveText = FieldController.createNoFontField(bar.width,pHeight*0.5,LanguageController.getInstance().getString("nextWave")+": "+int(waveTime/30)+"s",0xFF3030,0,true);
			monsterPart.addChild(waveText);
			
		}
		private function setTime():void
		{
			if(waveTime >0){
				waveTime --;
				if(waveText && waveText.parent){
					waveText.text = LanguageController.getInstance().getString("nextWave")+": "+int(waveTime/30)+"s";
				}else{
					waveText = FieldController.createNoFontField(pWidth*0.35,pHeight*0.5,LanguageController.getInstance().getString("nextWave")+": "+int(waveTime/30)+"s",0xffffff,0,true);
					monsterPart.addChild(waveText);
				
				}
			}else if(waveTime == 0){
				if(waveText){
					waveText.removeFromParent(true);
					waveText = null;
				}
				var rounds:Array = rule.roundEntities;
				var l:int = rule.totalRound;
				var curL:int = l - rounds.length;

				bar.progress = curL/(l-1);
				waveTime--;
			}
		}
		
		
		private function get heroData():HeroData
		{
			return GameController.instance.localPlayer.heroData;
		}
		
		private function get hero():HeroEntity
		{
			return rule.heroEntity;
		}
	}
}