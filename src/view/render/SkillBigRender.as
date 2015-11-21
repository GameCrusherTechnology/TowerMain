package view.render
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.SkillItemSpec;
	import model.item.TreasureItem;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SkillBigRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderheight:Number;
		public function SkillBigRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var type:String;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderheight = height;
			super.data = value;
			type = String(value);
			if(type){
				if(container){
					container.removeFromParent(true);
				}
				configContainer();
			}
		}
		
		private var itemList:List;
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			
			itemList = new List();
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalGap = renderwidth * 0.025;
			listLayout.verticalGap = renderheight * 0.025;
			listLayout.paddingTop = renderheight * 0.2;
			listLayout.useSquareTiles = false;
			
			itemList.layout = listLayout;
			itemList.dataProvider = getListData();
			itemList.itemRendererFactory =function tileListItemRendererFactory():SkillRender
			{
				var renderer:SkillRender = new SkillRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("BPanelSkin"));
				renderer.defaultSelectedSkin = new Image(Game.assets.getTexture("DPanelSkin"));
				renderer.height = renderer.width = renderwidth *0.25;
				return renderer;
			}
			itemList.width =  renderwidth;
			itemList.height =  renderheight;
			itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			itemList.horizontalScrollPolicy = List.SCROLL_POLICY_OFF;
			container.addChild(itemList);
			itemList.selectedIndex = -1;
			itemList.addEventListener(Event.CHANGE,onListChange);
			
		}
		private function getListData():ListCollection
		{
			var arr:Array = [];
			var groupArr:Array = SpecController.instance.getGroupArr("Skill");
			var i:int;
			var spec :SkillItemSpec;
			for (i;i<groupArr.length;i++){
				spec = groupArr[i];
				if(spec){
					if(type == spec.type){
						arr.push(spec);
					}
				}
			}
			return new ListCollection(arr);
		}
		private function onListChange(e:Event):void
		{
			var item:SkillItemSpec = itemList.selectedItem as SkillItemSpec;
			if(item){
				DialogController.instance.showSkillMPanel(item);
			}
		}
		
		private function get user():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}
