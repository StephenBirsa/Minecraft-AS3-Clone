package {
	import flash.geom.ColorTransform;
	/**
	 * Environment
	 * @author Stephen Birsa
	 * Date: 12/02/2018
	 */
	public final class Environment {
		public function Environment();
		public var IsItDawn:Boolean = false;
		public var mapShadow:Number = 1;
		public var allowShadowChange:Boolean = true;
		public var blockShadow:int = 255;
		public var sunPoint:Vector3 = new Vector3();
		public var moonPoint:Vector3 = new Vector3();
		public var sunReach:int = 32;
		public var moonReach:int = 30;
		public var mapSunShadow:Number = 1;
		public var mapTransform:ColorTransform = new ColorTransform(mapShadow, mapShadow, mapShadow);
		public final function StateOfDay(shadow:Number):String {
			if (shadow >= 0.7) {
				return "Daytime";
			}
			if (shadow >= 0.4) {
				return IsItDawn ? "Sunrise/Dawn" : "Sunset/Dusk";
			}
			if (shadow >= 0.3 && IsItDawn == false) {
				return "Sunset/Dusk";
			}
			return "Nighttime";
		}
		public final function TimeOfDayHour(daytime:Number):int {
			return Math.round(((daytime * 12) + 14) % 24);
		}
	}
}
