package org.borodagames.plamee_test.data 
{
	import org.borodagames.plamee_test.display.Obstacle;
	/**
	 * ...
	 * @author ...
	 */
	public class WorldsConfig 
	{
		private static const DATA:Vector.<WorldVO> = new <WorldVO>[
																	new WorldVO(0, 1000, "WorldBg0", new <int>[Obstacle.TYPE_0, Obstacle.TYPE_1],  400),
																	new WorldVO(1, 1350, "WorldBg1", new <int>[Obstacle.TYPE_2, Obstacle.TYPE_3], 270)
																];
																
		public static function getWorldByNum(num:int):WorldVO
		{
			if (num < 0 || num >= DATA.length)
				return null;
			//предполагается, что ид мира и его индекс в массиве конфига совпадают.
			return DATA[num];
		}
		
	}

}