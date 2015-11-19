package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.MapListRender;
	
	public class HeroPropertyPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		public function HeroPropertyPanel()
		{
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
			titleSkin.y = panelheight*0.1;
			
			var titleText:TextField = FieldController.createNoFontField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("hero")+" "+LanguageController.getInstance().getString("property"),0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  panelheight*0.1;
			
			configModeContainer();
			
			var cancleBut:Button = new Button();
			cancleBut.defaultSkin = new Image(Game.assets.getTexture("R_button"));
			cancleBut.label = LanguageController.getInstance().getString("cancel");
			cancleBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			cancleBut.paddingLeft = cancleBut.paddingRight = 20*panelScale;
			cancleBut.height = panelheight*0.08;
			addChild(cancleBut);
			cancleBut.validate();
			cancleBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			cancleBut.x = panelwidth/2 - cancleBut.width - panelwidth*0.05;
			cancleBut.y = panelheight*0.7;
			
			var confirmBut:Button = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			confirmBut.x = panelwidth/2 + panelwidth*0.05;
			confirmBut.y = panelheight*0.7;
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerOut);
			
		}
		private function configModeContainer():void
		{
			const listLayout1: HorizontalLayout= new HorizontalLayout();
			listLayout1.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.gap = panelwidth*0.02;
			
			modeList = new List();
			modeList.layout = listLayout1;
			modeList.dataProvider = new ListCollection(["easy","normal","hard"]);
			modeList.itemRendererFactory =function tileListItemRendererFactory():MapListRender
			{
				var renderer:MapListRender = new MapListRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
				renderer.defaultSelectedSkin = new Image(Game.assets.getTexture("RPanelSkin"));
				renderer.width =renderer.height =  panelwidth *0.15;
				return renderer;
			}
			
			modeList.width =  panelwidth*0.6;
			modeList.height =  panelheight*0.3;
			modeList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			addChild(modeList);
			modeList.x = panelwidth/2 - modeList.width/2;
			modeList.y = panelheight*0.2;
			modeList.addEventListener(Event.CHANGE,onModeChange);
			
		}
		private var modeList:List;
		private function onModeChange(e:Event):void
		{
		}
		
		
		
		private function onTriggerConfirm(e:Event):void
		{
			dispose();
		}
		private function onTriggerOut(e:Event):void
		{
			dispose();
		}
		override public function dispose():void
		{
			GameController.instance.showWorldScene();
			removeFromParent();
			super.dispose();
		}
		
	}
}

