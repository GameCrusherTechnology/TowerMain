package view.render
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import controller.DialogController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.MapItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import view.panel.BattleInfoPanel;

	public class MapListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function MapListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var itemSpec:MapItemSpec;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = itemSpec = value as MapItemSpec ;
			if(itemSpec){
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
			var lcs:Class = Configrations.MapClsObject[itemSpec.name];
			
			var bgTexture:Texture = Texture.fromEmbeddedAsset(lcs); 
			
			var skinContainer:Sprite = new Sprite;
			container.addChild(skinContainer);
			
			var mapImage:Image = new Image(bgTexture);
			var i:Number = Math.min(renderHeight*0.95 /mapImage.height,renderwidth*0.95 /mapImage.width);
			mapImage.scaleX = mapImage.scaleY = i;
			skinContainer.addChild(mapImage);
			
			skinContainer.x = renderwidth/2 - mapImage.width/2;
			skinContainer.y = renderHeight/2 - mapImage.height/2;
			

			var shape:Shape ;
			var totalPoint:Array = itemSpec.totalT;
			var point:Point;
			for(var p:int = 0 ; p<totalPoint.length; p++){
				point = totalPoint[p];
				
				creatTBut(p,skinContainer,point,i);
				
				if(!shape){
					shape = new Shape();
					shape.graphics.lineStyle(5,0xffffff,0.5);
					shape.graphics.moveTo(point.x * i,point.y *i);
				}else if(p < totalPoint.length -1){
					var xc:Number = (point.x + totalPoint[p + 1].x) / 2;
					var yc:Number = (point.y + totalPoint[p + 1].y) / 2;
					shape.graphics.curveTo(point.x, point.y, xc, yc);
				}else{
					shape.graphics.lineTo(point.x, point.y);
				}
			}
			shape.graphics.endFill();
			
			var bitmapData:BitmapData =new BitmapData(mapImage.width,mapImage.height,true,0);
			bitmapData.draw(shape);
			var roadImage:Image = new Image(Texture.fromBitmapData(bitmapData));
			skinContainer.addChildAt(roadImage,1);
			
			var text:int = 1;
			
		}
		
		private function creatTBut(index:int,c:Sprite,pos:Point,s:Number):void
		{
			var but:Button = new Button();
			var icon:Image = new Image(Game.assets.getTexture("RoadLightIcon"));
			icon.width = renderwidth*0.05;
			icon.scaleY = icon.scaleX;
			but.defaultIcon = icon;
			but.name = String(20000+ (int(itemSpec.item_id)%1000+1)*100 + index);
			but.addEventListener(Event.TRIGGERED,onTroggered);
			c.addChild(but);
			but.x = pos.x * s;
			but.y = pos.y * s;
		}
		private function onTroggered(e:Event):void
		{
			var target:Button = e.target as Button;
			if(target)
			{
				var battleSpec:BattleItemSpec = SpecController.instance.getItemSpec(target.name) as BattleItemSpec;
				if(battleSpec)
				{
					DialogController.instance.showPanel(new BattleInfoPanel(battleSpec));
				}
			}
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


