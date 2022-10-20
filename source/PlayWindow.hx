package;

import Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import haxe.Exception;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class PlayWindow
{
	public static var res:Array<Int> = [0, 0, 0, 0];
	public static var stage:Array<Int> = [0, 0];
	public static var pos:Array<Int> = [0, 0];
	public static var camz:Float = 1;

	public static function nreset()
	{
		pos = [0, 0];
		camz = 1;
		modcharts.M_cyber.nreset();
	}

	public static function reset()
	{
		if (!FlxG.fullscreen)
		{
			res = [
				Lib.application.window.x,
				Lib.application.window.y,
				Lib.application.window.width,
				Lib.application.window.height
			];
		}
		stage = [Std.int(Capabilities.screenResolutionX), Std.int(Capabilities.screenResolutionY)];
		FlxG.scaleMode = new RatioScaleMode();
	}

	public static function back(camHUD:FlxCamera)
	{
		Lib.application.window.move(res[0], res[1]);
		Lib.application.window.resize(res[2], res[3]);
		camHUD.zoom = 1;
		camHUD.x = 0;
		camz = 1;
		FlxG.scaleMode = new RatioScaleMode();
	}

	public static function move(camHUD:FlxCamera)
	{
		if (PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_cyber.move(camHUD);
		}
	}
}
