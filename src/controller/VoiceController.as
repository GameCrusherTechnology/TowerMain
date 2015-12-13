package controller
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import gameconfig.Configrations;
	

	public class VoiceController
	{
		private static var _controller:VoiceController;
		private var DATA_NAME :String = "VoiceInfo";
		public static var SOUND_DISABLE:Boolean = false;
		public static var MUSIC_DISABLE:Boolean = false;
		
		public static const BUTTONCLICK:String = "click";
		public static const FUNCTION:String = "function";
		public static const LEVELUP:String = "LevelUp";
		public static const LOSE:String = "lose";
		public static const NPC_TIPS:String = "npc_tips";
		public static const BACK_BATTLE:String = "battle_0";
		public static const BACK_BATTLE2:String = "battle_2";
		public static const BACK_WORLD3:String = "map_3";
		
		private var soundVec:Object = {};
		private function getSource(name:String):Sound
		{
			var s:Sound = soundVec[name];
			if(s){
				return s;
			}else{
				loadSoundSource(name);
				return null;
			}
		}
		
		private var loadSound:Sound;
		private function loadSoundSource(name:String):void
		{
			var loadSound:Sound = new Sound();
			loadSound.addEventListener(Event.COMPLETE,function(e:Event):void{
				trace("loaded sound : "+ name);
				var tar:Sound = e.currentTarget as Sound;
				if(tar){
					soundVec[name] = tar;
					if(name == BACK_WORLD3 || name == BACK_BATTLE || name == BACK_BATTLE2){
						playRack(name);
					}
				}
			});
			loadSound.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void{
				trace(e);
			});
			loadSound.load(new URLRequest("sound/"+name+".mp3"));
			
		}
		
		private var backChannel:SoundChannel;
		private var soundChannel:SoundChannel;
		
		public static function get instance():VoiceController
		{
			if(!_controller){
				_controller = new VoiceController();
			}
			return _controller;
		}
		public function VoiceController()
		{
			var rootFile:File = File.userDirectory;
			file =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__v.txt");
			fileStream=new FileStream();
		}
		
		private var file:File ;
		private var fileStream:FileStream;
		public function init():void
		{
			if(file.exists){
				fileStream.open(file,FileMode.READ);
				var readfilebyte:ByteArray=new ByteArray();
				fileStream.readBytes(readfilebyte);
				voiceInfo = readfilebyte.readObject();
				fileStream.close();
			}
			
			SOUND_DISABLE = voiceInfo["sound"];
			MUSIC_DISABLE = voiceInfo["music"];
			playRack();
		}
		private var voiceInfo :Object = {music:true,sound:true};
		private function saveSoundInfo():void
		{
			
			var filebyte:ByteArray=new ByteArray();
			filebyte.writeObject(voiceInfo);
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeBytes(filebyte,0,filebyte.length);
			fileStream.close();
			
		}
		
		public function setMusic(bool:Boolean):void
		{
			MUSIC_DISABLE = bool;
			if(MUSIC_DISABLE){
				playRack();
			}else{
				closeRack();
			}
			voiceInfo["music"] = MUSIC_DISABLE;
			saveSoundInfo();
		}
		
		private var musicVoice:Number = 0.5;
		public function setMusicVoice(v:Number):void
		{
			musicVoice = v;
			if(backChannel){
				backChannel.soundTransform = new SoundTransform(musicVoice);
			}
		}
		public function setSound(bool:Boolean):void
		{
			SOUND_DISABLE = bool;
			voiceInfo["sound"] = SOUND_DISABLE;
			saveSoundInfo();
		}
		
		
		private var m_cSoundRack:Sound;
		private var curRackName:String ;
		public function playRack(name:String = BACK_WORLD3):void{
			if(MUSIC_DISABLE){
				if(curRackName != name){
					m_cSoundRack = getSource(name);
					
					if(backChannel){
						closeRack();
					}
					if(m_cSoundRack){
//						backChannel = m_cSoundRack.play();
//						backChannel.soundTransform = new SoundTransform(musicVoice);
//						backChannel.addEventListener(Event.SOUND_COMPLETE,onBackComplete,false,0,true);
//						curRackName = name;
					}
				}
			}
		}
		private function closeRack():void
		{
			if(backChannel){
				backChannel.stop();
				backChannel.removeEventListener(Event.SOUND_COMPLETE,onBackComplete);
			}
		}
		private function onBackComplete(e:Event):void
		{
			closeRack();
			if(m_cSoundRack){
				backChannel = m_cSoundRack.play();
				backChannel.soundTransform = new SoundTransform(musicVoice);
				backChannel.addEventListener(Event.SOUND_COMPLETE,onBackComplete,false,0,true);
			}
		}
		
		public function playSound(type:String):void
		{
			if(SOUND_DISABLE){
				var sound:Sound = getSource(type);
				if(sound){
					var soundChannel:SoundChannel = sound.play();
					if(soundChannel){
						soundChannel.soundTransform = new SoundTransform(0.2);
					}
				}
			}
		}
		
	}
}