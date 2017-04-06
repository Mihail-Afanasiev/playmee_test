package org.borodagames.plamee_test 
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import org.borodagames.plamee_test.managers.ResourceManager;
	import org.borodagames.plamee_test.managers.ScreenManager;
	import starling.core.Starling;
	import org.borodagames.plamee_test.gfx.BorodaLogo;
	import starling.utils.SystemUtil;
	import starling.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Afanasiev Mikhail
	 */
	public class Main extends flash.display.Sprite 
	{
		public static const STAGE_WIDTH:int = 1280;
		public static const STAGE_HEIGHT:int = 720;
		public static var SCALE_FACTOR:Number = 1;
		public static var FULL_STAGE_WIDTH:int = 1280;
		public static var FULL_STAGE_HEIGHT:int = 720;
		
		//ниже - константа, сколько событий должны сойтись для старта игры
		//обычно у меня это - завершение загрузки ресурсов, таймер сплеш скрина, инициализация менеджера локальных данных,
		//инициализация серверменеджера и т.п. В данном случае - только показать сплеш и дождаться загрузки ресурсов, отсюда 2.
		private static const TOTAL_STEPS_TO_START:int = 2;
		
		private var _stepsToStart:int = 0;
		
		private var _starling:Starling;
		private var _startTimer:Timer;
		
		public function Main() 
		{
			super();
			if (stage != null)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initialize();
		}
		
		private function initialize():void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			Starling.multitouchEnabled = false;
			
			 var viewPort:Rectangle;
			if (SystemUtil.isDesktop)
			{
				//Следующие три строчки - для имитации на десктопе различных разрешений и 
				//проверки на адекватность адаптивности с помощью FULL_STAGE_...
				SCALE_FACTOR = FULL_STAGE_WIDTH / STAGE_WIDTH;
				if (SCALE_FACTOR * STAGE_HEIGHT < FULL_STAGE_HEIGHT)
					SCALE_FACTOR = FULL_STAGE_HEIGHT / STAGE_HEIGHT;
				viewPort = new Rectangle(0, 0, SCALE_FACTOR * STAGE_WIDTH, SCALE_FACTOR * STAGE_HEIGHT);
			}
			else
			{
				SCALE_FACTOR = stage.fullScreenWidth / STAGE_WIDTH;
				if (SCALE_FACTOR * STAGE_HEIGHT < stage.fullScreenHeight)
					SCALE_FACTOR = stage.fullScreenHeight / STAGE_HEIGHT;
				FULL_STAGE_WIDTH = stage.fullScreenWidth;
				FULL_STAGE_HEIGHT = stage.fullScreenHeight;
				viewPort = new Rectangle(0, 0, SCALE_FACTOR * STAGE_WIDTH, SCALE_FACTOR * STAGE_HEIGHT);
			}
			
			var logoBg:flash.display.Sprite = new flash.display.Sprite();
			logoBg.graphics.beginFill(0xffffff, 1);
			logoBg.graphics.drawRect(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			logoBg.graphics.endFill();
			addChild(logoBg);
			
			var logo:BorodaLogo = new BorodaLogo();
			logo.scaleX = logo.scaleY = SCALE_FACTOR;
			logo.x = stage.fullScreenWidth / 2;
			logo.y = stage.fullScreenHeight / 2;
			addChild(logo);
			
			_starling = new Starling(starling.display.Sprite, this.stage, viewPort);
			_starling.enableErrorChecking = false;
			_starling.skipUnchangedFrames = true;
			_starling.addEventListener("rootCreated", rootCreatedHandler);
			_starling.start();
			_starling.stage.stageWidth = STAGE_WIDTH;
			_starling.stage.stageHeight = STAGE_HEIGHT;
		}
		
		private function rootCreatedHandler(event:*):void
        {
			_startTimer = new Timer(1000, 1);
			_startTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onStartTimerComplete);
			_startTimer.start();
            _starling.removeEventListener("rootCreated", rootCreatedHandler);
			ResourceManager.instance.initialize(loadingHandler);
        }
		
		private function loadingHandler(ratio:Number):void
        {
            if (ratio == 1)
				increaseStepsToStartAndCheckReady();
        }
		
		private function onStartTimerComplete(e:TimerEvent):void
		{
			_startTimer.stop();
			_startTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onStartTimerComplete);
			increaseStepsToStartAndCheckReady();
		}
		
		private function increaseStepsToStartAndCheckReady():void
		{
			_stepsToStart++;
			if (_stepsToStart >= TOTAL_STEPS_TO_START)
				startApp();
		}
		
		private function startApp():void
        {
			ScreenManager.instance.initialize(_starling.root);
			ScreenManager.instance.gotoMenu();
			while(numChildren)
				removeChildAt(0);
			_starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.BACK)
			{
				e.preventDefault();
				NativeApplication.nativeApplication.dispatchEvent(new Event(Event.EXITING));
				NativeApplication.nativeApplication.exit(0);
			}
		}
	}

}