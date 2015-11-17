package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	import model.staticData.VipListData;
	import model.staticData.VipUsedData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class VipTextRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function VipTextRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var viplistData:VipListData;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			viplistData = value as VipListData;
			if(viplistData){
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
			
			
			var spec:ItemSpec = viplistData.itemSpec;
			var icon:Image;
			if(spec){
				icon = new Image(spec.iconTexture);
				icon.height = renderHeight*0.8;
				icon.scaleX = icon.scaleY;
				container.addChild(icon);
				icon.x = renderwidth *0.02;
				icon.y = renderHeight *0.1;
			}
			
			
			var nameText:TextField = FieldController.createNoFontField(renderwidth*0.6,renderHeight,LanguageController.getInstance().getString(viplistData.name),0x000000,renderHeight*0.5);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			if(icon){
				nameText.x = icon.x + icon.width + renderwidth *0.02;
			}else{
				nameText.x = renderwidth *0.02;
			}
			
			
			var countText2:TextField = FieldController.createNoFontField(renderwidth,renderHeight,viplistData.getData(),0x000000);
			countText2.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(countText2);
			countText2.x = renderwidth*0.78 ;
			
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

