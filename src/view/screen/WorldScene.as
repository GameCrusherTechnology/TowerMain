package view.screen
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	
	import controller.DialogController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.MapItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import view.compenent.HeroButton;
	import view.compenent.SkillButton;
	import view.panel.BattleInfoPanel;
	import view.panel.MapPanel;
	import view.render.MapListRender;

	public class WorldScene extends Sprite
	{
		public var scenewidth:Number;
		public var sceneheight:Number;
		private var sX:Number;
		private var sY:Number;
		
		private var bgLayer:Sprite;
		private var uiLayer:Sprite;
		private var bgScale:Number;
		public function WorldScene()
		{
			initializeHandler();
		}
		
		
		protected function initializeHandler():void
		{
			bgLayer = new Sprite;
			addChild(bgLayer)
			uiLayer = new Sprite;
			addChild(uiLayer)
			
			var sceneBack:Image = new Image(Game.assets.getTexture("SceneMap"));
			bgLayer.addChild(sceneBack);
			
			bgScale = Math.max(Configrations.ViewPortWidth/sceneBack.width,Configrations.ViewPortHeight/sceneBack.height);
			sceneBack.scaleX = sceneBack.scaleY = bgScale;
			scenewidth = sceneBack.width;
			sceneheight = sceneBack.height;
			bgLayer.addEventListener(TouchEvent.TOUCH,onTouch);
			
			
			
			configMapList();
			configUI();
		}
		
		private var mouseDownPos:Point;
		private var _hasDragged:Boolean;
		protected function get mouseStagePosition():Point{
			return new Point(stage.pivotX,stage.pivotY);
		}
		public function onTouch(evt:TouchEvent):void{
			var scenePos:Point;
			var touches:Vector.<Touch> = evt.getTouches(this, TouchPhase.MOVED);
			if (touches.length >= 1){
				
				if(!_hasDragged){
					if (mouseStagePosition && mouseDownPos && mouseStagePosition.subtract(mouseDownPos).length >= Configrations.CLICK_EPSILON){
						_hasDragged = true;
					}
				}else{
					var delta:Point = touches[0].getMovement(this.parent);
					this.dragScreenTo(delta);
				}
			}
			
			//touch begin
			var beginTouch:Touch = evt.getTouch(this,TouchPhase.BEGAN);
			if(beginTouch){
				mouseDownPos = new Point(beginTouch.globalX, beginTouch.globalY);
			}
			
			var touch:Touch = evt.getTouch(this, TouchPhase.ENDED);
			//click event
			if(touch){
				if(_hasDragged){
					_hasDragged=false;
				}
			}
		}
		
		protected function dragScreenTo(delta:Point):void
		{
			if(bgLayer.x+delta.x >0){
				bgLayer.x = 0;
			}else if((bgLayer.x+delta.x)<(Configrations.ViewPortWidth - scenewidth)){
				bgLayer.x = (Configrations.ViewPortWidth - scenewidth);
			}else{
				bgLayer.x+=delta.x;
			}
			if(bgLayer.y+delta.y >0){
				bgLayer.y = 0;
			}else if((bgLayer.y+delta.y)<(Configrations.ViewPortHeight - sceneheight)){
				bgLayer.y = (Configrations.ViewPortHeight - sceneheight);
			}else{
				bgLayer.y+=delta.y;
			}
		}
		
		private function configMapList():void
		{
			var skinContainer:Sprite = new Sprite;
			bgLayer.addChild(skinContainer);
			
			var shape:Shape ;
			var totalPoint:Array = [new Point(100,200),new Point(200,200),new Point(300,200),new Point(400,200),new Point(500,200),new Point(600,200),
				new Point(700,200),new Point(700,500),new Point(700,600),new Point(700,700)];
			var point:Point;
			for(var p:int = 0 ; p<totalPoint.length; p++){
				point = totalPoint[p];
				creatTBut(p,skinContainer,point,bgScale);
				
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
			
			var bitmapData:BitmapData =new BitmapData(1200,650,true,0);
			bitmapData.draw(shape);
			var roadImage:Image = new Image(Texture.fromBitmapData(bitmapData));
			skinContainer.addChildAt(roadImage,0);
			
			skinContainer.scaleX = skinContainer.scaleY = bgScale;
			
		}
		
		private function creatTBut(index:int,c:Sprite,pos:Point,s:Number):void
		{
			var but:Button = new Button();
			var icon:Image = new Image(Game.assets.getTexture("RoadLightIcon"));
			icon.width = Configrations.ViewPortWidth*0.05;
			icon.scaleY = icon.scaleX;
			but.defaultIcon = icon;
			but.name = String(40000 + index);
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
				var mapSpec:MapItemSpec = SpecController.instance.getItemSpec(target.name) as MapItemSpec;
				if(mapSpec)
				{
					DialogController.instance.showPanel(new MapPanel(mapSpec));
				}
			}
		}
		
		private function getMapInfoListData():ListCollection
		{
			var arr:Array = SpecController.instance.getGroupArr("Map");
			return new ListCollection(arr);
		}
		
		private var heroButton:HeroButton;
		private var skillButton:SkillButton;
		private function configUI():void
		{
			heroButton = new HeroButton(Configrations.ViewPortWidth *0.1);
			uiLayer.addChild(heroButton);
			heroButton.x = Configrations.ViewPortWidth *0.1;
			heroButton.y = Configrations.ViewPortHeight*0.99 - Configrations.ViewPortWidth *0.1;
			
			skillButton = new SkillButton(Configrations.ViewPortWidth *0.1);
			uiLayer.addChild(skillButton);
			skillButton.x = Configrations.ViewPortWidth *0.3;
			skillButton.y = Configrations.ViewPortHeight*0.99 - Configrations.ViewPortWidth *0.1;
		}
		
		
	}
}