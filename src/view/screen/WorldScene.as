package view.screen
{
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import view.render.MapListRender;

	public class WorldScene extends Sprite
	{
		public var scenewidth:Number;
		public var sceneheight:Number;
		private var sX:Number;
		private var sY:Number;
		
		private var uiLayer:Sprite;
		
		public function WorldScene()
		{
			initializeHandler();
		}
		
		
		protected function initializeHandler():void
		{
			var sceneBack:Image = new Image(Game.assets.getTexture("SceneMap"));
			addChild(sceneBack);
//			
//			sX = sY = Math.max(Configrations.ViewPortWidth/sceneBack.width,Configrations.ViewPortHeight/sceneBack.height);
//			sceneBack.scaleX = sX;
//			sceneBack.scaleY = sY;
			
			sceneBack.width = Configrations.ViewPortWidth;
			sceneBack.height = Configrations.ViewPortHeight;
			
			
			uiLayer = new Sprite;
			addChild(uiLayer);
			
			configMapList();
		}
		
		private function configMapList():void
		{
			const listLayout1: TiledRowsLayout= new TiledRowsLayout();
			listLayout1.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout1.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			listLayout1.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout1.useSquareTiles = true;
			listLayout1.manageVisibility = true;
			
			var mapList:List = new List();
			mapList.layout = listLayout1;
			mapList.dataProvider = getMapInfoListData();
			mapList.width =  Configrations.ViewPortWidth ;
			mapList.height = Configrations.ViewPortHeight * 0.9;
			mapList.itemRendererFactory =function tileListItemRendererFactory():MapListRender
			{
				
				var renderer:MapListRender = new MapListRender();
				renderer.width = Configrations.ViewPortWidth * 0.95;
				renderer.height =  Configrations.ViewPortHeight * 0.9;
				return renderer;
			}
			mapList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			mapList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			mapList.snapToPages = true;
			uiLayer.addChild(mapList);
			mapList.x = 0;
			mapList.y = Configrations.ViewPortHeight * 0.05;
			mapList.validate();
			
		}
		
		private function getMapInfoListData():ListCollection
		{
			var arr:Array = SpecController.instance.getGroupArr("Map");
			return new ListCollection(arr);
		}
		
		
		
	}
}