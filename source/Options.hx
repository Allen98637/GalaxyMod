package;

import AccountSubStates;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.addons.api.FlxGameJolt;
import flixel.util.FlxColor;
import lime.app.Application;
import lime.system.DisplayMode;
import openfl.Lib;
import openfl.display.FPS;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();

	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	public final function removeOption(opt:Int)
	{
		_options.remove(_options[opt]);
	}

	private var _name:String = "New Category";

	public final function getName()
	{
		return _name;
	}

	public function new(catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
		display2 = updateDisplay2();
	}

	private var description:String = "";
	private var display:String;
	private var display2:Array<String>;
	private var acceptValues:Bool = false;

	public var hascheckbox:Bool = false;
	public var selected:Int = 0;

	public final function getDisplay():String
	{
		return display;
	}

	public final function getDisplay2():Array<String>
	{
		return display2;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String
	{
		return throw "stub!";
	};

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return throw "stub!";
	}

	private function updateDisplay():String
	{
		return throw "stub!";
	}

	private function updateDisplay2():Array<String>
	{
		return [];
	}

	public function updateCheck():Bool
	{
		return throw "noCheck";
	}

	public function left():Bool
	{
		return throw "stub!";
	}

	public function right():Bool
	{
		return throw "stub!";
	}
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Gameplay keybinds";
	}
}

class UIKeyOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new KeyBindMenu("UI"));
		return false;
	}

	private override function updateDisplay():String
	{
		return "UI keybinds";
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		this.hascheckbox = true;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Downscroll";
	}

	public override function updateCheck():Bool
	{
		return FlxG.save.data.downscroll;
	}
}

class ProgressOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		this.hascheckbox = true;
	}

	public override function press():Bool
	{
		FlxG.save.data.progressbar = !FlxG.save.data.progressbar;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Progressbar";
	}

	public override function updateCheck():Bool
	{
		return !FlxG.save.data.progressbar;
	}
}

class LangOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		this.acceptValues = true;
	}

	public override function press():Bool
	{
		if (!FlxG.save.data.lang)
			FlxG.save.data.lang = 0;
		if (FlxG.save.data.lang == 1)
			FlxG.save.data.lang = 0;
		else
			FlxG.save.data.lang += 1;
		display = updateDisplay();
		display2 = updateDisplay2();
		return true;
	}

	public override function left():Bool
	{
		if (!FlxG.save.data.lang)
			FlxG.save.data.lang = 0;
		if (FlxG.save.data.lang == 0)
			FlxG.save.data.lang = 1;
		else
			FlxG.save.data.lang -= 1;
		display = updateDisplay();
		display2 = updateDisplay2();
		return true;
	}

	public override function right():Bool
		return press();

	private override function updateDisplay():String
	{
		return "Language";
	}

	private override function updateDisplay2():Array<String>
	{
		if (FlxG.save.data.lang == 1)
		{
			return ["Chinese"];
		}
		else
		{
			return ["English"];
		}
	}
}

class SplashOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		this.hascheckbox = true;
	}

	public override function press():Bool
	{
		FlxG.save.data.nosplash = !FlxG.save.data.nosplash;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "notesplash";
	}

	public override function updateCheck():Bool
	{
		return !FlxG.save.data.nosplash;
	}
}

class MouseOption extends Option
{
	var names:Array<String> = ["Default", "System", "None"];

	public function new(desc:String)
	{
		super();
		description = desc;
		this.acceptValues = true;
	}

	public override function press():Bool
	{
		if (!FlxG.save.data.mouse)
			FlxG.save.data.mouse = 0;
		FlxG.save.data.mouse += 1;
		if (FlxG.save.data.mouse == names.length)
			FlxG.save.data.mouse = 0;
		MusicBeatState.mouseS = 0;
		display = updateDisplay();
		display2 = updateDisplay2();
		return true;
	}

	public override function left():Bool
	{
		if (!FlxG.save.data.mouse)
			FlxG.save.data.mouse = 0;
		FlxG.save.data.mouse -= 1;
		if (FlxG.save.data.mouse == -1)
			FlxG.save.data.mouse = names.length - 1;
		MusicBeatState.mouseS = 0;
		display = updateDisplay();
		display2 = updateDisplay2();
		return true;
	}

	public override function right():Bool
		return press();

	private override function updateDisplay():String
	{
		return "mouse";
	}

	private override function updateDisplay2():Array<String>
	{
		if (!FlxG.save.data.mouse)
			FlxG.save.data.mouse = 0;
		return [names[FlxG.save.data.mouse]];
	}
}

class ShowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		this.hascheckbox = true;
	}

	public override function press():Bool
	{
		FlxG.save.data.showFPS = !FlxG.save.data.showFPS;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "show FPS";
	}

	public override function updateCheck():Bool
	{
		if (Main.fps != null)
		{
			Main.fps.visible = !FlxG.save.data.showFPS;
		}
		return !FlxG.save.data.showFPS;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		this.acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	public override function left():Bool
	{
		if (!FlxG.save.data.FPS)
			FlxG.save.data.FPS = 120;
		if (FlxG.save.data.FPS > 30)
			FlxG.save.data.FPS -= 1;
		display = updateDisplay();
		display2 = updateDisplay2();
		return true;
	}

	public override function right():Bool
	{
		if (!FlxG.save.data.FPS)
			FlxG.save.data.FPS = 120;
		if (FlxG.save.data.FPS < 240)
			FlxG.save.data.FPS += 1;
		display = updateDisplay();
		display2 = updateDisplay2();
		return true;
	}

	private override function updateDisplay():String
	{
		return "framerate";
	}

	private override function updateDisplay2():Array<String>
	{
		if (FlxG.save.data.FPS == null)
			FlxG.save.data.FPS = 120;
		FlxG.updateFramerate = FlxG.save.data.FPS;
		FlxG.drawFramerate = FlxG.save.data.FPS;
		return [FlxG.save.data.FPS + ""];
	}
}

class AccountOption extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public function log()
	{
		display = updateDisplay();
		display2 = updateDisplay2();
		OptionsMenu.instance.updateAccount();
	}

	public override function press():Bool
	{
		if (!FlxGameJolt.initialized)
		{
			OptionsMenu.instance.openSubState(new LogInScreen(this));
		}
		else
		{
			OptionsMenu.instance.acceptInput = false;
			var text:String = "Are you sure to log out your account? (The game will close)";
			if (FlxG.save.data.lang == 1)
				text = "你確定要登出嗎? (遊戲將會退出)";
			OptionsMenu.instance.openSubState(new ConfirmSubState(text, function()
			{
				FlxG.save.data.userName = null;
				FlxG.save.data.userToken = null;
				FlxG.save.data.trophies = [];
				FlxG.save.data.trophiesC = [];
				Lib.application.window.close();
			}, false, function()
			{
				OptionsMenu.instance.acceptInput = true;
			}));
		}
		return false;
	}

	private override function updateDisplay():String
	{
		if (!FlxGameJolt.initialized)
			return "GameJolt Log In";
		return "GameJolt Log Out";
	}

	private override function updateDisplay2():Array<String>
	{
		if (!FlxGameJolt.initialized)
			return [""];
		return [FlxG.save.data.userName];
	}
}

class DataOption extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function press():Bool
	{
		OptionsMenu.instance.openSubState(new DataScreen());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Data Storage";
	}
}

class AutoSyncOption extends Option
{
	public function new(desc:String)
	{
		super();
		this.hascheckbox = true;
	}

	public override function press():Bool
	{
		FlxG.save.data.autoUpload = !FlxG.save.data.autoUpload;
		if (FlxG.save.data.autoUpload && FlxGameJolt.initialized)
			Main.syncData();
		return true;
	}

	private override function updateDisplay():String
	{
		return "auto upload";
	}

	public override function updateCheck():Bool
	{
		return FlxG.save.data.autoUpload;
	}
}
