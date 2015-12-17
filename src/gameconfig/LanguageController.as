package gameconfig
{
	import flash.net.URLLoader;
	
	import starling.textures.Texture;
	
	
	public class LanguageController
	{
		public static const NUMBERFONT_DARKBLUE:String = "Number_DarkBlueBold";
		public static const NUMBERFONT_ORANGE:String = "Number_OrangeBold";
		
		private static var _instance:LanguageController;
		public static function getInstance():LanguageController{
			if(!_instance){
				_instance = new LanguageController;
			}
			return _instance;
		}
		public function LanguageController(){
			
		}
		private var resourcesLoader:URLLoader;
		
		private var dictLanguage:Object = {};
		public function set languageXML(xml:XML):void
		{
			var xmlList:XMLList =  xml.children();
			for each(var subXML1:XML in xmlList)
			{
				var key:String = String(subXML1.@key);
				var value:String = String(subXML1.@value);
				dictLanguage[key]=value;
			}
		}
		
//		public function getString(bundleName:String, resourceName:String,property:String=null,parameters:Array = null):String
//		{
//			var key:String=(property)? (bundleName + "_" + resourceName+"_"+property) : (bundleName + "_" + resourceName);
//			var strTemp:String=dictLanguage[key];
//			if(strTemp)
//			{
//				if(parameters && parameters.length>0)
//				{
//					var index:int=0;
//					for each(var strParams:String in parameters)
//					{
//						var replaceStr:String="{"+String(index)+"}";
//						while(strTemp.indexOf(replaceStr)>-1)
//						{
//							strTemp=strTemp.replace(replaceStr,strParams);
//						}
//						index++;
//					}
//				}
//			}
//			else
//			{
//				if(bundleName=="ranch_ui")
//				{
//					strTemp = dictLanguage["game_"+resourceName];
//				}
//			}
//			if(!strTemp)
//			{
//				return "";
//			}
//			while(strTemp.indexOf("\\n")>-1)
//			{
//				strTemp=strTemp.replace("\\n","\n");
//			}
//			return strTemp;
//		}
		
		public function getString(key:String,parameters:Array = null):String
		{
			var strTemp:String=dictLanguage[key];
			if(!strTemp){
				trace("no language : " + key);
				return key;
			}else{
				if(parameters && parameters.length>0)
				{
					var index:int=0;
					for each(var strParams:String in parameters)
					{
						var replaceStr:String="{"+String(index)+"}";
						while(strTemp.indexOf(replaceStr)>-1)
						{
							strTemp=strTemp.replace(replaceStr,strParams);
						}
						index++;
					}
				}
			}
			return strTemp;
		}
		
		public function getNumberTexture(num:int,fontName:String):Texture
		{
			num = num%10;
			return Game.assets.getTexture(fontName+String(num));
		}
	}
}