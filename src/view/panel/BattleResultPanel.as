package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.VoiceController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	
	import model.gameSpec.BattleItemSpec;
	import model.item.OwnedItem;
	import model.player.GameUser;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.compenent.GreenProgressBar;
	import view.compenent.ThreeStarBar;
	
	public class BattleResultPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var battleSpec:BattleItemSpec;
		private var battleMode:String;
		private var isWin:Boolean;
		public function BattleResultPanel(_spec:BattleItemSpec,_mode:String,_isWin:Boolean)
		{
			battleMode = _mode;
			battleSpec = _spec;
			isWin = _isWin;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			if(isWin){
				VoiceController.instance.playSound(VoiceController.LEVELUP);
			}else{
				VoiceController.instance.playSound(VoiceController.LOSE);
			}
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.2;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.7;
			backSkin.height = panelheight*0.7;
			backSkin.x = panelwidth*0.15;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = backSkin.width;
			titleSkin.height = panelheight*0.08;
			titleSkin.x =backSkin.x;
			titleSkin.y = panelheight*0.1;
			
			var str:String ;
			if(!isWin){
				str = LanguageController.getInstance().getString("defeat");
			}else{
				str = LanguageController.getInstance().getString("victory");
			}
			var titleText:TextField = FieldController.createNoFontField(panelwidth,titleSkin.height,str,0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  panelheight*0.1;
			
			var stars :int;
			if(battleMode == Configrations.Battle_Easy){
				stars = 1;
			}else if(battleMode == Configrations.Battle_Normal){
				stars = 2;
			}else{
				stars = 3;
			}
			
			var item:OwnedItem = player.heroData.getMap(battleSpec.item_id);
			if(item.count< stars){
				player.heroData.addMap(battleSpec.item_id,stars-item.count);
			}
			
			var bar:ThreeStarBar = new ThreeStarBar(stars,panelheight*0.18);
			addChild(bar);
			bar.x = panelwidth/2 - bar.width/2;
			bar.y = panelheight*0.2;
			
			if(isWin){
				configRewardContainer();
			}else{
				configDefeatContainer();
			}
			
			
		}
		private var addExp:int;
		private var addCoin:int;
		private function configRewardContainer():void
		{
			
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth*0.2;
			container.y = panelheight*0.3;
			
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			skin.width = skin.height = panelheight*0.25;
			container.addChild(skin);
			skin.x = panelwidth*0.02;
			skin.y = panelheight*0.02;
			
			var icon:Image = new Image(Game.assets.getTexture("sheshouHeadIcon"));
			icon.width = icon.height = panelheight*0.21;
			container.addChild(icon);
			icon.x = skin.x + panelheight*0.02;
			icon.y = skin.y + panelheight*0.02;
			
			addExp = 100;
			var nextExp:int = Configrations.gradeToExp(player.heroData.level+1);
			
			var expBar:GreenProgressBar  = new GreenProgressBar(panelwidth*0.3,panelheight*0.05,2);
			container.addChild(expBar);
			expBar.x =  panelheight*0.3;
			expBar.y = panelheight*0.1;
			expBar.comment = player.heroData.exp +"/" + nextExp;
			expBar.progress = player.heroData.exp/ nextExp;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = panelheight *0.08;
			container.addChild(expIcon);
			expIcon.x = expBar.x - expIcon.width/2;
			expIcon.y = expBar.y  - expIcon.height + expBar.height;
			
			var expLevel:TextField = FieldController.createNoFontField(panelwidth,expIcon.height,""+player.heroData.level,0x000000,0,true);
			expLevel.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(expLevel);
			expLevel.x = expIcon.x + expIcon.width/2 - expLevel.width/2;
			expLevel.y = expIcon.y;
			
			var addExpText:TextField = FieldController.createNoFontField(expBar.width,panelheight*0.05,"+ "+addExp,0xFFCC00,0,true);
			addExpText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(addExpText);
			addExpText.x = expBar.x + expBar.width + panelwidth *0.02;
			addExpText.y = expBar.y ;
			
			
			addCoin = 100;
			var nextCoin:int = (int(player.coin /10000)+1)*10000;
			var coinBar:GreenProgressBar  = new GreenProgressBar(panelwidth*0.3,panelheight*0.05,2);
			container.addChild(coinBar);
			coinBar.x = panelheight*0.3;
			coinBar.y = panelheight*0.2;
			coinBar.comment = player.coin +"";
			coinBar.progress = player.coin / nextCoin;
			
			var coinIcon:Image = new Image(Game.assets.getTexture("CoinIcon"));
			coinIcon.width = coinIcon.height = panelheight *0.08;
			container.addChild(coinIcon);
			coinIcon.x = coinBar.x - coinIcon.width/2;
			coinIcon.y = coinBar.y  - coinIcon.height + coinBar.height;
			
			
			var addCoinText:TextField = FieldController.createNoFontField(coinBar.width,panelheight*0.05,"+ "+addCoin,0xFFCC00,0,true);
			addCoinText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(addCoinText);
			addCoinText.x = coinBar.x + coinBar.width + panelwidth *0.02;;
			addCoinText.y = coinBar.y ;
			
			var tween:Tween = new Tween(container,100);
			tween.onUpdate = function():void{
				if(addExp > 0 ){
					addExp --;
					
					player.heroData.addExp(1);
					var nextExp:int = Configrations.gradeToExp(player.heroData.level+1);
					expBar.comment = player.heroData.exp +"/" + nextExp;
					expBar.progress = player.heroData.exp/ nextExp;
					
					expLevel.text = ""+player.heroData.level;
				}
				if(addCoin > 0){
					addCoin -- ;
					player.coin ++;
					coinBar.comment = player.coin +"";
					coinBar.progress = player.coin / nextCoin;
				}
				
				if(addExp <=0 && addCoin<=0){
					Starling.juggler.remove(tween);
				}
				
			}
			Starling.juggler.add(tween);
			
			var confirmBut:Button = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			container.addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			confirmBut.x = panelwidth*0.3 - confirmBut.width/2;
			confirmBut.y = panelheight*0.35;
			
		}
		
		private function configDefeatContainer():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth*0.2;
			container.y = panelheight*0.3;
			
			var cback:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60)));
			cback.alpha = 0.5;
			container.addChild(cback);
			cback.width =  panelwidth*0.6;
			cback.height =  panelheight*0.3;
			
			var spSkin:Image = new Image(Game.assets.getTexture("TitleTextSkin"));
			container.addChild(spSkin);
			var nameText:TextField = FieldController.createNoFontField(panelwidth*0.6,panelheight*0.07,LanguageController.getInstance().getString("improveself"),0xffffff);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x =  panelwidth*0.3 - nameText.width/2;
			
			spSkin.width = nameText.width + panelwidth*0.06;
			spSkin.height = panelheight*0.07;
			spSkin.x =  panelwidth*0.3 - spSkin.width/2;
			
			var skin1:Image =  new Image(Game.assets.getTexture("BPanelSkin"));
			skin1.width =  panelwidth*0.25;
			skin1.height = panelheight*0.2;
			container.addChild(skin1);
			skin1.x = panelwidth*0.02;
			skin1.y = panelheight*0.08;
			
			var text1:TextField = FieldController.createNoFontField(panelwidth*0.25,panelheight*0.15,LanguageController.getInstance().getString("Propertyinfo"),0x000000,panelheight*0.04);
			container.addChild(text1);
			text1.x = skin1.x;
			text1.y = skin1.y;
			
			var checkVipBut:Button = new Button();
			checkVipBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			checkVipBut.label = LanguageController.getInstance().getString("check");
			checkVipBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.03, 0x000000);
			checkVipBut.paddingLeft = checkVipBut.paddingRight = 10*panelScale;
			checkVipBut.height = panelheight*0.05;
			container.addChild(checkVipBut);
			checkVipBut.validate();
			checkVipBut.x = skin1.x + skin1.width/2 - checkVipBut.width/2;
			checkVipBut.y = panelheight*0.22;
			
			var propertyBut:Button = new Button();
			var skin1Mode:Image =  new Image(Game.assets.getTexture("BPanelSkin"));
			skin1Mode.width =  panelwidth*0.25;
			skin1Mode.height = panelheight*0.2;
			skin1Mode.alpha = 0;
			propertyBut.defaultSkin = skin1Mode;
			container.addChild(propertyBut);
			propertyBut.addEventListener(Event.TRIGGERED,onTriggerCheck);
			propertyBut.x = skin1.x ;
			propertyBut.y = skin1.y;
			
			
			var skin2:Image =  new Image(Game.assets.getTexture("BPanelSkin"));
			skin2.width =  panelwidth*0.25;
			skin2.height = panelheight*0.2;
			container.addChild(skin2);
			skin2.x = panelwidth*0.33;
			skin2.y = panelheight*0.08;
			
			
			var text2:TextField = FieldController.createNoFontField(panelwidth*0.25,panelheight*0.15,LanguageController.getInstance().getString("Weaponinfo"),0x000000,panelheight*0.04);
			container.addChild(text2);
			text2.x = skin2.x;
			text2.y = skin2.y;
			
			var updateBut:Button = new Button();
			updateBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			updateBut.label = LanguageController.getInstance().getString("buy");
			updateBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.03, 0x000000);
			updateBut.paddingLeft = updateBut.paddingRight = 10*panelScale;
			updateBut.height = panelheight*0.05;
			container.addChild(updateBut);
			updateBut.validate();
			updateBut.x = skin2.x + skin2.width/2 - updateBut.width/2;
			updateBut.y = panelheight*0.22;
			
			var weaponBut:Button = new Button();
			var skin2Mode:Image =  new Image(Game.assets.getTexture("BPanelSkin"));
			skin2Mode.width =  panelwidth*0.25;
			skin2Mode.height = panelheight*0.2;
			skin2Mode.alpha = 0;
			weaponBut.defaultSkin = skin2Mode;
			container.addChild(weaponBut);
			weaponBut.addEventListener(Event.TRIGGERED,onTriggerUpdate);
			weaponBut.x = skin2.x ;
			weaponBut.y = skin2.y;
			
			var gemBut:Button = new Button();
			gemBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
			gemBut.label = "×"+Configrations.resaveCost;
			var iconM:Image = new Image(Game.assets.getTexture("GemIcon"));
			iconM.width = iconM.height = panelheight*0.05;
			gemBut.defaultIcon = iconM;
			gemBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.05, 0x000000);
			gemBut.paddingLeft =gemBut.paddingRight =  20*panelScale;
			gemBut.paddingTop =gemBut.paddingBottom =  5*panelScale;
			container.addChild(gemBut);
			gemBut.validate();
			gemBut.addEventListener(Event.TRIGGERED,onTriggedResave);
			gemBut.x = panelwidth*0.3 - gemBut.width/2;
			gemBut.y = panelheight*0.35;
			
			var reviveText:TextField = FieldController.createNoFontField(panelwidth,gemBut.height,LanguageController.getInstance().getString("revive")+": ",0x000000,0,true);
			reviveText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(reviveText);
			reviveText.x = gemBut.x - reviveText.width;
			reviveText.y = gemBut.y;
			
			var confirmBut:Button = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("back");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.05, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.paddingTop =	confirmBut.paddingBottom =  5*panelScale;
			container.addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerOut);
			confirmBut.x = gemBut.x + gemBut.width + panelwidth*0.05;
			confirmBut.y = gemBut.y;
		}
		
		private function onTriggedResave(e:Event):void
		{
			if(player.gem >= Configrations.resaveCost){
				player.addGem(-Configrations.resaveCost);
				GameController.instance.curBattleRule.revive();
				dispose();
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningGemTip")));
			}
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			if(addCoin>0){
				player.coin += addCoin;
			}
			if(addExp > 0){
				player.heroData.addExp(addExp);
			}
			
			LocalData.instance.savePlayer();
			outToWorld();
		}
		private function onTriggerOut(e:Event):void
		{
			outToWorld();
		}
		private function onTriggerCheck(e:Event):void
		{
			DialogController.instance.showPanel(new HeroPropertyPanel());
			outToWorld();
		}
		private function onTriggerUpdate(e:Event):void
		{
			DialogController.instance.showPanel(new TreasurePanel());
			outToWorld();
		}
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		private function outToWorld():void
		{
			GameController.instance.showWorldScene();
			dispose();
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
		
	}
}

