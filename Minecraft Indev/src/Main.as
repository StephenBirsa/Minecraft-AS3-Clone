package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.filters.GlowFilter;
	/**
	 * Minecraft Indev Clone AS3
	 * @author Stephen Birsa
	 * Date: 15/02/2018
	 */
	[SWF(width = 800, height = 600)]
	public class Main extends Sprite {
		internal const RESOLUTION:Resolution = new Resolution();
		private var w:int = RESOLUTION.DEFAULT_X;
		private var h:int = RESOLUTION.DEFAULT_Y;
		private const _DebugTrace:TextField = new TextField();
		private var bd:BitmapData = new BitmapData(w, h, false, 0);
		private var b:Bitmap = new Bitmap(bd);
		private var hudData:BitmapData = new BitmapData(800, 600, true, 0);
		private var hud:Bitmap = new Bitmap(hudData);
		private var pixels:Vector.<uint> = new Vector.<uint>(w * h);
		private var hudPixels:Vector.<uint> = new Vector.<uint>(800 * 600);
		private const _INPUT:Input = new Input();
		private var Yaw:Number = 1, Pitch:Number = 1;
		private var SpeedX:Number = 0.0005, SpeedY:Number = 0.0005;
		private const _BLOCK_ITEM_UTILITY:BlockItemUtility = new BlockItemUtility();
		private const _WORLD:World = new World("normal", "square");
		private var _Player:Player;
		private var IsHandVisible:Boolean = true;
		private var IsTransparentVisible:Boolean = false;
		[Embed(source = "../lib/gui/gui.png")]
		private const _GUI_PNG:Class;
		private const _GUI:BitmapData = (new _GUI_PNG as Bitmap).bitmapData;
		private const _GUI_RECT:Rectangle = new Rectangle(0, 0, 182*2.25+376-182, 22*2.25+572-22);
		private const _GUI_SCALE:Matrix = new Matrix(2.25, 0, 0, 2.25, 376 - 182, 572 - 22);
		private const _GUI_SELECT_RECT:Rectangle = new Rectangle(0+192+(45*0), 22*2.25+497, 24*2.25, 24*2.25);
		private const _GUI_SELECT:Matrix = new Matrix(2.25, 0, 0, 2.25, 192 + (45 * 0), 497);
		private var _GUI_SELECT_POS:int = 0;
		[Embed(source = "../lib/dirt.png")]
		private const _DIRT_PNG:Class;
		[Embed(source = "../lib/grass_side.png")]
		private const _GRASS_PNG:Class;
		[Embed(source = "../lib/grass_top.png")]
		private const _GRASS_TOP_PNG:Class;
		[Embed(source = "../lib/hand.png")]
		private const _HAND_PNG:Class;
		//GUI
		[Embed(source = "../lib/gui/dirt gui.png")]
		private const _DIRT_GUI_PNG:Class;
		[Embed(source = "../lib/gui/grass gui.png")]
		private const _GRASS_GUI_PNG:Class;
		[Embed(source = "../lib/gui/stone gui.png")]
		private const _STONE_GUI_PNG:Class;
		[Embed(source = "../lib/gui/bricks gui.png")]
		private const _BRICKS_GUI_PNG:Class;
		[Embed(source = "../lib/gui/wood gui.png")]
		private const _WOOD_GUI_PNG:Class;
		[Embed(source = "../lib/gui/leaves gui.png")]
		private const _LEAVES_GUI_PNG:Class;
		[Embed(source = "../lib/gui/blue cloth gui.png")]
		private const _BLUE_CLOTH_GUI_PNG:Class;
		//TERRAIN
		[Embed(source = "../lib/terrain.png")]
		private const _TERRAIN_PNG:Class;
		private const terrain:BitmapData = (new _TERRAIN_PNG as Bitmap).bitmapData;
		private const itemGui:Array = [(new _GRASS_GUI_PNG as Bitmap).bitmapData, (new _DIRT_GUI_PNG as Bitmap).bitmapData, (new _STONE_GUI_PNG as Bitmap).bitmapData, (new _BRICKS_GUI_PNG as Bitmap).bitmapData, (new _WOOD_GUI_PNG as Bitmap).bitmapData, (new _LEAVES_GUI_PNG as Bitmap).bitmapData, (new _BLUE_CLOTH_GUI_PNG as Bitmap).bitmapData];
		private const hand:BitmapData = (new _HAND_PNG as Bitmap).bitmapData;
		private const handScale:Matrix = new Matrix(0.6, 0, -0.05, 0.6, 608, 430);
		private var itemBlock:Array = [];
		private const blockShapeFront:Matrix = new Matrix(18, 6, 0, 18, 558, 500);
		private const blockShapeTop:Matrix = new Matrix(5, -3, 15, 5, 560, 500);
		public function Main() {
			_Player = new Player(10 + Math.floor(Math.random() * (_WORLD.Size.Z-10)), _WORLD.Size.Y / 2, 10 + Math.floor(Math.random() * (_WORLD.Size.X-10)));
			environment.sunPoint.X = environment.moonPoint.X = _WORLD.Size.X / 2;
			environment.sunPoint.Z = environment.moonPoint.Z = _WORLD.Size.Z / 2;
			if (_Player.Mode == "creative") {
				_Player.Slots[0] = "grass";
				_Player.Slots[1] = "dirt";
				_Player.Slots[2] = "stone";
				_Player.Slots[3] = "bricks";
				_Player.Slots[4] = "wood";
				_Player.Slots[5] = "leaves";
				_Player.Slots[6] = "blue cloth";
				_Player.SelectedBlock = _Player.Slots[0];
			}
			_DebugTrace.selectable = false;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			b.scaleX = RESOLUTION.DEFAULT_SCALE_X;
			b.scaleY = RESOLUTION.DEFAULT_SCALE_Y;
			_DebugTrace.textColor = 0xffffff;
			_DebugTrace.width = 800;
			_DebugTrace.height = 600;
			stage.frameRate = 30;
			stage.addChild(b);
			stage.addChild(hud);
			stage.addChild(_DebugTrace);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, FullScreen);
			stage.displayState = "fullScreenInteractive";
			stage.addEventListener(Event.ENTER_FRAME, RenderMinecraft);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseUp);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, RightMouseDown);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, RightMouseUp);
			_WORLD.InitTexMap();
			_WORLD.InitMap();
			GenerateCursor();
			GenerateItemBlocks();
		}
		private final function GenerateCursor():void {
			for (var x:int = 0; x < 3; x++) {
				for (var y:int = 0; y < 20; y++) {
					var xx:int = 399 + x;
					var yy:int = 290 + y;
					var xxx:int = 390 + y;
					var yyy:int = 298 + x;
					hudPixels[xx + yy * 800] = 0xff999999;
					hudPixels[xxx + yyy * 800] = 0xff999999;
				}
			}
			hudData.setVector(hudData.rect, hudPixels);
		}
		private final function GenerateItemBlocks():void {
			var tempRect:Rectangle = new Rectangle(16, 0, 16, 16);
			var tempPoint:Point = new Point();
			itemBlock[0] = (new _GRASS_PNG as Bitmap).bitmapData; //grass
			itemBlock[1] = (new _DIRT_PNG as Bitmap).bitmapData; //dirt
			itemBlock[2] = (new _GRASS_TOP_PNG as Bitmap).bitmapData; //grass
			itemBlock[3] = new BitmapData(16, 16, false, 0);
			itemBlock[3].copyPixels(terrain, tempRect, tempPoint); //stone
			tempRect.x = 112;
			itemBlock[4] = new BitmapData(16, 16, false, 0);
			itemBlock[4].copyPixels(terrain, tempRect, tempPoint); //bricks
			tempRect.x = 64, tempRect.y = 16;
			itemBlock[5] = new BitmapData(16, 16, false, 0);
			itemBlock[5].copyPixels(terrain, tempRect, tempPoint); //wood
			tempRect.x = 80;
			itemBlock[6] = new BitmapData(16, 16, false, 0);
			itemBlock[6].copyPixels(terrain, tempRect, tempPoint); //wood
			tempRect.x = 64, tempRect.y = 48;
			itemBlock[7] = new BitmapData(16, 16, true, 0);
			itemBlock[7].copyPixels(terrain, tempRect, tempPoint); //leaves
			tempRect.x = 128, tempRect.y = 64;
			itemBlock[8] = new BitmapData(16, 16, true, 0);
			itemBlock[8].copyPixels(terrain, tempRect, tempPoint); //blue cloth
			
		}
		private final function MouseDown(e:MouseEvent):void {
			_INPUT.IsMouseHeld = true;
		}
		private final function MouseUp(e:MouseEvent):void {
			_INPUT.IsMouseHeld = false;
		}
		private final function RightMouseDown(e:MouseEvent):void {
			_INPUT.IsRightMouseHeld = true;
		}
		private final function RightMouseUp(e:MouseEvent):void {
			_INPUT.IsRightMouseHeld = false;
		}
		private final function FullScreen(fe:FullScreenEvent):void {
			if (fe.fullScreen || fe.interactive) {
				stage.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
			}
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, FullScreen);
		}
		private final function KeyDown(ke:KeyboardEvent):void {
			KeyPress(ke, true);
		}
		private final function KeyUp(ke:KeyboardEvent):void {
			KeyPress(ke, false);
		}
		private final function KeyPress(ke:KeyboardEvent, isKeyDown:Boolean):void {
			if (isKeyDown) {
				if (ke.keyCode == Keyboard.ESCAPE) {
					stage.nativeWindow.close();
				}
				if (ke.keyCode == Keyboard.D && ke.keyCode != Keyboard.A) {
					_INPUT.IsDHeld = true;
				}
				if (ke.keyCode == Keyboard.A && ke.keyCode != Keyboard.D) {
					_INPUT.IsAHeld = true;
				}
				if (ke.keyCode == Keyboard.W && ke.keyCode != Keyboard.S) {
					_INPUT.IsWHeld = true;
				}
				if (ke.keyCode == Keyboard.S && ke.keyCode != Keyboard.W) {
					_INPUT.IsSHeld = true;
				}
				if (ke.keyCode == Keyboard.SPACE) {
					_INPUT.IsSpaceHeld = true;
				}
				if (ke.keyCode == Keyboard.NUMBER_1) {
					_GUI_SELECT_POS = 0;
					_Player.SelectedBlock = _Player.Slots[0];
				}
				if (ke.keyCode == Keyboard.NUMBER_2) {
					_GUI_SELECT_POS = 1;
					_Player.SelectedBlock = _Player.Slots[1];
				}
				if (ke.keyCode == Keyboard.NUMBER_3) {
					_GUI_SELECT_POS = 2;
					_Player.SelectedBlock = _Player.Slots[2];
				}
				if (ke.keyCode == Keyboard.NUMBER_4) {
					_GUI_SELECT_POS = 3;
					_Player.SelectedBlock = _Player.Slots[3];
				}
				if (ke.keyCode == Keyboard.NUMBER_5) {
					_GUI_SELECT_POS = 4;
					_Player.SelectedBlock = _Player.Slots[4];
				}
				if (ke.keyCode == Keyboard.NUMBER_6) {
					_GUI_SELECT_POS = 5;
					_Player.SelectedBlock = _Player.Slots[5];
				}
				if (ke.keyCode == Keyboard.NUMBER_7) {
					_GUI_SELECT_POS = 6;
					_Player.SelectedBlock = _Player.Slots[6];
				}
				if (ke.keyCode == Keyboard.NUMBER_8) {
					_GUI_SELECT_POS = 7;
					_Player.SelectedBlock = _Player.Slots[7];
				}
				if (ke.keyCode == Keyboard.NUMBER_9) {
					_GUI_SELECT_POS = 8;
					_Player.SelectedBlock = _Player.Slots[8];
				}
				if (ke.keyCode == Keyboard.F && _INPUT.IsFHeld == false) {
					_INPUT.IsFHeld = true;
					renderDistance = (renderDistance == 16 ? 32 : renderDistance == 32 ? 64 : renderDistance == 64 ? 120 : 16);
				}
			}
			else if (!isKeyDown) {
				if (ke.keyCode == Keyboard.D) {
					_INPUT.IsDHeld = false;
				}
				if (ke.keyCode == Keyboard.A) {
					_INPUT.IsAHeld = false;
				}
				if (ke.keyCode == Keyboard.W) {
					_INPUT.IsWHeld = false;
				}
				if (ke.keyCode == Keyboard.S) {
					_INPUT.IsSHeld = false;
				}
				if (ke.keyCode == Keyboard.SPACE) {
					_INPUT.IsSpaceHeld = false;
				}
				if (ke.keyCode == Keyboard.F) {
					_INPUT.IsFHeld = false;
				}
			}
		}
		private var Aimdir:Vector3 = new Vector3();
		private var Side:Vector3 = new Vector3();
		private var Up:Vector3 = new Vector3(0, SpeedY, 0);
		private var JumpCoolDown:int = 0;
		private final function HandleControls():void {
			if (_Player.JumpTimer > 0) {
				_Player.JumpTimer -= 1;
			}
			if (_Player.JumpTimer == 0 && _WORLD.Gravity < 0) {
				_WORLD.Velocity = 0;
				_WORLD.Gravity += 0.005;
			}
			if (_Player.IsTouchingGround == false || _WORLD.Gravity == -0.05) {
				if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Z] != 0) { //roof collision
					_WORLD.Velocity = 0; //set velocity to zero
					_WORLD.Gravity += 0.01; //force harder gravity to stop from hitting block
				}
				_WORLD.Velocity += _WORLD.Gravity;
				if (_WORLD.Velocity < -0.1) {
					_WORLD.Velocity = -0.1;
				}
				if (_WORLD.Velocity > 0.3) {
					_WORLD.Velocity = 0.3;
				}
				_Player.Pos.Y += _WORLD.Velocity;
				//depth shadows
				environment.blockShadow = 255 - (_Player.Pos.Y * 4.6 / 2);
				environment.allowShadowChange = true;
			} else {
				_WORLD.Gravity = 0.005;
				_WORLD.Velocity = 0;
				if (JumpCoolDown == 0 && _INPUT.IsSpaceHeld && _Player.IsTouchingGround) {
					_WORLD.Gravity = -0.05;
					JumpCoolDown = 2;
					_Player.JumpTimer = 8;
				}
			}
			if (JumpCoolDown > 0) {
				JumpCoolDown -= 1;
			}
			Aimdir.X = Math.cos(Yaw);
			Aimdir.Y = Math.cos(Pitch);
			Aimdir.Z = Math.sin(Yaw);
			Side = Aimdir.CrossProduct(Up);
			if (_WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] != 0 &&
				_WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] != 16 &&
				_WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] != 17
			) {
				_Player.IsTouchingGround = true;
			}
			else {
				_Player.IsTouchingGround = false;
			}
			if (_Player.MouseTimer > 0) {
				_Player.MouseTimer -= 1;
			}
			if (_INPUT.IsMouseHeld && _Player.MouseTimer == 0 && _Player.Pos.Y > 3) {
				if (Pitch - 1.5 > -0.2) {
					if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] > 0 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] != 16 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] != 17 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] != 18) {
						_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] = 0;
					} else if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] > 0 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] != 16 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] != 17 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] != 18) {
						_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] = 0;
					}
				} else if (Pitch - 1.5 > -2.4) {
					if (_WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | (_Player.Pos.Y - Pitch - 1.5) << 12 | (_Player.Pos.Z + Aimdir.Z)] > 0 && _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | (_Player.Pos.Y - Pitch - 1.5) << 12 | (_Player.Pos.Z + Aimdir.Z)] != 16 && _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | (_Player.Pos.Y - Pitch - 1.5) << 12 | (_Player.Pos.Z + Aimdir.Z)] != 17 && _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | (_Player.Pos.Y - Pitch - 1.5) << 12 | (_Player.Pos.Z + Aimdir.Z)] != 18) {
						_WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | (_Player.Pos.Y - Pitch - 1.5) << 12 | (_Player.Pos.Z + Aimdir.Z)] = 0;
					}
				} else if (Pitch - 1.5 > -2.85) {
					if (_WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | _Player.Pos.Y << 12 | (_Player.Pos.Z + Aimdir.Z)] > 0 && _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | _Player.Pos.Y << 12 | (_Player.Pos.Z + Aimdir.Z)] != 16 && _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | _Player.Pos.Y << 12 | (_Player.Pos.Z + Aimdir.Z)] != 17 && _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | _Player.Pos.Y << 12 | (_Player.Pos.Z + Aimdir.Z)] != 18) {
						_WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | _Player.Pos.Y << 12 | (_Player.Pos.Z + Aimdir.Z)] = 0;
					}
				} else if (Pitch - 1.5 <= -2.85) {
					if (_WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] > 0 && _WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] != 16 && _WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] != 17 && _WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] != 18) {
						_WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] = 0;
					} else if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y+1) << 12 | _Player.Pos.Z] > 0 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y+1) << 12 | _Player.Pos.Z] != 16 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y+1) << 12 | _Player.Pos.Z] != 17 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y+1) << 12 | _Player.Pos.Z] != 18) {
						_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y + 1) << 12 | _Player.Pos.Z] = 0;
					}
				}
				_Player.MouseTimer = 15;
			}
			if (_INPUT.IsRightMouseHeld && _Player.MouseTimer == 0 && _Player.Pos.Y > 5) {
				var block:int = _BLOCK_ITEM_UTILITY.ChooseBlock(_Player.SelectedBlock);
				if (_Player.SelectedBlock != "hand") {
					if (Pitch - 1.5 > -0.2 && _Player.Pos.Y > 7) {
						if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 5) << 12 | _Player.Pos.Z] != 0 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] == 0 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] == 0) {
							_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] = block;
						} else if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 4) << 12 | _Player.Pos.Z] != 0 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] == 0) {
							_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 3) << 12 | _Player.Pos.Z] = block;
						}
					} else if (Pitch - 1.5 > -2.4 && _Player.Pos.Y > 7) {
						_WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | (_Player.Pos.Y - Pitch - 1.5) << 12 | (_Player.Pos.Z + Aimdir.Z)] == 0 ? _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | (_Player.Pos.Y - Pitch - 1.5) << 12 | (_Player.Pos.Z + Aimdir.Z)] = block : null;
					} else if (Pitch - 1.5 > -2.85 && _Player.Pos.Y > 7) {
						_WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | _Player.Pos.Y << 12 | (_Player.Pos.Z + Aimdir.Z)] == 0 ? _WORLD.map[(_Player.Pos.X + Aimdir.X) << 18 | _Player.Pos.Y << 12 | (_Player.Pos.Z + Aimdir.Z)] = block : null;
					} else if (Pitch - 1.5 <= -2.85) {
						if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y + 2) << 12 | _Player.Pos.Z] != 0 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y + 1) << 12 | _Player.Pos.Z] == 0 && _WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] == 0) {
							_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y + 1) << 12 | _Player.Pos.Z] = block;
						} else if (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y + 1) << 12 | _Player.Pos.Z] != 0 && _WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] == 0) {
							_WORLD.map[_Player.Pos.X << 18 | _Player.Pos.Y << 12 | _Player.Pos.Z] = block;
						}
					}
					_Player.MouseTimer = 15;
				}
			}
			for (var t:int = 0; t < 180; t++) {
				//Collisions
				if ((_WORLD.map[(_Player.Pos.X + Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Z] != 17 && _WORLD.map[(_Player.Pos.X + Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Z] != 0) || (_WORLD.map[(_Player.Pos.X + Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Z] != 17 && _WORLD.map[(_Player.Pos.X + Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Z] != 0)) {
					_Player.Pos.X -= Aimdir.X * SpeedX;
					_Player.AllowForward = false;
				}
				if ((_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 1) << 12 | (_Player.Pos.Z + Aimdir.Z * SpeedX)] != 17 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 1) << 12 | (_Player.Pos.Z + Aimdir.Z * SpeedX)] != 0) || (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 2) << 12 | (_Player.Pos.Z + Aimdir.Z * SpeedX)] != 17 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 2) << 12 | (_Player.Pos.Z + Aimdir.Z * SpeedX)] != 0)) {
					_Player.Pos.Z -= Aimdir.Z * SpeedX;
					_Player.AllowForward = false;
				}
				if ((_WORLD.map[(_Player.Pos.X - Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Z] != 17 && _WORLD.map[(_Player.Pos.X - Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Z] != 0) || (_WORLD.map[(_Player.Pos.X - Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Z] != 17 && _WORLD.map[(_Player.Pos.X - Aimdir.X * SpeedX) << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Z] != 0)) {
					_Player.Pos.X += Aimdir.X * SpeedX;
					_Player.AllowBackward = false;
				}
				if ((_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 1) << 12 | (_Player.Pos.Z - Aimdir.Z * SpeedX)] != 17 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 1) << 12 | (_Player.Pos.Z - Aimdir.Z * SpeedX)] != 0) || (_WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 2) << 12 | (_Player.Pos.Z - Aimdir.Z * SpeedX)] != 17 && _WORLD.map[_Player.Pos.X << 18 | (_Player.Pos.Y - 2) << 12 | (_Player.Pos.Z - Aimdir.Z * SpeedX)] != 0)) {
					_Player.Pos.Z += Aimdir.Z * SpeedX;
					_Player.AllowBackward = false;
				}
				if ((_WORLD.map[_Player.Pos.Plus(Side).X << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Plus(Side).Z] != 17 && _WORLD.map[_Player.Pos.Plus(Side).X << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Plus(Side).Z] != 0) || (_WORLD.map[_Player.Pos.Plus(Side).X << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Plus(Side).Z] != 17 && _WORLD.map[_Player.Pos.Plus(Side).X << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Plus(Side).Z] != 0)) {
					_Player.Pos = _Player.Pos.Minus(Side);
					_Player.AllowRightStrafe = false;
				}
				if ((_WORLD.map[_Player.Pos.Minus(Side).X << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Minus(Side).Z] != 17 && _WORLD.map[_Player.Pos.Minus(Side).X << 18 | (_Player.Pos.Y - 1) << 12 | _Player.Pos.Minus(Side).Z] != 0) || (_WORLD.map[_Player.Pos.Minus(Side).X << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Minus(Side).Z] != 17 && _WORLD.map[_Player.Pos.Minus(Side).X << 18 | (_Player.Pos.Y - 2) << 12 | _Player.Pos.Minus(Side).Z] != 0)) {
					_Player.Pos = _Player.Pos.Plus(Side);
					_Player.AllowLeftStrafe = false;
				}
				//Movement
				if (_INPUT.IsWHeld && _Player.AllowForward) {
					_Player.Pos.X += Aimdir.X * SpeedX;
					_Player.Pos.Z += Aimdir.Z * SpeedX;
				}
				if (_INPUT.IsSHeld && _Player.AllowBackward) {
					_Player.Pos.X -= Aimdir.X * SpeedX;
					_Player.Pos.Z -= Aimdir.Z * SpeedX;
				}
				if (_INPUT.IsDHeld && _Player.AllowRightStrafe) {
					_Player.Pos = _Player.Pos.Plus(Side);
				}
				if (_INPUT.IsAHeld && _Player.AllowLeftStrafe) {
					_Player.Pos = _Player.Pos.Minus(Side);
				}
				if (_Player.AllowForward == false) {
					_Player.AllowForward = true;
				}
				if (_Player.AllowBackward == false) {
					_Player.AllowBackward = true;
				}
				if (_Player.AllowRightStrafe == false) {
					_Player.AllowRightStrafe = true;
				}
				if (_Player.AllowLeftStrafe == false) {
					_Player.AllowLeftStrafe = true;
				}
			}
		}
		private var lookHorizontal:Number = 0; //min:0,max:3.14 * 2
		private var lookVertical:Number = 0; //min:0,max:3.14 * 2
		private var lightRender:Number = 0; //min:0,max:64;
		private var framesElapsed:int = 0;
		private var ox:Number;
		private var oy:Number;
		private var oz:Number;
		private var shadowLevel:int = 240; //min:64,max:255
		private var environment:Environment = new Environment();
		private var renderDistance:int = 64;
		private final function DayNightCycle(daytime:Number):void {
			if (daytime > 1) {
				environment.mapShadow = -1 + daytime;
			} else if (daytime < 1) {
				environment.mapShadow = 1 - daytime;
			}
			environment.mapShadow < 0.2 ? environment.mapShadow = 0.2 : environment.mapShadow > 0.8 ? environment.mapShadow = 1 : null;
			environment.mapShadow < 0.3 ? environment.IsItDawn = true : environment.mapShadow > 0.9 ? environment.IsItDawn = false : null;
			environment.mapSunShadow = environment.mapShadow;
			//do sunpoint x and z later
			if (_Player.Pos.Y > environment.moonReach) {
				if (_Player.Pos.Y > environment.sunReach + 6) {
					environment.mapSunShadow = 0.5;
				}
				if (_Player.Pos.Y > environment.sunReach + 10) {
					environment.mapSunShadow = 0.4;
				}
				if (_Player.Pos.Y > environment.sunReach + 12) {
					environment.mapSunShadow = 0.3;
				}
				if (_Player.Pos.Y > environment.sunReach + 14) {
					environment.mapSunShadow = 0.2;
				}
			}
			environment.mapTransform.redMultiplier = environment.mapTransform.greenMultiplier = environment.mapTransform.blueMultiplier = environment.mapSunShadow;
		}
		private final function MouseManager():void {
			if (stage.mouseLock == false) {
				stage.mouseLock = true;
			}
			if (Pitch > 1.5) {
				Pitch = 1.5;
			}
			if (Pitch < -1.5) {
				Pitch = -1.5;
			}
		}
		private final function RenderMinecraft(e:Event):void {
			MouseManager();
			_Player.PositionManager(_WORLD.Size);
			HandleControls();
			FpsMeter.getFPS();
			lookVertical = Pitch;
			lookHorizontal = Yaw;
			var xRot:Number = lookHorizontal; //left - right
			var yRot:Number = lookVertical; //up - down
			var yCos:Number = Math.cos(yRot);
			var ySin:Number = Math.sin(yRot);
			var xCos:Number = Math.cos(xRot);
			var xSin:Number = Math.sin(xRot);
			ox = _Player.Pos.Z;
			oy = _Player.Pos.Y - 1.7;
			oz = _Player.Pos.X;
			framesElapsed++;
			var daytime:Number = ((framesElapsed / 40000) / (stage.frameRate / 60)) % 2;
			DayNightCycle(daytime);
			var col:int = 0;
			for (var x:int = 0; x < w; x++) {
                var ___xd:Number = (x - w / 2) / h;
				for (var y:int = 0; y < h; y++) {
                    var __yd:Number = (y - h / 2) / h;
                    var __zd:Number = 0.6; //fov/quake fov (original: 1)
					var ___zd:Number = __zd * yCos + __yd * ySin;
                    var _yd:Number = __yd * yCos - __zd * ySin;
                    var _xd:Number = ___xd * xCos + ___zd * xSin;
                    var _zd:Number = ___zd * xCos - ___xd * xSin;
                    var br:int = 255;
                    var ddist:int = 1;
                    var closest:Number = renderDistance;
                    for (var d:int = 0; d < 3; d++) {
                        var dimLength:Number = _xd;
                        if (d == 1)
                        dimLength = _yd;
                        if (d == 2)
                        dimLength = _zd;
                        var ll:Number = 1 / (dimLength < 0 ? -dimLength : dimLength);
                        var xd:Number = (_xd) * ll;
                        var yd:Number = (_yd) * ll;
                        var zd:Number = (_zd) * ll;
                        var initial:Number = ox - (ox | 0);
                        if (d == 1)
							initial = oy - (oy | 0);
                        if (d == 2)
							initial = oz - (oz | 0);
                        if (dimLength > 0)
							initial = 1 - initial;
                        var dist:Number = ll * initial;
                        var xp:Number = ox + xd * initial;
                        var yp:Number = oy + yd * initial;
                        var zp:Number = oz + zd * initial;
                        if (dimLength < 0) {
                            if (d == 0)
								xp--;
                            if (d == 1)
								yp--;
                            if (d == 2)
								zp--;
                        }
						var tex:int;
						while (dist < closest) {
							if (zp >= 0 && xp >= 0 && yp >= 0 && zp < _WORLD.Size.Z && yp <= _WORLD.Size.Y && xp < _WORLD.Size.X) {
								tex = _WORLD.map[(zp & (_WORLD.Size.Z - 1)) << 18 | (yp & (_WORLD.Size.Y - 1)) << 12 | (xp & (_WORLD.Size.X - 1))];
							} else if (yp >= 37 && yp < 38) {
								tex = 1; //if island replace with water
							} else if (yp > 37 && yp < 39) {
								tex = 2; //if island replace with water
							} else if (yp >= 39 && yp <= _WORLD.Size.Y) {
								tex = 18;
							} else {
								tex = 0;
							}
                            if (tex > 0) {
                                var u:int = ((xp + zp) * 16) & 15;
                                var v:int = ((yp * 16) & 15) + 16;
                                if (d == 1) {
                                    u = (xp * 16) & 15;
                                    v = ((zp * 16) & 15);
                                    if (yd < 0)
										v += 32;
                                }
								var cc:int = _WORLD.texmap[u + v * 16 + tex * 256 * 3];
                                if (cc > 0) {
                                    col = cc;
                                    ddist = 255 - ((dist / lightRender * 255) | 0);
                                    //br = shadowLevel * (255 - ((d + 2) % 3) * 50) / 255;
                                    closest = dist;
                                }
                            }
                            xp += xd;
                            yp += yd;
                            zp += zd;
                            dist += ll;
                        }
                    }
					br = shadowLevel * 255 / 255;
                    var r:int = (((col >> 16) & 0xff) * br * ddist) / 65025;
                    var g:int = (((col >> 8) & 0xff) * br * ddist) / 65025;
                    var b:int = (((col) & 0xff) * br * ddist) / 65025;
					pixels[x + y * w] = r << 16 | g << 8 | b;
					if (pixels[x + y * w] == 0 && _Player.Pos.Y <= 38) {
						pixels[x + y * w] = 0x7ec0ee;
					}
				}
			}
			if (environment.allowShadowChange) {
				for (var i:int = 1; i < 19; i++) {
					br = environment.blockShadow;
					if (i == 17) { continue; }
					for (y = 0; y < 16 * 3; y++) {
						for (x = 0; x < 16; x++) {
							var colour:int = _WORLD.basetextures[x + y * 16 + i * 256 * 3];
							var brr:int = br;
							if (y >= 32) {
								brr /= 2;
							}
							col = (((colour >> 16) & 0xff) * brr / 255) << 16
							| (((colour >> 8) & 0xff) * brr / 255) << 8
							| (((colour) & 0xff) * brr / 255);
							_WORLD.texmap[x + y * 16 + i * 256 * 3] = col;
						}
					}
				}
				environment.allowShadowChange = false;
			}
			HandItem();
			hudData.setVector(hudData.rect, hudPixels);
			bd.setVector(bd.rect, pixels);
			bd.colorTransform(bd.rect, environment.mapTransform);
			_DebugTrace.text = "Minecraft Indev In Flash (" + FpsMeter.fps + ")" +
			"\nMapSize: " + _WORLD.CustomSize + "\nMapShape: " + _WORLD.CustomShape +
			"\nMapSize: " + _WORLD.Size.X + "x" + _WORLD.Size.Y + "x" + _WORLD.Size.Z + "\nX: " + int(_Player.Pos.X) + 
			"\nY: " + int(_Player.Pos.Y) + "\nZ: " + int(_Player.Pos.Z) +  
			"\nPress F to change Render distance: " + renderDistance + " " + (renderDistance == 16 ? "Tiny" : renderDistance == 32 ? "Small" : renderDistance == 64 ? "Normal" : "Far") +
			"\nDay-night cycle: " + environment.StateOfDay(environment.mapShadow) +
			"\nGame World : " + environment.TimeOfDayHour(daytime) + "h" +
			"\nRender Resolution: " + RESOLUTION.CurrentX + "x" + RESOLUTION.CurrentY +
			"\nMode: " + _Player.Mode;
		}
		private final function HandItem():void {
			var i:int = _BLOCK_ITEM_UTILITY.ChooseGuiItem(_Player.SelectedBlock);
			var blockRect:Rectangle = new Rectangle(550, 400, 250, 200);
			if (_Player.SelectedBlock != "hand") {
				var handRect:Rectangle = new Rectangle(handScale.tx, handScale.ty, hand.rect.width, hand.rect.height);
				if (IsHandVisible) {
					handRect.x = handRect.x - 5;
					hudData.fillRect(handRect, 0);
					IsHandVisible = false;
				}
				if (_Player.SelectedBlock != "leaves" && IsTransparentVisible) {
					IsTransparentVisible = false;
				}
				else if (_Player.SelectedBlock == "leaves" && IsTransparentVisible == false) {
					hudData.fillRect(blockRect, 0);
					IsTransparentVisible = true;
				}
				hudData.draw(itemBlock[i], blockShapeFront, environment.mapTransform);
				blockShapeTop.invert();
				if (_Player.SelectedBlock != "grass" && _Player.SelectedBlock != "wood") {
					hudData.draw(itemBlock[i], blockShapeTop, environment.mapTransform);
				} else if (_Player.SelectedBlock == "wood") {
					hudData.draw(itemBlock[6], blockShapeTop);
				} else if (_Player.SelectedBlock == "grass") {
					hudData.draw(itemBlock[2], blockShapeTop, new ColorTransform(0.6*environment.mapSunShadow,1*environment.mapSunShadow,0.4*environment.mapSunShadow));
				}
			} else {
				if (IsHandVisible == false) {
					hudData.fillRect(blockRect, 0);
				}
				IsHandVisible = true;
				hudData.draw(hand, handScale, environment.mapTransform);
			}
			hudData.fillRect(_GUI_SELECT_RECT, 0);
			hudData.draw(_GUI, _GUI_SCALE, null, null, _GUI_RECT);
			_GUI_SELECT_RECT.x = 192 + (45 * _GUI_SELECT_POS);
			_GUI_SELECT.tx = 192 + (45 * _GUI_SELECT_POS);
			PlayerSlotGui();
			hudData.draw(_GUI, _GUI_SELECT, null, null, _GUI_SELECT_RECT);
			hudPixels = hudData.getVector(hudData.rect);
		}
		private final function PlayerSlotGui():void {
			for (var i:int = 0; i < 9; i++) {
				if (_Player.Slots[i] == "hand") {
					continue;
				}
				var pos:Matrix = new Matrix(0.57, 0, 0, 0.57, 203, 557);
				pos.tx = pos.tx + (45 * i);
				if (_Player.Slots[i] == "grass") {
					hudData.draw(itemGui[0], pos);
				} else if (_Player.Slots[i] == "dirt") {
					hudData.draw(itemGui[1], pos);
				} else if (_Player.Slots[i] == "stone") {
					hudData.draw(itemGui[2], pos);
				} else if (_Player.Slots[i] == "bricks") {
					hudData.draw(itemGui[3], pos);
				} else if (_Player.Slots[i] == "wood") {
					hudData.draw(itemGui[4], pos);
				} else if (_Player.Slots[i] == "leaves") {
					hudData.draw(itemGui[5], pos);
				} else if (_Player.Slots[i] == "blue cloth") {
					pos.scale(0.07, 0.13);
					pos.tx = 200.5 + (45 * i);
					pos.ty = 557;
					hudData.draw(itemGui[6], pos);
				}
			}
		}
		private final function MouseMove(me:MouseEvent):void {
			Yaw += me.movementX / 200;
			Pitch -= me.movementY / 200;
		}
	}
}
