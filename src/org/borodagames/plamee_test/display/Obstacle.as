package org.borodagames.plamee_test.display
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import org.borodagames.plamee_test.managers.ResourceManager;
	import org.borodagames.utils.DisplayUtils;
	import flash.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Obstacle extends Sprite
	{
		public static const TYPE_0:int = 0;
		public static const TYPE_1:int = 1;
		public static const TYPE_2:int = 2;
		public static const TYPE_3:int = 3;
		
		protected var _type:int = 0;
		protected var _view:Image;
		protected var _bmp:Bitmap;
		
		public function Obstacle(otype:int)
		{
			 type = otype;
			
			touchable = false;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(v:int):void
		{
			if (_view != null)
			{
				_view.removeFromParent();
				_view.dispose();
				_view = null;
			}
			_type = v;
			_view = ResourceManager.instance.getGraphicsByName("Obstacle" + _type);
			addChild(_view);
			
			if (_bmp != null)
			{
				_bmp.bitmapData.dispose();
				_bmp = null;
			}
			
			//это танцы с бубном для получения pixelperfect коллизий
			var clazz:Class = getDefinitionByName("org.borodagames.plamee_test.gfx.Obstacle" + _type) as Class;
			var flashDO:DisplayObject = new clazz();
			var bmd:BitmapData = new BitmapData(flashDO.width, flashDO.height, true, 0);
			bmd.draw(flashDO);
			_bmp = new Bitmap(bmd);
		}
		
		public function get bmp():Bitmap 
		{
			return _bmp;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			_bmp.bitmapData.dispose();
			_bmp = null;
		}
	}

}