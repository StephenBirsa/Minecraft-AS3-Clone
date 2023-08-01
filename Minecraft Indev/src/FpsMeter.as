package {
	import flash.utils.getTimer;
	/**
	 * A simple fps code that calculates the frame rate.
	 * @author Stephen Birsa
	 * Date: 2/07/2017
	 */
	public final class FpsMeter {
		/*
		 * Usage:
		 * FpsMeter.getFPS();
		 * trace(FpsMeter.fps);
		 * for accurate usage, use inside an enterFrame event
		 * */
		private static var _framecount:int = 0;
		private static var _fps:String = "";
		public final function FpsMeter();
		/**
		 * Calculates the frame rate.
		 * @return The frame rate calculated.
		 */
		static public function getFPS():void {
			_framecount++;
			_fps = round(1000 * _framecount / getTimer()) + " fps";
		}
		static public function get fps():String {
			return _fps;
		}
		static private function round(val:uint):uint {
			return val << 0; //faster instead of Math.round(val);
		}
	}
}