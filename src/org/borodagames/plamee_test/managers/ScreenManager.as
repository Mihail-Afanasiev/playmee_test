package org.borodagames.plamee_test.managers
{
	import org.borodagames.plamee_test.data.GameDataVO;
	import org.borodagames.plamee_test.screens.BaseScreen;
	import org.borodagames.plamee_test.screens.GameScreen;
	import org.borodagames.plamee_test.screens.MenuScreen;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Mihail Afanasiev
	 */
	public class ScreenManager 
	{
		private static var _instance:ScreenManager;
		
		private var _root:DisplayObject;
		private var _curScreen:BaseScreen;
		
		public function ScreenManager() 
		{
			if (_instance != null)
				throw new Error("ScreenManager is singletone class! Use instance instead");
		}
		
		public static function get instance():ScreenManager
		{
			if (_instance == null)
				_instance = new ScreenManager();
			return _instance;
		}
		
		public function initialize(root:DisplayObject):void
		{
			_root = root;
		}
		
		public function get curScreen():BaseScreen
		{
			return _curScreen;
		}
		
		public function gotoMenu(hId:int = 0, wId:int = 0):void
		{
			clearCurrent();
			_curScreen = new MenuScreen(hId, wId);
			(_root as Sprite).addChild(_curScreen);
		}
		
		public function gotoGame(gd:GameDataVO):void
		{
			clearCurrent();
			_curScreen = new GameScreen(gd);
			(_root as Sprite).addChild(_curScreen);
		}
		
		private function clearCurrent():void
		{
			if (_curScreen != null)
			{
				if (_curScreen.parent != null)
					_curScreen.removeFromParent();
				_curScreen.dispose();
			}
		}
	}

}