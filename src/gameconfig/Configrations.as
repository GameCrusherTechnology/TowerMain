package gameconfig
{
	import flash.geom.Rectangle;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.textures.Scale9Textures;
	
	import model.item.TreasureItem;
	
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	import view.compenent.BattleLoadingScreen;
	

	public class Configrations
	{
		public function Configrations()
		{
		}
		//配置
		public static var PLATFORM:String = "PC";
		public static var Language:String = "en";
		public static var VERSION:String = "1.0.1";
		public static var userID:String = "shower_015";
//		public static const GATEWAY:String = "http://localhost/HeroTowerServer/data/gateway.php";
//		public static const GATEWAY:String = "http://192.168.1.100/HeroTowerServer/data/gateway.php";
		public static const GATEWAY:String = "http://192.241.208.85/TowerServer/data/gateway.php";
		
		//
		public static var file_path:String ="TT_GG";
		//ad
		public static var AD_ids:Object={};
		//宠物 给予等级
		public static const PET_SEND_LEVEL:int = 1;
		
		
		public static var ViewPortWidth:Number;
		public static var ViewPortHeight:Number;
		public static var ViewScale:Number = 1;
		public static const CLICK_EPSILON:int = 50;
		
		//battle
		public static const  Battle_Easy:String = "easy";
		public static const  Battle_Normal:String = "normal";
		public static const  Battle_Hard:String = "hard";
		
		//public AD
		public static var AD_BANNER:Boolean = false;
		
		//power
		public static const POWER_CYCLE:int = 300;
		//等级 经验值 换算
		
		public static function expToGrade(exp:Number):int{
			return int (Math.sqrt(exp/10));
		}
		public static function gradeToExp(grade:int):Number{
			return int(Math.pow(grade,2)*10);
		}
		
		
		public static const SKILL_MAX_LEVEL:int = 5;
		
		public static const INIT_USER:Object = {
			"coin" : 1000,
			"localHero":{
				
			}
			
		};
		
		public static function get isLocalTest():Boolean
		{
			return GATEWAY =="http://localhost/HeroTowerServer/data/gateway.php";
		}
		
		public static function get isCN():Boolean
		{
			return Configrations.Language == "zh-CN"||Configrations.Language =="zh-TW";
		}
		public static const Languages:Array  = ["en","zh-CN","de","ru","tr","zh-TW"];
		//loadingscene
		
		public static var BattleLoadingScene:BattleLoadingScreen;
		
		//panel texture
		private static var _WhiteSkin:Scale9Textures;
		public static function get WhiteSkinTexture():Scale9Textures
		{
			if(!_WhiteSkin){
				_WhiteSkin = new Scale9Textures(Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60));
			}
			return _WhiteSkin;
		}
		
		private static var _PanelRenderSkinTexture:Scale9Textures;
		public static function get PanelRenderSkinTexture():Scale9Textures
		{
			if(!_PanelRenderSkinTexture){
				_PanelRenderSkinTexture = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(10,10,30,30));
			}
			return _PanelRenderSkinTexture;
		}
		
		private static var _BlueRenderSkinTexture:Scale9Textures;
		public static function get BlueRenderSkinTexture():Scale9Textures
		{
			if(!_BlueRenderSkinTexture){
				_BlueRenderSkinTexture = new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70));
			}
			return _BlueRenderSkinTexture;
		}
		
		private static var _simplePanelSkinTexture:Scale9Textures;
		public static function get SimplePanelSkinTexture():Scale9Textures
		{
			if(!_simplePanelSkinTexture){
				_simplePanelSkinTexture = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"),new Rectangle(10,10,30,30));
			}
			return _simplePanelSkinTexture;
		}
		
		private static var _PanelTitleSkinTexture:Scale9Textures;
		public static function get PanelTitleSkinTexture():Scale9Textures
		{
			if(!_PanelTitleSkinTexture){
				_PanelTitleSkinTexture = new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20));
			}
			return _PanelTitleSkinTexture;
		}
		
		[Embed(source="/textures/map00.jpg")]
		private static var BattleMap00Cls:Class;
		
		[Embed(source="/textures/map01.jpg")]
		private static var BattleMap01Cls:Class;
		
		[Embed(source="/textures/map02.jpg")]
		private static var BattleMap02Cls:Class;
		
		[Embed(source="/textures/map03.jpg")]
		private static var BattleMap03Cls:Class;
		
		[Embed(source="/textures/map04.jpg")]
		private static var BattleMap04Cls:Class;
		
		[Embed(source="/textures/map05.jpg")]
		private static var BattleMap05Cls:Class;
		
		
		
		private static var _BattleMap00Texture:Texture;
		public static function get BattleMap00Texture():Texture
		{
			if(!_BattleMap00Texture){
				_BattleMap00Texture = Texture.fromEmbeddedAsset(BattleMap00Cls);
			}
			return _BattleMap00Texture;
		}
		private static var _BattleMap01Texture:Texture;
		public static function get BattleMap01Texture():Texture
		{
			if(!_BattleMap01Texture){
				_BattleMap01Texture = Texture.fromEmbeddedAsset(BattleMap01Cls);
			}
			return _BattleMap01Texture;
		}
		
		private static var _BattleMap02Texture:Texture;
		public static function get BattleMap02Texture():Texture
		{
			if(!_BattleMap02Texture){
				_BattleMap02Texture = Texture.fromEmbeddedAsset(BattleMap02Cls);
			}
			return _BattleMap02Texture;
		}
		private static var _BattleMap03Texture:Texture;
		public static function get BattleMap03Texture():Texture
		{
			if(!_BattleMap03Texture){
				_BattleMap03Texture = Texture.fromEmbeddedAsset(BattleMap03Cls);
			}
			return _BattleMap03Texture;
		}
		
		private static var _BattleMap04Texture:Texture;
		public static function get BattleMap04Texture():Texture
		{
			if(!_BattleMap04Texture){
				_BattleMap04Texture = Texture.fromEmbeddedAsset(BattleMap04Cls);
			}
			return _BattleMap04Texture;
		}
		
		private static var _BattleMap05Texture:Texture;
		public static function get BattleMap05Texture():Texture
		{
			if(!_BattleMap05Texture){
				_BattleMap05Texture = Texture.fromEmbeddedAsset(BattleMap05Cls);
			}
			return _BattleMap05Texture;
		}
		
		
		public static function get  grayscaleFilter():ColorMatrixFilter
		{
			var _grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
			_grayscaleFilter.adjustSaturation(-1);
			return _grayscaleFilter;
		}
		
		
		
		public static function heroPropertyCoin(level:int):int
		{
			return 1000*level;
		}
		
		public static const treasures:Object ={
			"littleCoin":new TreasureItem({name:"littleCoin",number:20000,price:4.99,isGem:false,index:1}),
			"middleCoin":new TreasureItem({name:"middleCoin",number:60000,price:14.99,isGem:false,index:2}),
			"largeCoin":new TreasureItem({name:"largeCoin",number:100000,price:25.99,isGem:false,index:3})
		};
		
		
		public static var UpdateSkillCoin:Array =[500,1000,2000,4000,6000,8000,10000,15000,20000,30000]; 
		public static var UpdateSoldierCoin:Array =[1000,5000,10000,20000,50000];
		public static function InputTextFactory(target:TextInput , inputParameters:Object ):void
		{
			var editor:StageTextTextEditor = new StageTextTextEditor;
			editor.color = (inputParameters.color == undefined) ? editor.color:inputParameters.color;
			editor.fontSize = (inputParameters.fontSize == undefined) ? editor.fontSize:inputParameters.fontSize;
			//			editor.editable =  (inputParameters.editable == undefined) ? editor.editable:inputParameters.editable;
			target.maxChars = (inputParameters.maxChars == undefined) ? editor.maxChars:inputParameters.maxChars;
			editor.displayAsPassword = (inputParameters.displayAsPassword == undefined)?editor.displayAsPassword:inputParameters.displayAsPassword;
			target.textEditorFactory = function textEditor():ITextEditor{return editor};
			target.text  = inputParameters.text;
		}
		
		
	}
}