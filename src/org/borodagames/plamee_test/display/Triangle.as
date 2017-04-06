package org.borodagames.plamee_test.display 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Triangle extends Hero 
	{
		
		public function Triangle() 
		{
			super(Hero.HERO_TRIANGLE);
		}
		
		/*
		 * я понятия не имею, что это за "квадратичное увеличение скорости до максимума"
		 * но учитывая, что равноускоренное движение - это V(t) = V(0) + at, то есть зависимость V(t)
		 * то квадратичная зависимость - это V(t) = V(0) + at + bt^2. Я не знаю, где в природе встречается такая зависимость
		 * по крайней мере, ни в продвинутом физтех лицее, ни в универе о таких законах я не слыхал
		 * но раз вы захотели, то ок, будет меняться квадратично от времению. Коэффициент a я принимаю равным нулю
		 * коэффициент b принимаю _acc
		 * при этом я не буду заморачиваться и изобретать формулу зависимости пройденного пути от времени
		 * и оставлю ее S(t) = S(0) + V(0)t + at^2 / 2
		 * т.е. как для равноускоренного движения.
		*/
		override protected function makeMoveXThings(timeDelta:Number):Number
		{
			var deltaX:Number = _vXCurrent * timeDelta + _accX * timeDelta * timeDelta / 2;
			
			if (_vXCurrent < _vXMax * 0.5)
				_vXCurrent = _vXCurrent + _accX * timeDelta;
			else
				_vXCurrent = _vXCurrent + _accX * timeDelta * timeDelta;
				
			if (_vXCurrent >= _vXMax)
				_vXCurrent = _vXMax;
				
			return deltaX;
		}
	}

}