package view.screen
{
	import flash.geom.Point;
	
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.data.ListCollection;
	
	import gameconfig.Configrations;
	
	import model.player.GameUser;
	import model.player.PlayerEvent;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.compenent.GreenProgressBar;
	import view.compenent.HeroButton;
	import view.compenent.HeroPropertyButton;
	import view.compenent.MusicButton;
	import view.compenent.ShopButton;
	import view.compenent.SkillButton;
	import view.compenent.SoundButton;
	import view.compenent.WorldMapButton;

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
		
		private var mapListContainer:Sprite;
		public function configMapList():void
		{
			if(mapListContainer){
				mapListContainer.removeFromParent(true);
				mapListContainer = null;
			}
			mapListContainer = new Sprite;
			bgLayer.addChild(mapListContainer);
			
			var totalPoint:Array = [	new Point(scenewidth *0.215,sceneheight*0.39),
										new Point(scenewidth *0.5,sceneheight*0.47),
										new Point(scenewidth *0.62,sceneheight*0.2),
										new Point(scenewidth *0.85,sceneheight*0.3),
										new Point(scenewidth *0.75,sceneheight*0.1),
										new Point(scenewidth *0.3,sceneheight*0.13)];
			
			
			var point:Point;
			var mapBut:WorldMapButton;
			var curM:int = player.heroData.curmap;
			for(var p:int = 0 ; p<totalPoint.length; p++){
				point = totalPoint[p];
				if(p <= curM){
					mapBut = new WorldMapButton(scenewidth *0.06,p,true);
					mapListContainer.addChild( mapBut);
					mapBut.x = point.x  - scenewidth *0.03;
					mapBut.y = point.y  +scenewidth *0.06;
				}
			}
		}
		
		
		private function getMapInfoListData():ListCollection
		{
			var arr:Array = SpecController.instance.getGroupArr("Map");
			return new ListCollection(arr);
		}
		
		private var heroButton:HeroButton;
		private var heroProButton:HeroPropertyButton;
		private var skillButton:SkillButton;
		private var treasureButton:ShopButton;
		private function configUI():void
		{
			heroButton = new HeroButton(Configrations.ViewPortWidth *0.1);
			uiLayer.addChild(heroButton);
			heroButton.x = Configrations.ViewPortWidth *0.1;
			heroButton.y = Configrations.ViewPortHeight*0.99 - Configrations.ViewPortWidth *0.1;
			
			heroProButton = new HeroPropertyButton(Configrations.ViewPortWidth *0.1);
			uiLayer.addChild(heroProButton);
			heroProButton.x = Configrations.ViewPortWidth *0.3;
			heroProButton.y = Configrations.ViewPortHeight*0.99 - Configrations.ViewPortWidth *0.1;
			
			skillButton = new SkillButton(Configrations.ViewPortWidth *0.1);
			uiLayer.addChild(skillButton);
			skillButton.x = Configrations.ViewPortWidth *0.5;
			skillButton.y = Configrations.ViewPortHeight*0.99 - Configrations.ViewPortWidth *0.1;
			
			treasureButton = new ShopButton(Configrations.ViewPortWidth *0.1);
			uiLayer.addChild(treasureButton);
			treasureButton.x = Configrations.ViewPortWidth *0.7;
			treasureButton.y = Configrations.ViewPortHeight*0.99 - Configrations.ViewPortWidth *0.1;
			
			
			var nextCoin:int = (int(player.coin /10000)+1)*1000;
			var coinBar:GreenProgressBar  = new GreenProgressBar(Configrations.ViewPortWidth*0.3,Configrations.ViewPortHeight*0.05,2);
			uiLayer.addChild(coinBar);
			coinBar.comment = player.coin +"";
			coinBar.progress = player.coin / nextCoin;
			player.addEventListener(PlayerEvent.CoinChange,function():void{
				var nextCoin:int = (int(player.coin /100)+1)*100;
				coinBar.comment = player.coin +"";
				coinBar.progress = player.coin / nextCoin;}
			);
			
			var coinIcon:Image = new Image(Game.assets.getTexture("CoinIcon"));
			coinIcon.width = coinIcon.height = Configrations.ViewPortHeight *0.08;
			uiLayer.addChild(coinIcon);
			coinIcon.x = Configrations.ViewPortWidth*0.01;
			coinIcon.y = Configrations.ViewPortHeight*0.02;
			
			coinBar.x = coinIcon.x + coinIcon.width/2;
			coinBar.y = coinIcon.y + coinIcon.height/2 - coinBar.height/2;
			
			
			var nextGem:int = (int(player.gem /100)+1)*50;
			var gemBar:GreenProgressBar  = new GreenProgressBar(Configrations.ViewPortWidth*0.25,Configrations.ViewPortHeight*0.05,2);
			uiLayer.addChild(gemBar);
			gemBar.comment = player.gem +"";
			gemBar.progress = player.gem / nextGem;
			player.addEventListener(PlayerEvent.GemChange,function():void{
				var nextGem:int = (int(player.gem /100)+1)*100;
				gemBar.comment = player.gem +"";
				gemBar.progress = player.gem / nextGem;}
			);
			
			var gemIcon:Image = new Image(Game.assets.getTexture("GemIcon"));
			gemIcon.width = gemIcon.height = Configrations.ViewPortHeight *0.08;
			uiLayer.addChild(gemIcon);
			gemIcon.x = Configrations.ViewPortWidth*0.01;
			gemIcon.y = Configrations.ViewPortHeight*0.11;
			
			gemBar.x = gemIcon.x + gemIcon.width/2;
			gemBar.y = gemIcon.y + gemIcon.height/2 - gemBar.height/2;
			
			
			var soundBut:SoundButton = new SoundButton(Configrations.ViewPortHeight *0.08);
			uiLayer.addChild(soundBut);
			soundBut.x = Configrations.ViewPortWidth *0.98 - Configrations.ViewPortHeight *0.08 ;
			soundBut.y = Configrations.ViewPortHeight*0.02 ;
			
			var musicBut:MusicButton = new MusicButton(Configrations.ViewPortHeight *0.08);
			uiLayer.addChild(musicBut);
			musicBut.x = soundBut.x - Configrations.ViewPortWidth *0.02 - Configrations.ViewPortHeight *0.08;
			musicBut.y = Configrations.ViewPortHeight*0.02 ;
			
		}
		
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		
	}
}