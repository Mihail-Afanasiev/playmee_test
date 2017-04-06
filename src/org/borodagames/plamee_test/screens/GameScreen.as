package org.borodagames.plamee_test.screens 
{
	import flash.geom.Point;
	import org.borodagames.plamee_test.Main;
	import org.borodagames.plamee_test.data.GameDataVO;
	import org.borodagames.plamee_test.data.WorldVO;
	import org.borodagames.plamee_test.data.WorldsConfig;
	import org.borodagames.plamee_test.display.Hero;
	import org.borodagames.plamee_test.display.Obstacle;
	import org.borodagames.plamee_test.display.Touchable;
	import org.borodagames.plamee_test.managers.ResourceManager;
	import org.borodagames.plamee_test.managers.ScreenManager;
	import org.borodagames.utils.HerosFactory;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	/**
	 * ...
	 * @author Afanasiev Mikhail
	 */
	public class GameScreen extends BaseScreen 
	{
		private static const FLOOR_Y:int = 620;
		
		protected var _bg:Touchable;
		protected var _hero:Hero;
		protected var _obstaclesPool:Vector.<Obstacle>; //чтоб постоянно не создавать и не удалять объекты, будем использованные помещать в пул и брать оттуда, когда нужно
		protected var _obstaclesActive:Vector.<Obstacle>;
		
		//после того, как пройдено мин расстояние из настроек мира, чтоб можно было генерить новое препятствие
		//будем по рандому пытаться его создать, если рандом сыграл против появления препятствия, то даем какое-то
		//расстояние еще пройти, увеличиваем вероятность появления после этого и после прохождения этого расстояния
		//пробуем опять создать по рандому.
		protected var _skippingDistance:Number = 0.0;
		protected var _obstacleProbability:Number = 0.4;
		protected var _lastCreatedDistanceTo:Number = 0;
		
		protected var _cidWorld:WorldVO;
		
		protected var _gameOver:Boolean = false;
		
		public function GameScreen(vo:GameDataVO) 
		{
			super();
			
			_cidWorld = WorldsConfig.getWorldByNum(vo.worldId);
			
			//чтоб первое препятствие сразу можно было создать
			_lastCreatedDistanceTo = _cidWorld.minDistanceBetweenObstacles;
			
			_obstaclesPool = new Vector.<Obstacle>();
			_obstaclesActive = new Vector.<Obstacle>();
			
			_bg = new Touchable(false);
			_bg.addChild(ResourceManager.instance.getGraphicsByName(_cidWorld.bgName));
			addChild(_bg);
			
			_hero = HerosFactory.getHeroById(vo.heroId);
			_hero.x = 250;
			_hero.y = 520;
			addChild(_hero);
			_hero.floorY = FLOOR_Y - _hero.height;
			_hero.accY = _cidWorld.gAcc;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			addEventListener(EnterFrameEvent.ENTER_FRAME, keepScrolling);
			_bg.addEventListener(Touchable.TOUCH_DOWN, onTap);
		}
		
		override protected function shutdown():void 
		{
			super.shutdown();
			removeEventListener(EnterFrameEvent.ENTER_FRAME, keepScrolling);
			_bg.removeEventListener(Touchable.TOUCH_DOWN, onTap);
		}
		
		//главный цикл игры. происходит все движение, создание и удаление препятствий и т.п.
		protected function keepScrolling(e:EnterFrameEvent):void
		{
			var deltaX:Number = _hero.move(e.passedTime);
			
			//10 - мэджтк намбер, просто запас, чтоб точно не вылезти
			//за размеры картинки бэка
			if (_bg.x + _bg.width - 10 > Main.STAGE_WIDTH)
			{
				_bg.x -= deltaX / 15;
				if (_bg.x + _bg.width - 10 <= Main.STAGE_WIDTH)
					_bg.x = Main.STAGE_WIDTH - _bg.width + 10;
			}	
			
			manageObstacles(deltaX);
			
			checkCollisions();
		}
		
		protected function onTap(e:Event):void
		{
			if (_gameOver)
				ScreenManager.instance.gotoMenu(_hero.id, _cidWorld.id);
			else
				_hero.jump();
		}
		
		//--------------utility methods----------------
		
		protected function manageObstacles(deltaX:Number):void
		{
			//двигаем препятствия
			for (var i:int = 0; i < _obstaclesActive.length; i++)
			{
				_obstaclesActive[i].x -= deltaX;
				//если препятствие ушло за левый край экрана, то пихаем его в пул для дальнейшего использования
				// а из активных препятствий - исключаем
				if (_obstaclesActive[i].x < -150)
				{
					_obstaclesActive[i].removeFromParent();
					_obstaclesPool.push(_obstaclesActive.splice(i, 1)[0]);
					i--;
				}
			}
			
			if (_lastCreatedDistanceTo >= _cidWorld.minDistanceBetweenObstacles)
			{
				//немного рандомизируем расстояние появления следующего препятствия
				if (_skippingDistance <= 0)
				{
					if (Math.random() < _obstacleProbability)
					{
						var obstType:int = _cidWorld.obstacles[Math.floor(_cidWorld.obstacles.length * Math.random())];
						var obst:Obstacle = getObstacleFromPool(obstType);
						if (obst == null)
							obst = new Obstacle(obstType);
						
						obst.y = FLOOR_Y - obst.height;
						obst.x = Main.STAGE_WIDTH;
						addChild(obst);
						_obstaclesActive.push(obst);
						_lastCreatedDistanceTo = 0;
						_obstacleProbability = 0.4;
					}
					else
					{
						_obstacleProbability += 0.1;
						_skippingDistance = 50.0;
					}
				}
				else
					_skippingDistance -= deltaX;
			}
			else 
				_lastCreatedDistanceTo += deltaX;
		}
		
		protected function checkCollisions():void
		{
			for (var i:int = 0; i < _obstaclesActive.length; i++)
			{
				//сначала проверяем пересечения прямоугольников героя и препятствия
				//и только, если они грубо пересекаются, начинает искать pixelperfect коллизию
				
				if (_obstaclesActive[i].x -_hero.x <= _hero.width &&
				    _hero.x <= _obstaclesActive[i].x + _obstaclesActive[i].width &&
					_obstaclesActive[i].y - _hero.y <= _hero.height)
				{
					//todo pixelperfect collision check
					if (_hero.bmp.bitmapData.hitTest(new Point(_hero.x, _hero.y), 255, _obstaclesActive[i].bmp.bitmapData, new Point(_obstaclesActive[i].x, _obstaclesActive[i].y), 255))
					{
						removeEventListener(EnterFrameEvent.ENTER_FRAME, keepScrolling);
						_gameOver = true;
						var tf:TextField = new TextField(Main.STAGE_WIDTH, 100, "КОНЕЦ", new TextFormat ("Verdana", 70, 0xff0000));
						tf.x = 0;
						tf.y = 300;
						tf.touchable = false;
						addChild(tf);
						return;
					}
				}
			}
		}
		
		protected function getObstacleFromPool(type:int):Obstacle
		{
			if (_obstaclesPool.length > 0)
			{
				_obstaclesPool[0].type = type;
				return _obstaclesPool.shift();
			}
			return null;
		}
	}

}