package org.borodagames.utils 
{
	import org.borodagames.plamee_test.display.Circle;
	import org.borodagames.plamee_test.display.Hero;
	import org.borodagames.plamee_test.display.Square;
	import org.borodagames.plamee_test.display.Triangle;
	/**
	 * ...
	 * @author ...
	 */
	public class HerosFactory 
	{
		public static function getHeroById(id):Hero
		{
			switch(id)
			{
				case Hero.HERO_SQUARE:
					return new Square();
				case Hero.HERO_TRIANGLE:
					return new Triangle();
				case Hero.HERO_CIRCLE:
					return new Circle();
			}
			return null;
		}
	}

}