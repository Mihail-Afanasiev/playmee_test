package org.borodagames.plamee_test.managers
{
	import com.xtdstudios.DMT.DMTBasic;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import starling.events.Event;



    public class ResourceManager
    {		
		private static const USE_DMT_CACHE:Boolean = true;
		
		/*[Embed(source="../../../../../assets/fonts/VagWorld.OTF", fontName="VAG World", mimeType="application/x-font", embedAsCFF="false")]
        private static const COMPACT:Class;
		public static var HUD_FONT:String = "VAG World";*/
		
        private static var _instance:ResourceManager;
		private var _assetsLoadedHandler:Function;
		private var _dmtBasic:DMTBasic;

        public function ResourceManager()
        {
            if (_instance != null)
                throw new Error("You Can Only Have One " + this);
			
            _instance = this;
        }

        public static function get instance():ResourceManager
        {
            if (_instance == null)
                _instance = new ResourceManager();

            return _instance;
        }

        public function initialize(callback:Function):void
        {
			_assetsLoadedHandler = callback;
			_dmtBasic = new DMTBasic("PLAMEE_GFX", USE_DMT_CACHE, "0");
			_dmtBasic.addEventListener(flash.events.Event.COMPLETE, onDMTComplete);
			_dmtBasic.addEventListener(ProgressEvent.PROGRESS, onDMTProgress);
			if (_dmtBasic.cacheExist())
				_dmtBasic.process();
			else
				addItemToRaster();
        }
		
		private function onDMTProgress(e:ProgressEvent):void
		{
			if (_assetsLoadedHandler != null)
			{
				if (e.bytesTotal == e.bytesLoaded)
				{
					_assetsLoadedHandler(0.99);
					_dmtBasic.removeEventListener(ProgressEvent.PROGRESS, onDMTProgress);
				}
				else
					_assetsLoadedHandler(e.bytesLoaded / e.bytesTotal);
			}
		}
		
		private function onDMTComplete(e:flash.events.Event):void
		{
			_dmtBasic.removeEventListener(flash.events.Event.COMPLETE, onDMTComplete);
			_dmtBasic.removeEventListener(ProgressEvent.PROGRESS, onDMTProgress);
			if (_assetsLoadedHandler != null)
				_assetsLoadedHandler(1);
		}
		
		private function addItemToRaster():void
		{
			var allGfxClasses:Array = [ "org.borodagames.plamee_test.gfx.Hero0",
										"org.borodagames.plamee_test.gfx.Hero1",
										"org.borodagames.plamee_test.gfx.Hero2",
										"org.borodagames.plamee_test.gfx.MenuScreen",
										"org.borodagames.plamee_test.gfx.WorldBg0",
										"org.borodagames.plamee_test.gfx.WorldBg1",
										"org.borodagames.plamee_test.gfx.Obstacle0",
										"org.borodagames.plamee_test.gfx.Obstacle1",
										"org.borodagames.plamee_test.gfx.Obstacle2",
										"org.borodagames.plamee_test.gfx.Obstacle3"];
			var DO:DisplayObject;		
			for (var i:int = 0; i < allGfxClasses.length; i++)
			{
				var LevelClass:Class = getDefinitionByName(allGfxClasses[i]) as Class;
				DO = new LevelClass() as DisplayObject;
				DO.name = allGfxClasses[i].substr(allGfxClasses[i].lastIndexOf(".") + 1);
				_dmtBasic.addItemToRaster(DO);
			}
			
			_dmtBasic.process();
		}
		
		public function getGraphicsByName(nm:String):*
		{
			return _dmtBasic.getAssetByUniqueAlias(nm);
		}
    }
}