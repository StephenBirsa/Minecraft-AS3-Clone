package {
	/**
	 * Player
	 * @author Stephen Birsa
	 * Date: 15/02/2018
	 */
	public final class Player {
		public var Pos:Vector3;
		public var JumpSpeed:Number = 0;
		public var MaxVelocity:Number = 3;
		public var JumpTimer:Number = 0;
		public var IsTouchingGround:Boolean = false;
		public var AllowForward:Boolean = true;
		public var AllowBackward:Boolean = true;
		public var AllowLeftStrafe:Boolean = true;
		public var AllowRightStrafe:Boolean = true;
		public var MouseTimer:int = 0;
		public var Slots:Array = ["hand", "hand", "hand", "hand", "hand", "hand", "hand", "hand", "hand"];
		public var SelectedBlock:String = "hand";
		//public var Difficulty:String = "peaceful";
		public var Mode:String = "creative";
		public final function Player(x:Number=0,y:Number=0,z:Number=0) {
			Pos = new Vector3(x, y, z);
		}
		public final function PositionManager(worldSize:Vector3):void {
			if (Pos.Z < 0.6) {
				Pos.Z = 0.6;
			}
			if (Pos.Z > worldSize.X - 0.6) {
				Pos.Z = worldSize.X - 0.6;
			}
			if (Pos.X < 0.6) {
				Pos.X = 0.6;
			}
			if (Pos.X > worldSize.Z - 0.6) {
				Pos.X = worldSize.Z - 0.6;
			}
			if (Pos.Y < 1.5) {
				Pos.Y = 1.5;
			}
		}
	}
}
