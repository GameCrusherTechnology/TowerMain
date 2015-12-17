package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	import model.item.OwnedItem;
	import model.player.GameUser;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class HeroItemRender extends DefaultListItemRenderer
	{
		private var hero:GameUser;
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var itemspec:ItemSpec;
		public function HeroItemRender()
		{
			super();
			scale = Configrations.ViewScale;
			hero = GameController.instance.localPlayer;
		}
		
		private var container:Sprite;
		private var ownedItem:OwnedItem;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			ownedItem = value as OwnedItem;
			if(ownedItem){
				refreshData();
			}
		}
		
		private function refreshData():void{
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			configContainer();
		}
		
		private var icon:DisplayObject;
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			itemspec = ownedItem.itemSpec;
			if(itemspec){
				
				
				if(itemspec.type == "weapon"){
					icon = new MovieClip(Game.assets.getTextures(itemspec.name));
					icon.width  = renderwidth *0.9;
					icon.scaleY = icon.scaleX ;
					container.addChild(icon);
					icon.x = renderwidth*0.5 - icon.width/2;
					icon.y = renderHeight*0.5 - icon.height/2;
					Starling.juggler.add(icon as MovieClip);
				}else if(itemspec.type == "defence"){
					icon = new Image(Game.assets.getTexture(itemspec.name));
					icon.height = renderHeight*0.6;
					icon.scaleX = icon.scaleY ;
					container.addChild(icon);
					icon.x = renderwidth*0.5 - icon.width/2;
					icon.y = renderHeight*0.5 - icon.height/2;
					Starling.juggler.add(icon as MovieClip);
				}
				
				var nameText:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15,itemspec.cname,0x000000,0,true);
				nameText.autoSize = TextFieldAutoSize.VERTICAL;
				container.addChild(nameText);
				nameText.y =  5*scale;
				
			}
		}
		
		override public function dispose():void
		{
			if(icon is MovieClip){
				Starling.juggler.remove(icon as MovieClip);
			}
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			super.dispose();
		}
	}
}

