package view.render
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.MapItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
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
		
		private var bgTexture:Texture;
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			
			
			switch(itemSpec.name)
			{
				case "map00":
				{
					bgTexture = Configrations.BattleMap00Texture
					break;
				}
				case "map01":
				{
					bgTexture = Configrations.BattleMap01Texture
					break;
				}
				case "map02":
				{
					bgTexture = Configrations.BattleMap02Texture
					break;
				}
				case "map03":
				{
					bgTexture = Configrations.BattleMap03Texture
					break;
				}
				case "map04":
				{
					bgTexture = Configrations.BattleMap04Texture
					break;
				}
				case "map05":
				{
					bgTexture = Configrations.BattleMap05Texture
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			var skinContainer:Sprite = new Sprite;
			container.addChild(skinContainer);
			
			
			
			var mapImage:Image = new Image(bgTexture);
			var i:Number = Math.min(renderHeight*0.95 /mapImage.height,renderwidth*0.95 /mapImage.width);
			skinContainer.addChild(mapImage);

			var shape:Shape ;
			var totalPoint:Array = itemSpec.totalT;
			var point:Point;
			for(var p:int = 0 ; p<totalPoint.length; p++){
				point = totalPoint[p];
				creatTBut(p,skinContainer,point,i);
				
				if(!shape){
					shape = new Shape();
					shape.graphics.lineStyle(5,0xffffff,0.5);
					shape.graphics.moveTo(point.x,point.y);
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
			
			skinContainer.scaleX = skinContainer.scaleY = i;
			skinContainer.x = renderwidth/2 - skinContainer.width/2;
			skinContainer.y = renderHeight/2 - skinContainer.height/2;
			
			var title:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.1,itemSpec.cname,0xffffff,0,true);
			title.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(title);
			title.x = skinContainer.x + renderwidth *0.05;
			title.y = skinContainer.y;
			
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
			but.x = pos.x - icon.width/2;
			but.y = pos.y - icon.height;
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
			if(bgTexture){
				bgTexture.dispose();
			}
			super.dispose();
		}
	}
}


