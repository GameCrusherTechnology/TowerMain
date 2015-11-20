package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.item.HeroData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.compenent.TenStarBar;
	
	public class PropertyRender extends DefaultListItemRenderer
	{
		private var renderscale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		
		public function PropertyRender()
		{
			super();
			renderscale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var itemList:List;
		
		private var properName:String;
		
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			properName = String(value);
			if(properName ){
				if(container){
					container.removeFromParent(true);
				}
				configLayout();
			}
		}
		
		
		
		private function configLayout():void
		{
			container = new Sprite;
			addChild(container);
			
			var currentLevel:int = heroData[properName+"Level"];
			
			
			var nameText:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.2,LanguageController.getInstance().getString(properName),0x000000,0,true);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = renderwidth *0.1;
			
			var levelL:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.2," (" +currentLevel,0x00C5CD,0,true);
			levelL.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(levelL);
			levelL.x = nameText.x + nameText.width ;
			
			var levelT:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.2,"/10)",0x000000,0,true);
			levelT.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(levelT);
			levelT.x = levelL.x + levelL.width;
			
			var starBar:TenStarBar = new TenStarBar(currentLevel,Math.min(renderHeight*1.5,renderwidth*0.9));
			container.addChild(starBar);
			starBar.y = renderHeight * .2;
			starBar.x = renderwidth /2 - starBar.width/2;
			
			
			var icon:Image = new Image(Game.assets.getTexture(properName+"Icon"));
			icon.width = renderwidth*0.18;
			icon.scaleY = icon.scaleX;
			container.addChild(icon);
			icon.x = renderwidth*0.02;
			icon.y = renderHeight * 0.35;
			
			var mesText:TextField = FieldController.createNoFontField(renderwidth*0.8,renderHeight*0.1,LanguageController.getInstance().getString(properName + "Mes"),0x000000,0);
			mesText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(mesText);
			mesText.x = renderwidth*0.2;
			mesText.y = renderHeight * 0.35;
			
			var change1L:String;
			var change1R:String;
			var change2L:String;
			var change2R:String;
			switch(properName)
			{
				case "health":
				{
					change1L = String(heroData.healthBase +  currentLevel * heroData.healthUp);
					change1R = String(heroData.healthBase + (currentLevel+1) * heroData.healthUp);
					break;
				}
				case "power":
				{
					change1L = String(heroData.powerBase + 	currentLevel * heroData.powerUp);
					change1R = String(heroData.powerBase + (currentLevel+1) * heroData.powerUp);
					break;
				}
				case "crit":
				{
					change1L = String(heroData.critBase +  currentLevel * heroData.critUp)+"%";
					change1R = String(heroData.critBase + (currentLevel+1) * heroData.critUp)+"%";
					
					change2L = String(heroData.critHurtBase +  currentLevel * heroData.critHurtUp)+"%";
					change2R = String(heroData.critHurtBase + (currentLevel+1) * heroData.critHurtUp)+"%";
					break;
				}
				case "agility":
				{
					change1L = String(heroData.agilityBase +  currentLevel * heroData.agilityUp)+"%";
					change1R = String(heroData.agilityBase + (currentLevel+1) * heroData.agilityUp)+"%";
					
					change2L = String(heroData.rangeBase +  currentLevel * heroData.rangeUp)+"%";
					change2R = String(heroData.rangeBase + (currentLevel+1) * heroData.rangeUp)+"%";
					break;
				}
				case "wisdom":
				{
					change1L = String(heroData.wisdomBase +  currentLevel * heroData.wisdomUp)+"%";
					change1R = String(heroData.wisdomBase + (currentLevel+1) * heroData.wisdomUp)+"%";
					break;
				}
				case "money":
				{
					change1L = String(heroData.moneyBase +  currentLevel * heroData.moneyUp)+"%";
					change1R = String(heroData.moneyBase + (currentLevel+1) * heroData.moneyUp)+"%";
					break;
				}
			}
			
			if(currentLevel >= 10){
				change2R =  change1R = "Max";
			}else{
				change2R =  " -> " + change2R;
				change1R =  " -> " + change1R;
			}
			
			var changename01:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15,LanguageController.getInstance().getString(properName),0x458B00,0,true);
			changename01.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(changename01);
			changename01.x = renderwidth *0.2;
			changename01.y = renderHeight * 0.45;
				 
			var changeText01:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15, ": "+change1L,0x000000,0);
			changeText01.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(changeText01);
			changeText01.x = changename01.x + changename01.width;
			changeText01.y = changename01.y;
			
			var changeText02:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15, change1R,0x00F5FF,0);
			changeText02.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(changeText02);
			changeText02.x = changeText01.x + changeText01.width;
			changeText02.y = changename01.y;
			
			if(properName == "crit" || properName == "agility"){
				var changename02:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15,LanguageController.getInstance().getString(properName),0x458B00,0,true);
				changename02.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(changename02);
				changename02.x = renderwidth *0.2;
				changename02.y = renderHeight * 0.6;
				
				var changeText03:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15,": "+change2L,0x000000,0);
				changeText03.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(changeText03);
				changeText03.x = changename02.x + changename02.width;
				changeText03.y = changename02.y;
				
				var changeText04:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15, change2R,0x00F5FF,0);
				changeText04.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(changeText04);
				changeText04.x = changeText03.x + changeText03.width;
				changeText04.y = changename02.y;
			}
			
			var coinBut:Button = new Button();
			var coinIcon:Image = new Image(Game.assets.getTexture("CoinIcon"));
			coinIcon.width = coinIcon.height = renderHeight*0.2;
			coinBut.defaultIcon = coinIcon;
			coinBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
			coinBut.label = String(Configrations.heroPropertyCoin(currentLevel+1));
			coinBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, renderHeight*0.2, 0x000000);
			coinBut.paddingLeft = coinBut.paddingRight = renderwidth*0.05;
			coinBut.paddingTop = coinBut.paddingBottom = renderHeight*0.01;
			container.addChild(coinBut);
			coinBut.x = renderwidth*0.2 ;
			coinBut.y = renderHeight * 0.75;
		}
		
		private function get heroData():HeroData
		{
			return GameController.instance.localPlayer.heroData;
		}
	}
}

