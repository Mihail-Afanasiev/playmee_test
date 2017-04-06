package org.borodagames.plamee_test.display
{
    import flash.geom.Rectangle;


    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class Touchable extends Sprite
    {
        private static const MAX_DRAG_DIST:Number = 50;
		public static const TOUCH_DOWN:String = "touchDown";
		public static const TOUCH_UP:String = "touchUp";

        private var _scaleWhenDown:Boolean;
        private var _isDown:Boolean;

        public function Touchable(scaleWhenDown:Boolean)
        {
            _scaleWhenDown = scaleWhenDown;

            addEventListener(TouchEvent.TOUCH, touchHandler);
        }

        private function touchHandler(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this);
            if (touch == null) return;

            if (touch.phase == TouchPhase.BEGAN && !_isDown)
            {
                if (_scaleWhenDown)
                    scaleX = scaleY = 0.9;
                _isDown = true;
				dispatchEvent(new Event(TOUCH_DOWN));
            }
            else if (touch.phase == TouchPhase.MOVED && _isDown)
            {
                // reset button when user dragged too far away after pushing
                var buttonRect:Rectangle = getBounds(stage);
                if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
                        touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                        touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
                        touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
                {
                    resetContents();
                }
            }
            else if (touch.phase == TouchPhase.ENDED && _isDown)
            {
                resetContents();
                dispatchEventWith(Event.TRIGGERED, bubbled, dispatchedData);
            }
        }

        protected function get bubbled():Boolean
        {
            return false;
        }


        protected function get dispatchedData():Object
        {
            return null;
        }

        protected function resetContents():void
        {
            _isDown = false;
            if (_scaleWhenDown)
                scaleX = scaleY = 1.0;
			dispatchEvent(new Event(TOUCH_UP));
        }
		
		override public function dispose():void 
		{
			super.dispose();
			removeEventListener(TouchEvent.TOUCH, touchHandler);
		}
    }
}
