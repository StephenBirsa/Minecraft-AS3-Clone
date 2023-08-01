package {
	/**
	 * World
	 * @author TheLazyCoder
	 * Date: 12/02/2018
	 */
	public final class World {
		//internal var CustomTheme:String; //normal
		//internal var CustomType:String; //island
		internal var CustomSize:String;
		internal var CustomShape:String;
		internal var Size:Vector3;
		internal var Gravity:Number = 0.005;
		internal var Velocity:Number = 0;
		internal var texmap:Vector.<int> = new Vector.<int>(16 * 16 * 3 * 19, true);
		internal var basetextures:Vector.<int> = new Vector.<int>(16 * 16 * 3 * 19, true);
		internal var map:Vector.<int> = new Vector.<int>(448 * 448 * 448, true);
		public function World(customSize:String, customShape:String) {
			Size = new Vector3();
			//change and add chunks... chunk size 16x64x16
			//deep chunk size 16x256x16
			//no level for y chunks, only x and z
			//possible y chunk levels...
			//if so then:
			//16x64x16 = 64
			//16x64x16 = 128
			//16x64x16 = 192
			//16x64x16 = 256
			if (customSize == "tiny") {
				if (customShape == "square") {
					Size.X = 64;
					Size.Y = 64;
					Size.Z = 64;
				} else if (customShape == "long") {
					Size.X = 64 / 2;
					Size.Y = 64;
					Size.Z = 64 * 2;
				}
			} else if (customSize == "small") {
				if (customShape == "square") {
					Size.X = 128;
					Size.Y = 64;
					Size.Z = 128;
				} else if (customShape == "long") {
					Size.X = 128 / 2;
					Size.Y = 64;
					Size.Z = 128 * 2;
				}
			} else if (customSize == "normal") {
				if (customShape == "square" || customShape == "long") {
					Size.X = 256;
					Size.Y = 64;
					Size.Z = 256;
				}
			}
			CustomSize = customSize;
			CustomShape = customShape;
		}
		internal final function InitTexMap():void {
			for (var i:int = 1; i < 19; i++) {
				var br:int = 255 - ((Math.random() * 96) | 0); //shadows for textures
				for (var y:int = 0; y < 16 * 3; y++) {
					for (var x:int = 0; x < 16; x++) {
						var colour:int = 0x966c4a; //dirt
						if (i == 4)
							colour = 0x7f7f7f; //stone
						if (i != 4 || ((Math.random() * 3) | 0) == 0) {
							br = 255 - ((Math.random() * 96) | 0); //texturing (dirt, grass, stone, blue wool)
						}
						if (i == 1 && y < (((x * x * 3 + x * 81) >> 2) & 3) + 18) {
							colour = 0x6aaa40; //grass
						} else if (i == 1 && y < (((x * x * 3 + x * 81) >> 2) & 3) + 19) {
							br = br * 2 / 3; //shading for grass portions?
						}
						if (i == 18) {
							colour = 0x323232; //bedrock
						} else if (i == 18 && y < (((x * x * 3 + x * 81) >> 2) & 3) + 19) {
							br = br * 2 / 3; //shading for bedrock portions?
						}
						if (i == 7) {
							colour = 0x675231; //wood
							if (x > 0 && x < 15 && ((y > 0 && y < 15) || (y > 32 && y < 47))) {
								colour = 0xbc9862; //wood
								var xd:int = x - 7;
								var yd:int = (y & 15) - 7;
								if (xd < 0)
									xd = 1 - xd;
								if (yd < 0)
									yd = 1 - yd;
								if (yd > xd)
									xd = yd;
								br = 196 - ((Math.random() * 32) | 0) + xd % 3 * 32;
							} else if (((Math.random() * 2) | 0) == 0) {
								br = br * (150 - (x & 1) * 100) / 100;
							}
						}
						if (i == 5) {
							colour = 0xb53a15; //brick
							if ((x + (y >> 2) * 4) % 8 == 0 || y % 4 == 0) {
								colour = 0xbcafa5; //brick
							}
						}
						if (i == 9) {
							colour = 0x7979e0; //blue cloth
						}
						var brr:int = br;
						if (y >= 32)
							brr /= 2;
						if (i == 8) {
							colour = 0x50d937; //leaves
							if (((Math.random() * 2) | 0) == 0) {
								colour = 0; //air for leaves
								brr = 255;
							}
						}
						if (y >= 32)
							brr *= 2;
						//post processing for colour (texturing (br) and shadow shading (brr))
						var col:int = (((colour >> 16) & 0xff) * brr / 255) << 16
						| (((colour >> 8) & 0xff) * brr / 255) << 8
						| (((colour) & 0xff) * brr / 255);
						texmap[x + y * 16 + i * 256 * 3] = col; //set colour values to blocks for texmap resources
						basetextures[x + y * 16 + i * 256 * 3] = col;
						if (i == 16) {
							texmap[x + y * 16 + i * 256 * 3] = 0x000001; //void
							basetextures[x + y * 16 + i * 256 * 3] = 0x000001;
						}
						if (i == 17) {
							texmap[x + y * 16 + i * 256 * 3] = 0x7ec0ee; //skybox usage only
							basetextures[x + y * 16 + i * 256 * 3] = 0x7ec0ee;
						}
					}
				}
			}
		}
		internal final function InitMap():void {
			for (var x:int = 0; x < Size.X; x++) { //front/back how many blocks
				for (var y:int = 0; y < Size.Y; y++) { //vertical how many blocks
					for (var z:int = 0; z < Size.Z; z++) { //horizontal how many blocks
						var i:int = z << 18 | y << 12 | x; //front/back axis
						if (y > 0 && y < 5) {
							map[i] = 0; //air max top
						}
						if (y > 4 && y < 37) {
							map[i] = 0; //air top
						}
						if (y > 36 && y < 40) {
							map[i] = 1; //grass land
						}
						if (y > 39 && y < 45) {
							map[i] = 4 + (2 * Math.floor(Math.random() * 2)); //stone + dirt near midland
						}
						if (y > 44 && y < 60) {
							map[i] = 4; //stone middle
						}
						if (y > 59 && y < 63) {
							map[i] = 4 * Math.floor(Math.random() * 2); //stone + air near bottom
							if (x == 1 || x == Size.X-1) {
								map[i] = 4;
							}
							if (z == 1 || z == Size.Z-1) {
								map[i] = 4;
							}
						}
						if (y == Size.Y-1) {
							map[i] = 18; //bedrock bottom
						}
					}
				}
			}
			//TODO: make it an array of random circles and random radius's
			var randomCircle:int;
			var randomRadius:int;
			var rCir:int;
			var rR:int;
			for (var k:int = 0; k < 300 * (1 * (Size.X / 256)); k++) {
				randomCircle = (0 + (Math.random() * Size.X)) << 16 | (0 + (Math.random() * Size.Z)) << 8 | (0 + (Math.random() * Size.Y));
				randomRadius = 6 + Math.floor(Math.random() * Size.X);
				rCir = (0 + (Math.random() * Size.X)) << 8 | (0 + (Math.random() * Size.Z));
				rR = 6 + Math.floor(Math.random() * Size.X);
				for (x = 0; x < Size.X; x++) { //front/back how many blocks
					for (y = 40; y < 60; y++) { //vertical how many blocks
						for (z = 0; z < Size.Z; z++) { //horizontal how many blocks
							if (y == 41) {
								i = z << 18 | (y - 5) << 12 | x;
								if ( ( (x - ((rCir >> 8) & 0xff)) * (x - ((rCir >> 8) & 0xff)) ) + ( (z - (rCir & 0xff)) * (z - (rCir & 0xff)) ) <= rR) {
									map[i] = 1; //grass land
								}
							}
							if (y == 40) {
								if (k > 199 * (1 * (Size.X / 256))) {
									i = z << 18 | (y - 5) << 12 | x;
									if ( ( (x - ((rCir >> 8) & 0xff)) * (x - ((rCir >> 8) & 0xff)) ) + ( (z - (rCir & 0xff)) * (z - (rCir & 0xff)) ) <= rR / 3) {
										map[i] = 1; //grass land
									}
								}
							}
							i = z << 18 | y << 12 | x; //front/back axis
							if (y > 45) {
								//generate cave
								if ( ( (x - ((randomCircle >> 16) & 0xff)) * (x - ((randomCircle >> 16) & 0xff)) ) + ( (z - ((randomCircle >> 8) & 0xff)) * (z - ((randomCircle >> 8) & 0xff)) ) + ( (y - (randomCircle & 0xff)) * (y - (randomCircle & 0xff)) ) <= randomRadius) {
									map[i] = 0;
								}
							}
						}
					}
				}
			}
		}
	}
}