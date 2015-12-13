package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.item.HeroData;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.compenent.GreenProgressBar;
	
	public class HeroInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var oldCoin:int;
		private var oldData:HeroData;
		private var coinText:TextField;
		
		private var coinBut:Button;
		public function HeroInfoPanel()
		{
			oldCoin = player.coin;
			oldData = player.heroData;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
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
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.8;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = backSkin.width;
			titleSkin.height = panelheight*0.08;
			titleSkin.x =backSkin.x;
			titleSkin.y = backSkin.y;
			
			var titleText:TextField = FieldController.createNoFontField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("hero"),0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			configContainer();
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = titleSkin.x;
			backBut.y = titleSkin.y;
			backBut.addEventListener(Event.TRIGGERED,onTriggerOut);
			
		}
		private function configContainer():void
		{
			var headIcon:Image = new Image(Game.assets.getTexture("sheshouHeadIcon"));
			addChild(headIcon);
			headIcon.height = panelheight*0.15;
			headIcon.scaleX = headIcon.scaleY;
			
			headIcon.x = panelwidth *0.2;
			headIcon.y = panelheight*0.18;
			
			var expBar:GreenProgressBar  = new GreenProgressBar(panelwidth*0.3,panelheight*0.05,2);
			addChild(expBar);
			var nextExp:int = Configrations.gradeToExp(player.heroData.level+1);
			expBar.x = panelwidth *0.45;
			expBar.y = panelheight*0.23;
			expBar.comment = player.heroData.exp +"/" + nextExp;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = panelheight *0.08;
			addChild(expIcon);
			expIcon.x = panelwidth *0.45 - expIcon.width/2;
			expIcon.y = panelheight*0.21;
			
			var expLevel:TextField = FieldController.createNoFontField(panelwidth,expIcon.height,""+player.heroData.level,0x000000,0,true);
			expLevel.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(expLevel);
			expLevel.x = expIcon.x + expIcon.width/2 - expLevel.width/2;
			expLevel.y = expIcon.y;
			
			configPropertyPart();
			
			
		}
		
		private function configPropertyPart():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth * 0.25;
			container.y = panelheight*0.35;
			
			var b:Number = 0;
			
			var healPart:Sprite = creatPropertyP("healthIcon","health","" + player.heroData.curHealth);
			container.addChild(healPart);
			
			var attackPart:Sprite = creatPropertyP("powerIcon","power","" + player.heroData.curAttackPower);
			container.addChild(attackPart);
			attackPart.x = panelwidth * 0.3;
			
			var attackSpeedPart:Sprite = creatPropertyP("agilityIcon","agility","" + player.heroData.curAttackSpeed+"%");
			container.addChild(attackSpeedPart);
			attackSpeedPart.y = panelheight *0.06;
			
			
			var critPart:Sprite = creatPropertyP("critIcon","crit","" + player.heroData.curCritRate+"%");
			container.addChild(critPart);
			critPart.y = panelheight *0.12;
			
			var critHurtPart:Sprite = creatPropertyP("critIcon","crit","" + player.heroData.curCritHurt+"%");
			container.addChild(critHurtPart);
			critHurtPart.x = panelwidth * 0.3;
			critHurtPart.y = panelheight *0.12;
			
			var defencePart:Sprite = creatPropertyP("defenseIcon","defense","" + player.heroData.curDefense*100 +"%");
			container.addChild(defencePart);
			defencePart.y = panelheight *0.18;
			
			var wisdomPart:Sprite = creatPropertyP("wisdomIcon","wisdom","" + player.heroData.curWisdomCD +"%");
			container.addChild(wisdomPart);
			wisdomPart.x = panelwidth * 0.3;
			wisdomPart.y = panelheight *0.18;
			
			
			
		}
		
		private function creatPropertyP(iconcls:String,nameStr:String,proper:String):Sprite
		{
			var container:Sprite = new Sprite;
			
			var icon:Image = new Image(Game.assets.getTexture(iconcls));
			icon.width = icon.height = panelheight*0.05;
			container.addChild(icon);
			
			var nameText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString(nameStr)+":",0x000000);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = icon.width;
			
			var properText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05," "+proper,0xBCEE68,panelheight*0.04,true);
			properText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(properText);
			properText.x = icon.width + nameText.width;
			
			return container;	
		}
		
		
		private function onTriggerOut(e:Event):void
		{
			dispose();
		}
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
		
	}
}
