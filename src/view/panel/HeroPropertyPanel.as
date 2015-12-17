package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	
	import model.item.HeroData;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.PropertyRender;
	
	public class HeroPropertyPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var oldCoin:int;
		private var oldData:HeroData;
		private var coinText:TextField;
		
		private var coinBut:Button;
		public function HeroPropertyPanel()
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
			backSkin.width = panelwidth;
			backSkin.height = panelheight;
			backSkin.x = 0;
			backSkin.y = 0;
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = backSkin.width;
			titleSkin.height = panelheight*0.08;
			titleSkin.x =backSkin.x;
			titleSkin.y = 0;
			
			var titleText:TextField = FieldController.createNoFontField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("hero")+" "+LanguageController.getInstance().getString("property"),0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  0;
			
			
			configModeContainer();
			
			
			
			coinBut = new Button;
			var iconSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"),new Rectangle(10,10,30,30)));
			coinBut.defaultSkin = iconSkin;
			coinBut.label = String(player.coin);
			coinBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.07, 0x000000);
			var icon:Image = new Image(Game.assets.getTexture("shopIcon"));
			icon.height = panelheight*0.1;
			icon.scaleX = icon.scaleY;
			coinBut.defaultIcon = icon;
			coinBut.paddingLeft = coinBut.paddingRight = panelwidth*0.03;
			coinBut.paddingBottom = coinBut.paddingTop = panelheight*0.01;
			addChild(coinBut);
			coinBut.validate();
			coinBut.addEventListener(Event.TRIGGERED,onTriggerShop);
			coinBut.x = 0;
			coinBut.y = panelheight - coinBut.height;
			
			
			
			var confirmBut:Button = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			confirmBut.x = panelwidth/2 - confirmBut.width/2;
			confirmBut.y = panelheight*0.9;
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = 0;
			backBut.y = 0;
			backBut.addEventListener(Event.TRIGGERED,onTriggerOut);
			
		}
		private function configModeContainer():void
		{
			if(modeList){
				modeList.removeFromParent(true);
				modeList = null;
			}
			const listLayout1: TiledRowsLayout= new TiledRowsLayout();
			listLayout1.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.tileVerticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			listLayout1.verticalGap = panelheight *0.02;
			listLayout1.horizontalGap = panelwidth * 0.04;
			listLayout1.paging = TiledRowsLayout.PAGING_NONE;
			listLayout1.useSquareTiles = false;
			
			modeList = new List();
			modeList.layout = listLayout1;
			modeList.dataProvider = new ListCollection(["health","power","crit","critHurt","agility","wisdom"]);
			modeList.itemRendererFactory =function tileListItemRendererFactory():PropertyRender
			{
				var renderer:PropertyRender = new PropertyRender();
				var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(12,12,40,40)));
				renderer.defaultSkin = skin;
				renderer.width =  panelwidth *0.38;
				renderer.height =  panelheight *0.22;
				return renderer;
			}
			
			modeList.width =  panelwidth*0.8;
			modeList.height =  panelheight*0.7;
			modeList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			modeList.verticalScrollPolicy = List.SCROLL_POLICY_OFF;
			addChild(modeList);
			modeList.x = panelwidth/2 - modeList.width/2;
			modeList.y = panelheight*0.15;
			modeList.addEventListener(Event.CHANGE,onModeChange);
			
		}
		private var modeList:List;
		private function onModeChange(e:Event):void
		{
			var type:String = String(modeList.selectedItem);
			if(type){
				var curLevel:int = player.heroData[type+"Level"];
				if(curLevel < 10){
					var coinCost:int = Configrations.heroPropertyCoin(curLevel+1);
					if(player.coin >= coinCost){
						player.addCoin( - coinCost);
						player.heroData[type+"Level"] +=1;
						
						configModeContainer();
						coinBut.label = String(player.coin);
					}
				}
			}
		}
		
		
		private function onTriggerShop(e:Event):void
		{
			DialogController.instance.showPanel(new ShopPanel());
			LocalData.instance.savePlayer();
			dispose();
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			LocalData.instance.savePlayer();
			dispose();
		}
		private function onTriggerOut(e:Event):void
		{
			LocalData.instance.savePlayer();
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

