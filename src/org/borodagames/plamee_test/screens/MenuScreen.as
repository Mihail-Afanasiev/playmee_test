package org.borodagames.plamee_test.screens
{
	import org.borodagames.plamee_test.data.GameDataVO;
	import org.borodagames.plamee_test.display.Touchable;
	import org.borodagames.plamee_test.managers.ResourceManager;
	import org.borodagames.plamee_test.managers.ScreenManager;
	import org.borodagames.utils.DisplayUtils;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Afanasiev Mikhail
	 */
	public class MenuScreen extends BaseScreen
	{
		private var _view:Sprite;
		
		private var _btnStart:Touchable;
		private var _frameHero:Image;
		private var _frameWorld:Image;
		private var _heroes:Vector.<Touchable>;
		private var _worlds:Vector.<Touchable>;
		
		private var _curHeroId:int = 0;
		private var _curWorldId:int = 0;
		
		public function MenuScreen(hId:int = 0, wId:int = 0)
		{
			//получаем вьюху и распарсиваем нужные визуальные объекты, преобразовываем в тыкабельные и т.п.
			_view = ResourceManager.instance.getGraphicsByName("MenuScreen") as Sprite;
			
			_btnStart = DisplayUtils.wrapDOinTouchable(_view.getChildByName("start"));
			_frameHero = _view.getChildByName("heroesFrame") as Image;
			_frameHero.touchable = false;
			_frameWorld = _view.getChildByName("worldsFrame") as Image;
			_frameWorld.touchable = false;
			
			var i:int;
			_heroes = new Vector.<Touchable>();
			for (i = 0; i < 3; i++)
				_heroes.push(DisplayUtils.wrapDOinTouchable(_view.getChildByName("hero" + i)));
			
			_worlds = new Vector.<Touchable>();
			for (i = 0; i < 2; i++)
				_worlds.push(DisplayUtils.wrapDOinTouchable(_view.getChildByName("world" + i)));
			
			_curHeroId = hId;
			setHeroFrame(_curHeroId);
			_curWorldId = wId;
			setWorldFrame(_curWorldId);
			
			addChild(_view);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var i:int;
			for (i = 0; i < _heroes.length; i++)
				_heroes[i].addEventListener(Event.TRIGGERED, onHeroChoose);
			
			for (i = 0; i < _worlds.length; i++)
				_worlds[i].addEventListener(Event.TRIGGERED, onWorldChoose);
			
			_btnStart.addEventListener(Event.TRIGGERED, onStart);
		}
		
		override public function dispose():void
		{
			super.dispose();
			var i:int;
			for (i = 0; i < _heroes.length; i++)
				_heroes[i].removeEventListener(Event.TRIGGERED, onHeroChoose);
			
			for (i = 0; i < _worlds.length; i++)
				_worlds[i].removeEventListener(Event.TRIGGERED, onWorldChoose);
			
			_btnStart.removeEventListener(Event.TRIGGERED, onStart);
		}
		
		//-------------------gui handlers---------------------
		
		private function onHeroChoose(e:Event):void
		{
			_curHeroId = _heroes.indexOf(e.currentTarget);
			setHeroFrame(_curHeroId);
		}
		
		private function onWorldChoose(e:Event):void
		{
			_curWorldId = _worlds.indexOf(e.currentTarget);
			setWorldFrame(_curWorldId);
		}
		
		private function onStart(e:Event):void
		{
			ScreenManager.instance.gotoGame(new GameDataVO(_curHeroId, _curWorldId));
		}
		
		//-------------------utility methods---------------------
		
		private function setHeroFrame(ind:int):void
		{
			if (ind < 0 || ind >= _heroes.length)
			{
				_frameHero.visible = false;
				return;
			}
			_frameHero.visible = true;
			_frameHero.x = _heroes[ind].x - _heroes[ind].width / 2 - 7;
			_frameHero.y = _heroes[ind].y - _heroes[ind].height / 2 - 7;
		}
		
		private function setWorldFrame(ind:int):void
		{
			if (ind < 0 || ind >= _worlds.length)
			{
				_frameWorld.visible = false;
				return;
			}
			_frameWorld.visible = true;
			_frameWorld.x = _worlds[ind].x - _worlds[ind].width / 2 - 20;
			_frameWorld.y = _worlds[ind].y - _worlds[ind].height / 2 - 20;
		}
	}

}