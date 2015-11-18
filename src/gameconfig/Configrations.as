package gameconfig
{
	import flash.geom.Rectangle;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.textures.Scale9Textures;
	
	import starling.filters.ColorMatrixFilter;
	
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
		
		private static const vipMaxLevel:int  = 9;
		public static function expToVip(point:Number):int{
			return Math.min(vipMaxLevel,  (Math.sqrt(point/10)));
		}
		public static function vipToExp(grade:int):int{
			return int(Math.pow(grade,2)*10);
		}
		
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
		
		
		public static var MapClsObject :Object = {
			"map00":BattleMap00Cls,
			"map01":BattleMap01Cls,
			"map02":BattleMap02Cls,
			"map03":BattleMap03Cls,
			"map04":BattleMap04Cls,
			"map05":BattleMap05Cls
		};
		
		public static function get  grayscaleFilter():ColorMatrixFilter
		{
			var _grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
			_grayscaleFilter.adjustSaturation(-1);
			return _grayscaleFilter;
		}
		
		
		public static var HeroMaxSkillLength:int = 4;
		public static var HeroMaxSoldierLength:int =4;
		
		public static var ClansData:Array;
		
		
		public static var HeroCost:Array = [
			{"gem":5,"coin":100},
			{"gem":10,"coin":2000},
			{"gem":50,"coin":10000},
			{"gem":100,"coin":50000},
			{"gem":200,"coin":100000}
		];
		
		
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