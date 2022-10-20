package modcharts;

import Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import haxe.Exception;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class M_galaxy
{
	public static function pos(daNote:Note, strumLine:FlxSprite)
	{
		if ((daNote.strumTime > 12387 && daNote.strumTime < 24581)
			|| (daNote.strumTime > 38709 && daNote.strumTime < 41613)
			|| (!daNote.isSustainNote
				&& daNote.strumTime > 49548
				&& daNote.strumTime < 74232
				&& Std.int(FlxMath.roundDecimal((daNote.strumTime - 49548.387096774226) / 193.548387097, 0)) % 2 == 1)
			|| (Std.int(daNote.strumTime) == 81677 || Std.int(daNote.strumTime) == 83225)
			|| (daNote.strumTime > 84387 && daNote.strumTime < 84968)
			|| (daNote.strumTime > 85935 && daNote.strumTime < 86517)
			|| (daNote.strumTime > 99096 && daNote.strumTime < 111291))
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(0.8, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(0.8, 2)));
		}
		else if ((daNote.strumTime > 37161 && daNote.strumTime < 38517) || (daNote.strumTime > 41806 && daNote.strumTime < 43162))
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(2, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(2, 2)));
		}
		else if ((daNote.strumTime > 43354 && daNote.strumTime < 49355)
			|| (daNote.strumTime > 74322 && daNote.strumTime < 77226)
			|| (daNote.strumTime > 77419 && daNote.strumTime < 78774 && !daNote.mustPress)
			|| (daNote.strumTime > 78967 && daNote.strumTime < 80323 && daNote.mustPress))
		{
			if (FlxG.save.data.downscroll)
			{
				if (Conductor.songPosition >= daNote.strumTime)
					daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (strumLine.y - (0.9 * (Conductor.songPosition - daNote.strumTime) * (Conductor.songPosition - daNote.strumTime) / 1000));
			}
			else
			{
				if (Conductor.songPosition >= daNote.strumTime)
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (strumLine.y + (0.9 * (Conductor.songPosition - daNote.strumTime) * (Conductor.songPosition - daNote.strumTime) / 1000));
			}
		}
		else
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
	}
}
