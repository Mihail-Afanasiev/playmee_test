package org.borodagames.utils 
{
	import org.borodagames.plamee_test.display.Touchable;
	import starling.display.Sprite;
	import starling.display.Stage;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.rendering.Painter;
	import starling.rendering.RenderState;
	/**
	 * ...
	 * @author Mikhail Afanasiev
	 */
	public class DisplayUtils 
	{
		
		public function DisplayUtils() 
		{
			
		}
		
		public static function wrapDOinTouchable(starlingDO:DisplayObject, changeSize:Boolean = true):Touchable
		{
			var res:Touchable = new Touchable(changeSize);
			res.x = starlingDO.x + starlingDO.width / 2;
			res.y = starlingDO.y + starlingDO.height / 2;
			starlingDO.x = -starlingDO.width / 2;
			starlingDO.y = -starlingDO.height / 2;
			
			if (starlingDO.parent != null)
				starlingDO.parent.addChild(res);
			
			res.addChild(starlingDO);
			return res;
		}
		
		public static function wrapDOinSprite(starlingDO:DisplayObject):Sprite
		{
			var spr:Sprite = new Sprite();
			spr.x = starlingDO.x;
			spr.y = starlingDO.y;
			if (starlingDO.parent != null)
				starlingDO.parent.addChild(spr);
			spr.addChild(starlingDO);
			starlingDO.x = 0;
			starlingDO.y = 0;
			return spr;
		}
		
		//не юзать это никогда, тормозная до жути адской.
		public static function drawDOtoBMD(displayObject:DisplayObject):BitmapData
		{
			var stage:Stage = Starling.current.stage;
			var painter:Painter = Starling.current.painter;
			var scaleFactor:Number = Starling.contentScaleFactor;
			
			var result:BitmapData = new BitmapData(stage.stageWidth * scaleFactor, stage.stageHeight * scaleFactor, true);
			
			painter.pushState();
			painter.state.renderTarget = null;
			painter.state.setProjectionMatrix(0, 0, stage.stageWidth, stage.stageHeight, stage.stageWidth, stage.stageHeight, stage.cameraPosition);
			painter.clear();
			displayObject.setRequiresRedraw();
			displayObject.render(painter);
			painter.finishMeshBatch();
			painter.context.drawToBitmapData(result);
			painter.context.present();
			painter.popState();
		 
			return result;
		}
	}

}