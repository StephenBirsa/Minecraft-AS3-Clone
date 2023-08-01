package {
	/**
	 * Vector 3D
	 * @author Stephen Birsa
	 * Date: 20/01/2018
	 */
	public final class Vector3 {
		public var X:Number;
		public var Y:Number;
		public var Z:Number;
		public final function Vector3(x:Number=0,y:Number=0,z:Number=0) {
			X = x;
			Y = y;
			Z = z;
		}
		public final function Plus(vector:Vector3):Vector3 {
			return new Vector3(X + vector.X, Y + vector.Y, Z + vector.Z);
		}
		public final function Times(vector:Vector3):Vector3 {
			return new Vector3(X * vector.X, Y * vector.Y, Z * vector.Z);
		}
		public final function Divide(vector:Vector3):Vector3 {
			return new Vector3(X / vector.X, Y / vector.Y, Z / vector.Z);
		}
		public final function Minus(vector:Vector3):Vector3 {
			return new Vector3(X - vector.X, Y - vector.Y, Z - vector.Z);
		}
		public final function DotProduct(vector:Vector3):Number {
			return X * vector.X + Y * vector.Y + Z * vector.Z;
		}
		public final function CrossProduct(vector:Vector3):Vector3 {
			return new Vector3(Y * vector.Z - vector.Y * Z, Z * vector.X - vector.Z * X, X * vector.Y - vector.X * Y);
		}
	}
}