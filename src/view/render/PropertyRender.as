package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.MapItemSpec;
	import model.item.HeroData;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
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
			
			var levelL:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.2,"(" +currentLevel,0x000000,0,true);
			levelL.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(levelL);
			levelL.x = nameText.x + nameText.width + renderwidth*0.1;
			
			var levelT:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.2,"/10)",0x000000,0,true);
			levelT.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(levelT);
			levelT.x = levelL.x + levelL.width;
			
			var starBar:TenStarBar = new TenStarBar(currentLevel,Math.min(renderHeight*1.5,renderwidth*0.9));
			container.addChild(starBar);
			starBar.y = renderHeight * .2;
			starBar.x = renderwidth /2 - starBar.width/2;
				 
			
		}
		
		private function get heroData():HeroData
		{
			return GameController.instance.localPlayer.heroData;
		}
	}
}

