package org.borodagames.plamee_test.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.borodagames.plamee_test.managers.ResourceManager;
	import org.borodagames.utils.DisplayUtils;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Hero extends Sprite 
	{
		public static const HERO_SQUARE:int = 0;
		public static const HERO_TRIANGLE:int = 1;
		public static const HERO_CIRCLE:int = 2;
		
		protected var _view:Image;
		protected var _bmp:Bitmap;
		
		protected var _id:int;
		
		protected var _jumpStartVY:Number = 700.0;
		protected var _vYCurrent:Number = 0.0; // px/s - текущая вертикальная скорость
		protected var _accY:Number = -10.0; // px/s^2 - ускорение свободного падения - то самое g из задания
		protected var _floorY:Number = 0; // нижнее значение y, ниже которого герой не свалится
		protected var _isJumping:Boolean = false;
		
		protected var _vXCurrent:Number = 200.0; //px / s, текущая горизонтальная скорость
		protected var _vXMax:Number = 900.0; //px / s, максимальная горизонтальная скорость
		protected var _accX:Number = 3.0; //px / s^2, значение линейного ускорения по горизонтали
		
		protected var _jumpFilter:ColorMatrixFilter; // для подсветки прыжка
		
		public function Hero(id:int) 
		{
			_id = id;
			
			_view =  ResourceManager.instance.getGraphicsByName("Hero" + _id) as Image;
			addChild(_view);
			
			//это танцы с бубном для получения pixelperfect коллизий
			var clazz:Class = getDefinitionByName("org.borodagames.plamee_test.gfx.Hero" + _id) as Class;
			var flashDO:DisplayObject = new clazz();
			var bmd:BitmapData = new BitmapData(flashDO.width, flashDO.height, true, 0);
			bmd.draw(flashDO);
			_bmp = new Bitmap(bmd);
			
			_jumpFilter = new ColorMatrixFilter();
			_jumpFilter.adjustBrightness(0.5);
			
			touchable = false;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			_bmp.bitmapData.dispose();
			_bmp = null;
		}
		
		public function set floorY(ny:Number):void
		{
			_floorY = ny;
		}
		
		public function set accY(nacc:Number):void
		{
			//в конфиге пишем по-человечески, ускорение свободного падения в положительной записи
			//но при вычислениях оно будет отрицательным, поэтому сразу его подготавливаем
			_accY = -nacc;
		}
		
		public function get bmp():Bitmap 
		{
			return _bmp;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		//эта функция двигает героя по вертикали (если он в прыжке), а также вычисляет смещение по горизонтали
		//и возвращает в GameScreen,чтоб скроллить бэк
		public function move(timeDelta:Number):Number
		{
			if (_isJumping)
			{
				//работаю с скоростью по Y, как в декартовой системе координат, где Y растет вверх
				//дальше просто домножу на -1
				var deltaY:Number = _vYCurrent * timeDelta + _accY * timeDelta * timeDelta / 2;
				_vYCurrent = _vYCurrent + _accY * timeDelta;
				
				this.y += -deltaY;
				
				//если летим вниз и пересекли пол, завершаем прыжок
				if (_vYCurrent < 0 && this.y >= _floorY)
				{
					_isJumping = false;
					_vYCurrent = 0;
					this.y = _floorY;
					resetHighlight();
				}
			}
			
			return makeMoveXThings(timeDelta);
		}
		
		//вынес в отдельный метод, чтобы его переопределить в наследнике, а не move целиком
		protected function makeMoveXThings(timeDelta:Number):Number
		{
			var deltaX:Number = _vXCurrent * timeDelta + _accX * timeDelta * timeDelta / 2;
			_vXCurrent = _vXCurrent + _accX * timeDelta;
			if (_vXCurrent >= _vXMax)
				_vXCurrent = _vXMax;
			return deltaX;
		}
		
		public function jump():void
		{
			if (_isJumping)
				return;
			_isJumping = true;
			_vYCurrent = _jumpStartVY;
			highlightJump();
		}
		
		//вынес эти два метода отдельно, чтоб можно было не только фильтрами менять, но и просто текстуры заменять
		//например
		protected function highlightJump():void
		{
			this.filter = _jumpFilter;
		}
		
		protected function resetHighlight():void
		{
			this.filter = null;
		}
	}

}