package org.borodagames.plamee_test.data 
{
	/**
	 * ...
	 * @author ...
	 */
	public class WorldVO 
	{
		public var id:int;9
		public var gAcc:Number = 10.0;
		public var bgName:String = "";
		public var obstacles:Vector.<int>;
		public var minDistanceBetweenObstacles:Number = 100.0;
		
		public function WorldVO(wid:int, g:Number = 10.0, bg:String = "", obsts:Vector.<int> = null, dist:Number = 100.0)
		{
			id = wid;
			gAcc = g;
			bgName = bg;
			obstacles = obsts;
			minDistanceBetweenObstacles = dist;
		}
	}

}