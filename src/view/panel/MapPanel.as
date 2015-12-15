package view.panel
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.MapItemSpec;
	import model.item.HeroData;
	import model.item.OwnedItem;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	import view.compenent.ThreeStarBar;

	public class MapPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var itemSpec:MapItemSpec
		public function MapPanel(spec:MapItemSpec)
		{
			itemSpec = spec;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			blackSkin.addEventListener(TouchEvent.TOUCH,onTouched);
			
			configContainer();
		}
		
		private function onTouched(e:TouchEvent):void
		{
			var beginTouch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if(beginTouch){
				dispose();
			}
		}
		private var bgTexture:Texture;
		private function configContainer():void
		{
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
			addChild(skinContainer);
			
			
			
			var mapImage:Image = new Image(bgTexture);
			var i:Number = Math.min(panelheight*0.95 /mapImage.height,panelwidth*0.95 /mapImage.width);
			skinContainer.addChild(mapImage);
			
//			var shape:Shape ;
			var totalPoint:Array = itemSpec.totalT;
			var point:Point;
			var lastOpen:Boolean = true;
			var curMapItem:OwnedItem;
			var herodata:HeroData = GameController.instance.localPlayer.heroData;
			for(var p:int = 0 ; p<totalPoint.length; p++){
				point = totalPoint[p];
				var id:String = String(20000+ (int(itemSpec.item_id)%1000+1)*100 + p);
				curMapItem = herodata.getMap(id);
				if(curMapItem.count > 0){
					creatTBut(id,curMapItem.count,skinContainer,point,i,true);
					lastOpen = true;
				}else{
					if(lastOpen){
						creatTBut(id,0,skinContainer,point,i,true);
					}else{
						creatTBut(id,0,skinContainer,point,i,false);
					}
					lastOpen = false;
				}
				
//				if(!shape){
//					shape = new Shape();
//					shape.graphics.lineStyle(5,0xffffff,0.5);
//					shape.graphics.moveTo(point.x,point.y);
//				}else if(p < totalPoint.length -1){
//					var xc:Number = (point.x + totalPoint[p + 1].x) / 2;
//					var yc:Number = (point.y + totalPoint[p + 1].y) / 2;
//					shape.graphics.curveTo(point.x, point.y, xc, yc);
//				}else{
//					shape.graphics.lineTo(point.x, point.y);
//				}
				
			}
//			if(shape){
//				shape.graphics.endFill();
//				var bitmapData:BitmapData =new BitmapData(mapImage.width,mapImage.height,true,0);
//				bitmapData.draw(shape);
//				var roadImage:Image = new Image(Texture.fromBitmapData(bitmapData));
////				skinContainer.addChildAt(roadImage,1);
//			}
//			
			
			
			skinContainer.scaleX = skinContainer.scaleY = i;
			skinContainer.x = panelwidth/2 - skinContainer.width/2;
			skinContainer.y = panelheight/2 - skinContainer.height/2;
			
			var title:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.1,itemSpec.cname,0xffffff,0,true);
			title.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(title);
			title.x = skinContainer.x + panelwidth *0.05;
			title.y = skinContainer.y;
			
		}
		
		private function creatTBut(index:String,star:int,c:Sprite,pos:Point,s:Number,isOpen:Boolean = false):void
		{
			var but:Button = new Button();
			var icon:Image = new Image(Game.assets.getTexture("RoadLightIcon"));
			icon.width = panelwidth*0.05;
			icon.scaleY = icon.scaleX;
			but.defaultIcon = icon;
			but.name = index;
			
			c.addChild(but);
			but.x = pos.x - icon.width/2;
			but.y = pos.y - icon.height;
			if(isOpen){
				var bar:ThreeStarBar = new ThreeStarBar(star,panelwidth*0.05);
				c.addChild(bar);
				bar.x = pos.x - bar.width/2;
				bar.y = pos.y - bar.height/2;
				but.addEventListener(Event.TRIGGERED,onTroggered);
			}else{
				but.filter = Configrations.grayscaleFilter;
			}
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
			removeFromParent();
			super.dispose();
		}
	}
}