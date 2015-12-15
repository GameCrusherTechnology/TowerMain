package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	import view.compenent.ThreeStarBar;
	
	public class ModeListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function ModeListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var type:String;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = type = String(value) ;
			if(type){
				if(container){
					container.removeFromParent(true);
				}
				configContainer();
			}
		}
		
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			
			var title:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.25,LanguageController.getInstance().getString(type),0x000000,0,true);
			container.addChild(title);
			
			var icon:Image = new Image(Game.assets.getTexture("BattleScoreIcon"));
			icon.width = icon.height = renderHeight *0.6;
			container.addChild(icon);
			icon.x =  renderwidth*0.5 - icon.width/2;
			icon.y = renderHeight * 0.15;
			
			var score:int;
			if(type == Configrations.Battle_Easy){
				score = 1;
			}else if(type == Configrations.Battle_Normal){
				score = 2;
			}else{
				score = 3;
			}
			var bar :ThreeStarBar = new ThreeStarBar(score,renderHeight*0.45);
			container.addChild(bar);
			bar.x =  renderwidth*0.5 - bar.width/2;
			bar.y =  renderHeight * 0.95 - bar.height;
		}
		
		override public function dispose():void
		{
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			super.dispose();
		}
	}
}

