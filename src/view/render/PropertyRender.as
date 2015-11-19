package view.render
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.MapItemSpec;
	
	import starling.display.Sprite;
	
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
		
		private var mapSpec:MapItemSpec;
		
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			mapSpec = value as MapItemSpec;
			if(mapSpec ){
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
		}
	}
}

