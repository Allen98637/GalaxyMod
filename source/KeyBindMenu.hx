package;

/// Code created by Rozebud for FPS Plus (thanks rozebud)
// modified by KadeDev for use in Kade Engine/Tricky
import Options.Option;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxInput;
import flixel.input.FlxKeyManager;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import lime.utils.Assets;

using StringTools;

class KeyBindMenu extends FlxSubState
{
	var keyText:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];
	var defaultKeys:Array<String> = ["A", "S", "W", "D", "R"];
	var defaultKeys2:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];
	var defaultGpKeys:Array<String> = ["DPAD_LEFT", "DPAD_DOWN", "DPAD_UP", "DPAD_RIGHT"];
	var curSelected:Int = 0;

	var keys:Array<String> = [
		FlxG.save.data.leftBind,
		FlxG.save.data.downBind,
		FlxG.save.data.upBind,
		FlxG.save.data.rightBind
	];

	var keys2:Array<String> = [
		FlxG.save.data.leftBind2,
		FlxG.save.data.downBind2,
		FlxG.save.data.upBind2,
		FlxG.save.data.rightBind2
	];
	var gpKeys:Array<String> = [
		FlxG.save.data.gpleftBind,
		FlxG.save.data.gpdownBind,
		FlxG.save.data.gpupBind,
		FlxG.save.data.gprightBind
	];
	var tempKey:String = "";
	var blacklist:Array<String> = ["TAB", "ESCAPE"];
	var gpblacklist:Array<String> = [];

	var blackBox:FlxSprite;
	var infoText:FlxText;

	var state:String = "starting";

	var strums:Array<NoteStrum> = [];
	var texts:Array<FlxText> = [];
	var keysp:Array<FlxSprite> = [];
	var stroke:FlxSprite;
	private var controls(get, never):Controls;

	var mode:String;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function new(mode:String = "gameplay")
	{
		super();

		this.mode = mode;
	}

	override function create()
	{
		KeyBinds.keyCheck();
		if (mode == "UI")
		{
			keys = [
				FlxG.save.data.leftUIBind,
				FlxG.save.data.downUIBind,
				FlxG.save.data.upUIBind,
				FlxG.save.data.rightUIBind,
				FlxG.save.data.acceptBind,
				FlxG.save.data.backBind,
				FlxG.save.data.pauseBind
			];

			keys2 = [
				FlxG.save.data.leftUIBind2,
				FlxG.save.data.downUIBind2,
				FlxG.save.data.upUIBind2,
				FlxG.save.data.rightUIBind2,
				FlxG.save.data.acceptBind2,
				FlxG.save.data.backBind2,
				FlxG.save.data.pauseBind2
			];
			gpKeys = [
				FlxG.save.data.gpleftUIBind,
				FlxG.save.data.gpdownUIBind,
				FlxG.save.data.gpupUIBind,
				FlxG.save.data.gprightUIBind,
				FlxG.save.data.gpacceptBind,
				FlxG.save.data.gpbackBind,
				FlxG.save.data.gppauseBind
			];

			defaultKeys = ["A", "S", "W", "D", "Z", "X", "P"];
			defaultKeys2 = ["LEFT", "DOWN", "UP", "RIGHT", "SPACE", "BACKSPACE", "ENTER"];
			defaultGpKeys = ["DPAD_LEFT", "DPAD_DOWN", "DPAD_UP", "DPAD_RIGHT", "A", "B", "START"];
		}
		else
		{
			keys = [
				FlxG.save.data.leftBind,
				FlxG.save.data.downBind,
				FlxG.save.data.upBind,
				FlxG.save.data.rightBind
			];

			keys2 = [
				FlxG.save.data.leftBind2,
				FlxG.save.data.downBind2,
				FlxG.save.data.upBind2,
				FlxG.save.data.rightBind2
			];
			gpKeys = [
				FlxG.save.data.gpleftBind,
				FlxG.save.data.gpdownBind,
				FlxG.save.data.gpupBind,
				FlxG.save.data.gprightBind
			];
			blacklist = ["TAB", "ESCAPE", FlxG.save.data.pauseBind, FlxG.save.data.pauseBind2];
			gpblacklist = [FlxG.save.data.gppauseBind];
		}

		// FlxG.sound.playMusic('assets/music/configurator' + TitleState.soundExt);

		persistentUpdate = true;

		blackBox = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackBox);

		if (mode == "gameplay")
		{
			for (i in 0...4)
			{
				var ns:NoteStrum = new NoteStrum(130 + (280 - Note.swagWidth) * i, 250, 1, i);
				ns.animation.play("static");
				ns.alpha = 0;
				ns.antialiasing = true;
				strums.push(ns);
				add(ns);
				FlxTween.tween(ns, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
			}
		}
		if (mode == "UI")
		{
			for (i in 0...8)
			{
				var txts:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "ACCEPT", "BACK", "PAUSE"];
				var ns:FlxText = new FlxText(82 + 140 * i, 350, 200, txts[i]);
				ns.setFormat("Pixel Arial 11 Bold", 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				ns.alpha = 0;
				ns.scale.set(0.7, 0.7);
				ns.antialiasing = true;
				texts.push(ns);
				add(ns);
				FlxTween.tween(ns, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
			}
		}

		for (i in 0...keys.length)
		{
			var nb:FlxSprite = new FlxSprite(100 + (mode == "gameplay" ? 280 : 140) * i, 400).loadGraphic(Paths.image('keys/' + keys[i]));
			if (mode == "UI")
			{
				switch (i)
				{
					case 4:
						nb.color = 0xFD719B;
					case 5:
						nb.color = 0xFF0000;
					case 6:
						nb.color = 0x12FA05;
					default:
						nb.color = 0xF9E96B;
				}
			}
			else
			{
				switch (i)
				{
					case 0:
						nb.color = 0xC24B99;
					case 1:
						nb.color = 0x00FFFF;
					case 2:
						nb.color = 0x12FA05;
					case 3:
						nb.color = 0xF9393F;
				}
			}
			nb.scale.x = 0.7;
			nb.scale.y = 0.7;
			nb.alpha = 0;
			nb.antialiasing = true;
			keysp.push(nb);
			add(nb);
			FlxTween.tween(nb, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
		}
		for (i in 0...keys.length)
		{
			var nb:FlxSprite = new FlxSprite(100 + (mode == "gameplay" ? 280 : 140) * i, 550).loadGraphic(Paths.image('keys/' + keys2[i]));
			if (mode == "UI")
			{
				switch (i)
				{
					case 4:
						nb.color = 0xFD719B;
					case 5:
						nb.color = 0xFF0000;
					case 6:
						nb.color = 0x12FA05;
					default:
						nb.color = 0xF9E96B;
				}
			}
			else
			{
				switch (i)
				{
					case 0:
						nb.color = 0xC24B99;
					case 1:
						nb.color = 0x00FFFF;
					case 2:
						nb.color = 0x12FA05;
					case 3:
						nb.color = 0xF9393F;
				}
			}
			nb.alpha = 0;
			nb.scale.x = 0.7;
			nb.scale.y = 0.7;
			nb.antialiasing = true;
			FlxTween.tween(nb, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
			keysp.push(nb);
			add(nb);
		}

		stroke = new FlxSprite(100, 300).loadGraphic(Paths.image('keys/stroke'));
		if (mode == "UI")
			stroke.color = 0xF9E96B;
		else
			stroke.color = 0xC24B99;
		stroke.alpha = 0;
		stroke.scale.x = 0.7;
		stroke.scale.y = 0.7;
		stroke.antialiasing = true;
		add(stroke);
		FlxTween.tween(stroke, {alpha: 1}, 1, {ease: FlxEase.expoInOut});

		blackBox.alpha = 0;

		infoText = new FlxText(-10, 100, 1280,
			'Current Mode: ${KeyBinds.gamepad ? 'GAMEPAD' : 'KEYBOARD'}.\n Press TAB to switch\n(${KeyBinds.gamepad ? 'RIGHT Trigger' : 'Escape'} to save, BACK to leave without saving. ${KeyBinds.gamepad ? 'START To change a keybind' : ''})',
			72);
		infoText.scrollFactor.set(0, 0);
		infoText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 3;
		infoText.borderQuality = 1;
		infoText.alpha = 0;
		infoText.screenCenter(FlxAxes.X);
		add(infoText);

		FlxTween.tween(infoText, {alpha: 1}, 1.4, {
			ease: FlxEase.expoInOut,
			onComplete: function(twn:FlxTween)
			{
				state = "select";
			}
		});
		FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});

		OptionsMenu.instance.acceptInput = false;

		PlayerSettings.player1.controls.loadKeyBinds();

		textUpdate();

		super.create();
	}

	var frames = 0;

	override function update(elapsed:Float)
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (frames <= 10)
			frames++;

		infoText.text = 'Current Mode: ${KeyBinds.gamepad ? 'GAMEPAD' : 'KEYBOARD'}.\n Press TAB to switch\n(${KeyBinds.gamepad ? 'RIGHT Trigger' : 'Escape'} to save, ${KeyBinds.gamepad ? 'LEFT Trigger' : 'Backspace'} to leave without saving. ${KeyBinds.gamepad ? 'START To change a keybind' : ''})';

		switch (state)
		{
			case "select":
				if (controls.LEFT_UI)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
					textUpdate();
				}

				if (controls.RIGHT_UI)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
					textUpdate();
				}

				if (!KeyBinds.gamepad && (controls.UP_UI || controls.DOWN_UI))
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(keys.length);
					textUpdate();
				}

				if (FlxG.keys.justPressed.TAB)
				{
					KeyBinds.gamepad = !KeyBinds.gamepad;
					curSelected = 0;
					textUpdate();
				}

				if (controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					state = "input";
				}
				else if (FlxG.keys.justPressed.ESCAPE)
				{
					quit();
				}
				else if (controls.BACK)
				{
					reset();
				}
				if (gamepad != null) // GP Logic
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(-1);
						textUpdate();
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(1);
						textUpdate();
					}

					if (gamepad.justPressed.START && frames > 10)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						state = "input";
					}
					else if (gamepad.justPressed.LEFT_TRIGGER)
					{
						quit();
					}
					else if (gamepad.justPressed.RIGHT_TRIGGER)
					{
						reset();
					}
				}

				for (i in 0...keys.length * 2)
				{
					if (i < keys.length || !KeyBinds.gamepad)
					{
						if (FlxG.mouse.screenX > keysp[i].x
							&& FlxG.mouse.screenX < keysp[i].x + keysp[i].width
							&& FlxG.mouse.screenY > keysp[i].y
							&& FlxG.mouse.screenY < keysp[i].y + keysp[i].height
							&& MusicBeatState.mouseA)
						{
							if (curSelected != i)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								curSelected = i;
								textUpdate();
							}
							if (FlxG.mouse.justPressed)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								state = "input";
							}
						}
					}
				}

			case "input":
				if (KeyBinds.gamepad)
				{
					tempKey = gpKeys[curSelected];
					gpKeys[curSelected] = "blank";
				}
				else
				{
					if (curSelected < keys.length)
						tempKey = keys[curSelected];
					else
						tempKey = keys2[curSelected - keys.length];
					if (curSelected < keys.length)
						keys[curSelected] = "blank";
					else
						keys2[curSelected - keys.length] = "blank";
				}
				textUpdate();
				state = "waiting";

			case "waiting":
				if (gamepad != null && KeyBinds.gamepad) // GP Logic
				{
					if (FlxG.keys.justPressed.ESCAPE)
					{ // just in case you get stuck
						gpKeys[curSelected] = tempKey;
						state = "select";
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}

					/*if (gamepad.justPressed.START)
						{
							addKeyGamepad(defaultKeys[curSelected]);
							save();
							state = "select";
					}*/

					if (gamepad.justPressed.ANY)
					{
						trace(gamepad.firstJustPressedID());
						addKeyGamepad(gamepad.firstJustPressedID());
						if (state == "beback")
							state = "input";
						else
						{
							save();
							state = "select";
						}
						textUpdate();
					}
				}
				else
				{
					if (FlxG.keys.justPressed.ESCAPE)
					{
						if (curSelected < keys.length)
							keys[curSelected] = tempKey;
						else
							keys2[curSelected - keys.length] = tempKey;
						state = "select";
						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					/*else if (FlxG.keys.justPressed.ENTER)
						{
							if (curSelected < keys.length)
								addKey(defaultKeys[curSelected]);
							else
								addKey(defaultKeys2[curSelected - keys.length]);
							save();
							state = "select";
					}*/
					else if (FlxG.keys.justPressed.ANY)
					{
						addKey(FlxG.keys.getIsDown()[0].ID.toString());
						if (state == "beback")
							state = "input";
						else
						{
							save();
							state = "select";
						}
					}
				}

			case "exiting":

			default:
				state = "select";
		}

		if (FlxG.keys.justPressed.ANY)
			textUpdate();

		MusicBeatState.checkmouse(elapsed, this);

		if (mode == "gameplay")
		{
			for (i in 0...4)
			{
				var pressed:Bool = (controls.LEFT && i == 0) || (controls.DOWN && i == 1) || (controls.UP && i == 2) || (controls.RIGHT && i == 3);
				strums[i].centerOffsets();
				if (pressed)
				{
					strums[i].animation.play('pressed', true);
				}
				else
					strums[i].animation.play('static');
			}
		}

		super.update(elapsed);
	}

	function textUpdate()
	{
		if (mode == "UI")
			stroke.x = 100 + 140 * (curSelected % 7);
		else
			stroke.x = 100 + 280 * (curSelected % 4);
		stroke.y = (curSelected > keys.length - 1) ? 550 : 400;
		if (mode == "UI")
		{
			switch (curSelected % 7)
			{
				case 4:
					stroke.color = 0xFD719B;
				case 5:
					stroke.color = 0xFF0000;
				case 6:
					stroke.color = 0x12FA05;
				default:
					stroke.color = 0xF9E96B;
			}
		}
		else
		{
			switch (curSelected % 4)
			{
				case 0:
					stroke.color = 0xC24B99;
				case 1:
					stroke.color = 0x00FFFF;
				case 2:
					stroke.color = 0x12FA05;
				case 3:
					stroke.color = 0xF9393F;
			}
		}
		if (KeyBinds.gamepad)
		{
			var conlist:Array<String> = ["A", "B", "X", "Y"];
			for (i in 0...keys.length * 2)
			{
				if (i < keys.length)
				{
					if (conlist.contains(gpKeys[i]))
						keysp[i].loadGraphic(Paths.image('keys/PAD_' + gpKeys[i]));
					else
						keysp[i].loadGraphic(Paths.image('keys/' + gpKeys[i]));
				}
				else
					keysp[i].loadGraphic(Paths.image('keys/empty'));
			}
		}
		else
		{
			for (i in 0...keys.length * 2)
			{
				if (i < keys.length)
				{
					keysp[i].loadGraphic(Paths.image('keys/' + keys[i]));
				}
				else
					keysp[i].loadGraphic(Paths.image('keys/' + keys2[i - keys.length]));
			}
		}

		get_controls();
	}

	function save()
	{
		if (mode == "UI")
		{
			FlxG.save.data.upUIBind = keys[2];
			FlxG.save.data.downUIBind = keys[1];
			FlxG.save.data.leftUIBind = keys[0];
			FlxG.save.data.rightUIBind = keys[3];
			FlxG.save.data.acceptBind = keys[4];
			FlxG.save.data.backBind = keys[5];
			FlxG.save.data.pauseBind = keys[6];

			FlxG.save.data.upUIBind2 = keys2[2];
			FlxG.save.data.downUIBind2 = keys2[1];
			FlxG.save.data.leftUIBind2 = keys2[0];
			FlxG.save.data.rightUIBind2 = keys2[3];
			FlxG.save.data.acceptBind2 = keys2[4];
			FlxG.save.data.backBind2 = keys2[5];
			FlxG.save.data.pauseBind2 = keys2[6];

			FlxG.save.data.gpupUIBind = gpKeys[2];
			FlxG.save.data.gpdownUIBind = gpKeys[1];
			FlxG.save.data.gpleftUIBind = gpKeys[0];
			FlxG.save.data.gprightUIBind = gpKeys[3];
			FlxG.save.data.gpacceptBind = gpKeys[4];
			FlxG.save.data.gpbackBind = gpKeys[5];
			FlxG.save.data.gppauseBind = gpKeys[6];
		}
		else
		{
			FlxG.save.data.upBind = keys[2];
			FlxG.save.data.downBind = keys[1];
			FlxG.save.data.leftBind = keys[0];
			FlxG.save.data.rightBind = keys[3];

			FlxG.save.data.upBind2 = keys2[2];
			FlxG.save.data.downBind2 = keys2[1];
			FlxG.save.data.leftBind2 = keys2[0];
			FlxG.save.data.rightBind2 = keys2[3];

			FlxG.save.data.gpupBind = gpKeys[2];
			FlxG.save.data.gpdownBind = gpKeys[1];
			FlxG.save.data.gpleftBind = gpKeys[0];
			FlxG.save.data.gprightBind = gpKeys[3];
		}

		FlxG.save.flush();

		PlayerSettings.player1.controls.loadKeyBinds();
	}

	function reset()
	{
		for (i in 0...keys.length)
		{
			keys[i] = defaultKeys[i];
		}
		for (i in 0...keys.length)
		{
			keys2[i] = defaultKeys2[i];
		}
		quit();
	}

	function quit()
	{
		state = "exiting";

		save();

		OptionsMenu.instance.acceptInput = true;

		for (i in 0...keys.length)
		{
			if (mode == "gameplay")
				FlxTween.tween(strums[i], {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			if (mode == "UI")
				FlxTween.tween(texts[i], {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			FlxTween.tween(keysp[i], {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			FlxTween.tween(keysp[i + keys.length], {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		}
		FlxTween.tween(stroke, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(blackBox, {alpha: 0}, 1.1, {
			ease: FlxEase.expoInOut,
			onComplete: function(flx:FlxTween)
			{
				close();
			}
		});
		FlxTween.tween(infoText, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
	}

	function addKeyGamepad(r:String)
	{
		var shouldReturn:Bool = true;

		var notAllowed:Array<String> = [];
		var swapKey:Int = -1;

		for (x in 0...gpKeys.length)
		{
			var oK = gpKeys[x];
			if (oK == r)
			{
				swapKey = x;
				gpKeys[x] = null;
			}
			if (notAllowed.contains(oK))
			{
				gpKeys[x] = null;
				lastKey = r;
				state = "beback";
				return;
			}
		}

		if (notAllowed.contains(r))
		{
			gpKeys[curSelected] = tempKey;
			lastKey = r;
			state = "beback";
			return;
		}

		if (shouldReturn)
		{
			if (swapKey != -1)
			{
				gpKeys[swapKey] = tempKey;
			}
			gpKeys[curSelected] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else
		{
			gpKeys[curSelected] = tempKey;
			lastKey = r;
		}
	}

	public var lastKey:String = "";

	function addKey(r:String)
	{
		var shouldReturn:Bool = true;

		var notAllowed:Array<String> = [];
		var swapKey:Int = -1;

		for (x in blacklist)
		{
			notAllowed.push(x);
		}

		trace(notAllowed);

		for (x in 0...keys.length * 2)
		{
			var oK = x < keys.length ? keys[x] : keys2[x - keys.length];
			if (oK == r)
			{
				swapKey = x;
				if (x < keys.length)
					keys[x] = null;
				else
					keys2[x - keys.length] = null;
			}
			if (notAllowed.contains(oK))
			{
				if (x < keys.length)
					keys[x] = null;
				else
					keys2[x - keys.length] = null;
				lastKey = oK;
				state = "beback";
				return;
			}
		}

		if (notAllowed.contains(r))
		{
			if (curSelected < keys.length)
				keys[curSelected] = tempKey;
			else
				keys2[curSelected - keys.length] = tempKey;
			lastKey = r;
			state = "beback";
			return;
		}

		lastKey = "";

		if (shouldReturn)
		{
			// Swap keys instead of setting the other one as null
			if (swapKey != -1)
			{
				if (swapKey < keys.length)
					keys[swapKey] = tempKey;
				else
					keys2[swapKey - keys.length] = tempKey;
			}
			if (curSelected < keys.length)
				keys[curSelected] = r;
			else
				keys2[curSelected - keys.length] = r;
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		else
		{
			if (curSelected < keys.length)
				keys[curSelected] = tempKey;
			else
				keys2[curSelected - keys.length] = tempKey;
			lastKey = r;
		}
	}

	function changeItem(_amount:Int = 0)
	{
		curSelected += _amount;

		if (KeyBinds.gamepad)
		{
			if (curSelected > keys.length - 1)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = keys.length - 1;
		}
		else
		{
			if (curSelected > keys.length * 2 - 1)
				curSelected %= (keys.length * 2);
			if (curSelected == -1)
				curSelected = keys.length * 2 - 1;
			else if (curSelected < 0)
				curSelected %= (keys.length * 2);
		}
	}
}
