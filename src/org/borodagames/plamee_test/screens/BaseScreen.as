package org.borodagames.plamee_test.screens 
{
	import org.borodagames.plamee_test.Main;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Afanasiev Mikhail
	 */
	public class BaseScreen extends Sprite 
	{
		
		public function BaseScreen() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//эта магия ниже - чтобы отцентровать экраны для адаптивности с обрезанием "ушей" по вертикали или
			//горизонтали, в зависимости от пропорций экрана
			this.x = -(Main.STAGE_WIDTH * Main.SCALE_FACTOR - Main.FULL_STAGE_WIDTH) / Main.SCALE_FACTOR / 2;
			this.y = -(Main.STAGE_HEIGHT * Main.SCALE_FACTOR - Main.FULL_STAGE_HEIGHT) / Main.SCALE_FACTOR / 2;
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initialize();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function initialize():void
		{
			
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			shutdown();
		}
		
		protected function shutdown():void
		{
			
		}
	}

}