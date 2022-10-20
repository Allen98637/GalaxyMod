import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

class KeyBinds
{
	public static var gamepad:Bool = false;

	public static function resetBinds():Void
	{
		FlxG.save.data.upBind = "W";
		FlxG.save.data.downBind = "S";
		FlxG.save.data.leftBind = "A";
		FlxG.save.data.rightBind = "D";
		FlxG.save.data.upBind2 = "UP";
		FlxG.save.data.downBind2 = "DOWN";
		FlxG.save.data.leftBind2 = "LEFT";
		FlxG.save.data.rightBind2 = "RIGHT";
		FlxG.save.data.upUIBind = "W";
		FlxG.save.data.downUIBind = "S";
		FlxG.save.data.leftUIBind = "A";
		FlxG.save.data.rightUIBind = "D";
		FlxG.save.data.upUIBind2 = "UP";
		FlxG.save.data.downUIBind2 = "DOWN";
		FlxG.save.data.leftUIBind2 = "LEFT";
		FlxG.save.data.rightUIBind2 = "RIGHT";
		FlxG.save.data.acceptBind = "Z";
		FlxG.save.data.acceptBind2 = "SPACE";
		FlxG.save.data.backBind = "X";
		FlxG.save.data.backBind2 = "BACKSPACE";
		FlxG.save.data.pauseBind = "P";
		FlxG.save.data.pauseBind2 = "ENTER";
		FlxG.save.data.killBind = "R";
		FlxG.save.data.gpupUIBind = "DPAD_UP";
		FlxG.save.data.gpdownUIBind = "DPAD_DOWN";
		FlxG.save.data.gpleftUIBind = "DPAD_LEFT";
		FlxG.save.data.gprightUIBind = "DPAD_RIGHT";
		FlxG.save.data.gpacceptBind = "A";
		FlxG.save.data.gpbackBind = "B";
		FlxG.save.data.gpauseBind = "START";
		PlayerSettings.player1.controls.loadKeyBinds();
	}

	public static function keyCheck():Void
	{
		if (FlxG.save.data.upBind == null)
		{
			FlxG.save.data.upBind = "W";
			trace("No UP");
		}
		if (FlxG.save.data.downBind == null)
		{
			FlxG.save.data.downBind = "S";
			trace("No DOWN");
		}
		if (FlxG.save.data.leftBind == null)
		{
			FlxG.save.data.leftBind = "A";
			trace("No LEFT");
		}
		if (FlxG.save.data.rightBind == null)
		{
			FlxG.save.data.rightBind = "D";
			trace("No RIGHT");
		}

		if (FlxG.save.data.upBind2 == null)
		{
			FlxG.save.data.upBind2 = "UP";
			trace("No UP");
		}
		if (FlxG.save.data.downBind2 == null)
		{
			FlxG.save.data.downBind2 = "DOWN";
			trace("No DOWN");
		}
		if (FlxG.save.data.leftBind2 == null)
		{
			FlxG.save.data.leftBind2 = "LEFT";
			trace("No LEFT");
		}
		if (FlxG.save.data.rightBind2 == null)
		{
			FlxG.save.data.rightBind2 = "RIGHT";
			trace("No RIGHT");
		}

		if (FlxG.save.data.upUIBind == null)
		{
			FlxG.save.data.upUIBind = "W";
			trace("No UP");
		}
		if (FlxG.save.data.downUIBind == null)
		{
			FlxG.save.data.downUIBind = "S";
			trace("No DOWN");
		}
		if (FlxG.save.data.leftUIBind == null)
		{
			FlxG.save.data.leftUIBind = "A";
			trace("No LEFT");
		}
		if (FlxG.save.data.rightUIBind == null)
		{
			FlxG.save.data.rightUIBind = "D";
			trace("No RIGHT");
		}

		if (FlxG.save.data.upUIBind2 == null)
		{
			FlxG.save.data.upUIBind2 = "UP";
			trace("No UP");
		}
		if (FlxG.save.data.downUIBind2 == null)
		{
			FlxG.save.data.downUIBind2 = "DOWN";
			trace("No DOWN");
		}
		if (FlxG.save.data.leftUIBind2 == null)
		{
			FlxG.save.data.leftUIBind2 = "LEFT";
			trace("No LEFT");
		}
		if (FlxG.save.data.rightUIBind2 == null)
		{
			FlxG.save.data.rightUIBind2 = "RIGHT";
			trace("No RIGHT");
		}
		if (FlxG.save.data.acceptBind == null)
		{
			FlxG.save.data.acceptBind = "Z";
			trace("No RIGHT");
		}
		if (FlxG.save.data.acceptBind2 == null)
		{
			FlxG.save.data.acceptBind2 = "SPACE";
			trace("No RIGHT");
		}
		if (FlxG.save.data.backBind == null)
		{
			FlxG.save.data.backBind = "X";
			trace("No RIGHT");
		}
		if (FlxG.save.data.backBind2 == null)
		{
			FlxG.save.data.backBind2 = "BACKSPACE";
			trace("No RIGHT");
		}
		if (FlxG.save.data.pauseBind == null)
		{
			FlxG.save.data.pauseBind = "P";
			trace("No RIGHT");
		}
		if (FlxG.save.data.pauseBind2 == null)
		{
			FlxG.save.data.pauseBind2 = "ENTER";
			trace("No RIGHT");
		}

		if (FlxG.save.data.gpupBind == null)
		{
			FlxG.save.data.gpupBind = "DPAD_UP";
			trace("No GUP");
		}
		if (FlxG.save.data.gpdownBind == null)
		{
			FlxG.save.data.gpdownBind = "DPAD_DOWN";
			trace("No GDOWN");
		}
		if (FlxG.save.data.gpleftBind == null)
		{
			FlxG.save.data.gpleftBind = "DPAD_LEFT";
			trace("No GLEFT");
		}
		if (FlxG.save.data.gprightBind == null)
		{
			FlxG.save.data.gprightBind = "DPAD_RIGHT";
			trace("No GRIGHT");
		}
		if (FlxG.save.data.gpupUIBind == null)
		{
			FlxG.save.data.gpupUIBind = "DPAD_UP";
			trace("No GUP");
		}
		if (FlxG.save.data.gpdownUIBind == null)
		{
			FlxG.save.data.gpdownUIBind = "DPAD_DOWN";
			trace("No GDOWN");
		}
		if (FlxG.save.data.gpleftUIBind == null)
		{
			FlxG.save.data.gpleftUIBind = "DPAD_LEFT";
			trace("No GLEFT");
		}
		if (FlxG.save.data.gprightUIBind == null)
		{
			FlxG.save.data.gprightUIBind = "DPAD_RIGHT";
			trace("No GRIGHT");
		}
		if (FlxG.save.data.gpacceptBind == null)
		{
			FlxG.save.data.gpacceptBind = "A";
			trace("No RIGHT");
		}
		if (FlxG.save.data.gpbackBind == null)
		{
			FlxG.save.data.gpbackBind = "B";
			trace("No RIGHT");
		}
		if (FlxG.save.data.gppauseBind == null)
		{
			FlxG.save.data.gppauseBind = "START";
			trace("No RIGHT");
		}

		if (FlxG.save.data.killBind == null)
		{
			FlxG.save.data.killBind = "R";
			trace("No KILL");
		}

		trace('${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}');
	}
}
