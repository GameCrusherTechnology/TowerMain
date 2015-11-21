package view.panel
{
	import flash.geom.Point;
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
	
	import model.gameSpec.SkillItemSpec;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class SkillInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var backBut:Button;
		private var itemspec:SkillItemSpec;
		private var posi:Point;
		public function SkillInfoPanel(spec:SkillItemSpec,pos:Point = null)
		{
			itemspec = spec;
			posi = pos;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		public function reset(spec:SkillItemSpec,pos:Point = null):void
		{
			itemspec = spec;
			posi = pos;
			config();
		}
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			config();
			
		}
		private var container:Sprite;
		private function config():void
		{
			if(container){
				container.removeFromParent(true);
			}
			
			container = new Sprite;
			addChild(container);
			
			var curlevel:int = 0;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			container.addChild(blackSkin);
			blackSkin.alpha = 1;
			blackSkin.width = panelwidth*0.9;
			blackSkin.height = panelheight*0.3;
			
			var icon:Image = new Image(itemspec.iconTexture);
			icon.width = icon.height = panelheight*0.1;
			container.addChild(icon);
			icon.x = panelwidth *0.1;
			icon.y = panelheight*0.02;
			
			var nameText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05,itemspec.cname,0xffffff,0,true);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = icon.x + icon.width + panelwidth*0.02;
			nameText.y = 0;
			
			
			var typeText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05,itemspec.name,0xffffff,0,true);
			typeText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(typeText);
			typeText.x = nameText.x ;
			typeText.y = nameText.y+nameText.height;
			
			var mesText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString(itemspec.name+"Mes"+curlevel),0xffffff,0,true);
			mesText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(mesText);
			mesText.x = nameText.x ;
			mesText.y = typeText.y+typeText.height;
			
			
			var nextText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("nextLevel"),0xffffff,0,true);
			nextText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nextText);
			nextText.x = nameText.x ;
			nextText.y = mesText.y+mesText.height;
			
			var nextmesText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString(itemspec.name+"Mes"+(curlevel+1)),0xffffff,0,true);
			nextmesText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nextmesText);
			nextmesText.x = nameText.x ;
			nextmesText.y = nextText.y+nextText.height;
			
			addBut = new Button;
			
			var butImg :Image = new Image(Game.assets.getTexture("AddIcon"));
			butImg.width = butImg.height = panelheight *0.08;
			addBut.defaultIcon = butImg;
			addBut.defaultSkin = new Image(Game.assets.getTexture("PanelBackSkin"));
			addBut.padding = panelheight *0.01;
			container.addChild(addBut);
			addBut.x = panelwidth*0.7;
			addBut.y = icon.y;
			addBut.addEventListener(Event.TRIGGERED,onAdded);
			
			
			if(!posi){
				posi = new Point(panelwidth*0.05,panelheight * 0.7);
			}
			x = posi.x;
			y = posi.y;
			
		}
		
		private var addBut:Button;
		private function onAdded(e:Event):void
		{
			
		}
		
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		
	}
}