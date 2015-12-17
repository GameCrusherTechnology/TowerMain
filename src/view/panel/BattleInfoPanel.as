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
	
	import model.battle.BattleRule;
	import model.gameSpec.BattleItemSpec;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.ModeListRender;
	
	public class BattleInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var battleSpec:BattleItemSpec;
		public function BattleInfoPanel(battleItemSpec:BattleItemSpec)
		{
			battleSpec = battleItemSpec;
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
			
			var titleText:TextField = FieldController.createNoFontField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("selectmode"),0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  panelheight*0.1;
			
			configModeContainer();
			
			var confirmBut:Button = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("begin");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			confirmBut.x = panelwidth/2 - confirmBut.width/2;
			confirmBut.y = panelheight*0.7;
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.15 - panelheight*0.05;
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
			var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60)));
			listSkin.alpha = 0.5;
			modeList.backgroundSkin =listSkin;
			modeList.layout = listLayout1;
			modeList.dataProvider = new ListCollection(["easy","normal","hard"]);
			modeList.itemRendererFactory =function tileListItemRendererFactory():ModeListRender
			{
				var renderer:ModeListRender = new ModeListRender();
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
			
			messText01 = FieldController.createNoFontField(panelwidth,panelheight*0.06,LanguageController.getInstance().getString("hurt")+":" + "100%",0x000000,0,true);
			addChild(messText01);
			messText01.x = panelwidth/2 - messText01.width/2;
			messText01.y = panelheight*0.5;
			
			messText02 = FieldController.createNoFontField(panelwidth,panelheight*0.06,LanguageController.getInstance().getString("health")+":" + "100%",0x000000,0,true);
			addChild(messText02);
			messText02.x = panelwidth/2 - messText02.width/2;
			messText02.y = panelheight*0.58;
			
			modeList.selectedIndex = 1;
			
		}
		private var modeList:List;
		private var messText01:TextField;
		private var messText02:TextField;
		private function onModeChange(e:Event):void
		{
			var itemStr:String = String(modeList.selectedItem);
			if(itemStr){
				if(itemStr == "easy"){
					messText01.text =  LanguageController.getInstance().getString("mhurt")+": " + "80%";
					messText02.text =  LanguageController.getInstance().getString("mhealth")+": " + "80%";
				}else if(itemStr == "normal"){
					messText01.text =  LanguageController.getInstance().getString("mhurt")+": " + "100%";
					messText02.text =  LanguageController.getInstance().getString("mhealth")+": " + "100%";
				}else{
					messText01.text =  LanguageController.getInstance().getString("mhurt")+": " + "120%";
					messText02.text =  LanguageController.getInstance().getString("mhealth")+": " + "120%";
				}
			}
		}
		
		
		
		private function onTriggerConfirm(e:Event):void
		{
			GameController.instance.beginBattle(new BattleRule(battleSpec,String(modeList.selectedItem)));
			dispose();
		}
		private function onTriggerOut(e:Event):void
		{
			dispose();
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
		
	}
}


