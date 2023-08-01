# Minecraft-AS3-Clone
Minecraft Classic/Indev ActionScript 3.0 AdobeAir .EXE CPU driven math 3d

-Head over to Minecraft Indev/MinecraftIndev/ and launch the MinecraftIndev.exe/.swf to play the compiled package of the game.
Note: the game is not very well optimised and has some mouse lag issues

Default resolution compiled at: 200x200

Scroll to the bottom of this readme for Screenshots from gameplay (and what it looked like as I was porting it and eventually converting it into a playable clone/game).

# Features
- Movement with WASD
- Left Click to break blocks
- Right Click to place blocks
- Numbered keys to select blocks (Only grass, dirt, stone, bricks, wood log, leaves and blue cloth/wool were implemented)
- Jumping with Spacebar
- Toggleable render distance (block radius) with F key (16 / Tiny, 32 / Small, 64 / Normal, and 120 / Far)
- Caves generated underground
- Day/Night cycle
- Sunlight lighting strength based on how low you have travelled into the ground
- Blocks can be placed in the air (no adjacent block required)
- Block placing/breaking mechanics slightly different from actual Minecraft (Only can place 1 block outwards from player sight and is not determined by adjacent blocks)
- World size is limited with collision borders

# Background
Started this project originally as a port of Notch's JavaScript Minecraft render test/jsfiddle (Which was a port of Minecraft4K limited in JavaScript) on the web into Flash ActionScript 3.0.
Eventually added the movement vectors and camera rotation code to be able to move around.
Progressed to making it similar to Minecraft's Indev stage of Development but with less implemented and eventually moved on to other projects (and left ActionScript 3.0).

Reference for Minecraft4K and JavaScript Minecraft render test/jsfiddle: https://minecraft.fandom.com/wiki/Minecraft_4k

# History
13/07/2023: TheLazyCoder161 was my original github which I didn't have any use keeping with my current github. I transfered the ownership to my main account (here), and then deleted my secondary github account (TheLazyCoder161).

# Screenshots
Gameplay:
![gameplay_pic](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/c1bbd646-a8c9-46ed-9e8c-54746525370e)

Development:
![received_10216718167697577](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/3ec435fe-b869-4be1-a64e-dff795b8ae34)
When it was ported from the JS fiddle into ActionScript 3.0.
I had it working almost the same. Was experimenting with the camera code and learning how to convert it into movement. Eventually removing the texture generator and using a texture image instead.
![received_1771469212966679](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/ffc6118d-94b8-4d7f-bf39-67204d7603c4)
![received_2026824964296454](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/353858c5-0099-4012-aeb1-ab5b745fbdd2)
I had kept the same generated scene when I first got movement and the camera working. Placing of dirt/grass was implemented along with breaking blocks.
![received_1653081768147931](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/15e43ee0-6432-4eda-9b45-b7b61cf6e54d)
![received_475456156252496](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/b53c8c3b-cf2c-4abd-9005-99f614a3d988)
I implemented some basic cave generation and did some testing.
After added the grass/dirt/stone generation on top.
![received_455137334991683](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/5d8cb7f6-5b0c-4e62-a272-644459925673)
More features were implemented (including grass plains generation) and tested high resolution render (which unfortunately kills the framerate to 1-3 fps).
![received_287008145459945](https://github.com/StephenBirsa/Minecraft-AS3-Clone/assets/27788517/cda9a392-4a9e-40d5-ab19-579fee00998d)
