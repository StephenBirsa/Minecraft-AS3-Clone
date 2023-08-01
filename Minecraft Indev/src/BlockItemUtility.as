package {
	/**
	 * BlockItem Utils
	 * @author Stephen Birsa
	 * Date: 12/02/2018
	 */
	public final class BlockItemUtility {
		public function BlockItemUtility();
		internal final function ChooseGuiItem(name:String):int {
			if (name == "grass") { return 0; }
			else if (name == "dirt") { return 1; }
			else if (name == "stone") { return 3; }
			else if (name == "bricks") { return 4; }
			else if (name == "wood") { return 5; }
			else if (name == "leaves") { return 7; }
			return 8; //blue cloth
		}
		internal final function ChooseBlock(name:String):int {
			if (name == "grass") { return 1; }
			else if (name == "dirt") { return 2; }
			else if (name == "stone") { return 4; }
			else if (name == "bricks") { return 5; }
			else if (name == "wood") { return 7; }
			else if (name == "leaves") { return 8; }
			return 9; //blue cloth
		}
	}
}
