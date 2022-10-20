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

class M_familanna
{
	public static var cent:Array<Float> = [0, 0];

	public static function reset()
	{
		cent = [0, 0];
	}

	public static function pos(daNote:Note, strumLine:FlxSprite)
	{
		if (daNote.strumTime > 20983 && daNote.strumTime < 31388)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime > 115409 && daNote.strumTime < 157296)
		{
			if (FlxG.save.data.downscroll)
			{
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.2, 2)));
				if (daNote.mustPress)
					daNote.x = PlayMoving.poxlist[daNote.noteData]
						- ((daNote.y - 550) / (-daNote.height - 550)) * (PlayMoving.poxlist[daNote.noteData] - PlayMoving.oxlist[daNote.noteData]);
				else
					daNote.x = PlayMoving.oxlist[daNote.noteData]
						- ((daNote.y - 550) / (-daNote.height - 550)) * (PlayMoving.oxlist[daNote.noteData] - PlayMoving.poxlist[daNote.noteData]);
			}
			else
			{
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.2, 2)));
				if (daNote.mustPress)
					daNote.x = PlayMoving.poxlist[daNote.noteData]
						- ((daNote.y - 50) / (FlxG.height - 50)) * (PlayMoving.poxlist[daNote.noteData] - PlayMoving.oxlist[daNote.noteData]);
				else
					daNote.x = PlayMoving.oxlist[daNote.noteData]
						- ((daNote.y - 50) / (FlxG.height - 50)) * (PlayMoving.oxlist[daNote.noteData] - PlayMoving.poxlist[daNote.noteData]);
			}
		}
		else if (daNote.strumTime > 73442 && daNote.strumTime < 83847)
		{
			if (daNote.mustPress)
			{
				switch (daNote.noteData)
				{
					case 0:
						daNote.x = (584 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 468;
					case 1:
						daNote.x = (584 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 356;
					case 2:
						daNote.x = (696 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 356;
					case 3:
						daNote.x = (696 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 468;
				}
			}
			else
			{
				switch (daNote.noteData)
				{
					case 0:
						daNote.x = (584 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 162;
					case 1:
						daNote.x = (584 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 50;
					case 2:
						daNote.x = (696 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 50;
					case 3:
						daNote.x = (696 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 162;
				}
			}
		}
		else if (daNote.strumTime >= 104918.0327868854 && daNote.strumTime < 107540.98360655754)
		{
			if (FlxG.save.data.downscroll)
				cent = [
					218,
					FlxMath.lerp(550, 300, (daNote.strumTime - 104918.0327868854) / 2622.95081967)
				];
			else
				cent = [
					218,
					FlxMath.lerp(50, 300, (daNote.strumTime - 104918.0327868854) / 2622.95081967)
				];
			daNote.x = cent[0] + (daNote.noteData - 1.5) * 112 * FlxMath.fastCos(daNote.strumTime * 3.1415926 / 163.93442623);
			daNote.y = cent[1] + (1.5 - daNote.noteData) * 112 * FlxMath.fastSin(daNote.strumTime * 3.1415926 / 163.93442623);
		}
		else if (daNote.strumTime >= 107540.98360655754 && daNote.strumTime < 108852.45901639361)
		{
			cent = [
				FlxMath.lerp(218, 1000, (daNote.strumTime - 107540.98360655754) / 1311.47540983),
				300
			];
			daNote.x = cent[0] + (daNote.noteData - 1.5) * 112 * FlxMath.fastCos(daNote.strumTime * 3.1415926 / 163.93442623);
			daNote.y = cent[1] + (1.5 - daNote.noteData) * 112 * FlxMath.fastSin(daNote.strumTime * 3.1415926 / 163.93442623);
		}
		else if (daNote.strumTime >= 108852.45901639361 && daNote.strumTime < 109508.19672131164)
		{
			cent = [
				FlxMath.lerp(1000, 218, (daNote.strumTime - 108852.45901639361) / 655.737704917),
				300
			];
			daNote.x = cent[0] + (daNote.noteData - 1.5) * 112 * FlxMath.fastCos(daNote.strumTime * 3.1415926 / 163.93442623);
			daNote.y = cent[1] + (1.5 - daNote.noteData) * 112 * FlxMath.fastSin(daNote.strumTime * 3.1415926 / 163.93442623);
		}
		else if (daNote.strumTime >= 109508.19672131164 && daNote.strumTime < 110163.93442622968)
		{
			cent = [
				FlxMath.lerp(218, 1000, (daNote.strumTime - 109508.19672131164) / 655.737704917),
				300
			];
			daNote.x = cent[0] + (daNote.noteData - 1.5) * 112 * FlxMath.fastCos(daNote.strumTime * 3.1415926 / 163.93442623);
			daNote.y = cent[1] + (1.5 - daNote.noteData) * 112 * FlxMath.fastSin(daNote.strumTime * 3.1415926 / 163.93442623);
		}
		else if (daNote.strumTime >= 110163.93442622968 && daNote.strumTime < 112786.88524590182)
		{
			if (FlxG.save.data.downscroll)
				cent = [
					FlxMath.lerp(1000, 218, (daNote.strumTime - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 50, (daNote.strumTime - 110163.93442622968) / 2622.95081967)
				];
			else
				cent = [
					FlxMath.lerp(1000, 218, (daNote.strumTime - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 550, (daNote.strumTime - 110163.93442622968) / 2622.95081967)
				];
			daNote.x = cent[0] + (daNote.noteData - 1.5) * 112 * FlxMath.fastCos(daNote.strumTime * 3.1415926 / 163.93442623);
			daNote.y = cent[1] + (1.5 - daNote.noteData) * 112 * FlxMath.fastSin(daNote.strumTime * 3.1415926 / 163.93442623);
		}
		else if (daNote.strumTime >= 112786.88524590182 && daNote.strumTime < 115409.836066)
		{
			if (FlxG.save.data.downscroll)
				cent = [
					218,
					FlxMath.lerp(50, 550, (daNote.strumTime - 112786.88524590182) / 2622.95081967)
				];
			else
				cent = [
					218,
					FlxMath.lerp(550, 50, (daNote.strumTime - 112786.88524590182) / 2622.95081967)
				];
			daNote.x = cent[0] + (daNote.noteData - 1.5) * 112 * FlxMath.fastCos(daNote.strumTime * 3.1415926 / 163.93442623);
			daNote.y = cent[1] + (1.5 - daNote.noteData) * 112 * FlxMath.fastSin(daNote.strumTime * 3.1415926 / 163.93442623);
		}
		else if (daNote.strumTime >= 83934 && daNote.strumTime < 94426)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 94426 && daNote.strumTime < 104918)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			if (daNote.mustPress)
				daNote.x = PlayMoving.pxlist[daNote.noteData];
			else
				daNote.x = PlayMoving.xlist[daNote.noteData];
			if (daNote.isSustainNote)
				daNote.x += daNote.width;
		}
		else if (daNote.strumTime >= 157377 && daNote.strumTime < 178274)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 188852 && daNote.strumTime < 199257)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			if (daNote.mustPress)
				daNote.x = PlayMoving.pxlist[daNote.noteData];
			else
				daNote.x = PlayMoving.xlist[daNote.noteData];
		}
		else if (daNote.strumTime >= 199344 && daNote.strumTime < 209755)
		{
			if (PlayMoving.sy > 300)
				daNote.y = (PlayMoving.sy + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (PlayMoving.sy - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 209836 && daNote.strumTime < 220164)
		{
			if (daNote.mustPress)
			{
				if (FlxG.save.data.downscroll)
					daNote.y = (PlayMoving.pylist[daNote.noteData]
						+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (PlayMoving.pylist[daNote.noteData]
						- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			}
			else
			{
				if (FlxG.save.data.downscroll)
					daNote.y = (PlayMoving.ylist[daNote.noteData]
						+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (PlayMoving.ylist[daNote.noteData]
						- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			}
		}
		else if (daNote.strumTime >= 220327 && daNote.strumTime < 241230)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(3, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(3, 2)));
		}
		else
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
	}

	public static function spos(dastrum:NoteStrum, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 20655.737704918025 && Conductor.songPosition < 20819.672131147534)
		{
			if (dastrum.x < 640)
			{
				if (FlxG.save.data.downscroll)
					dastrum.y = 550 - (Conductor.songPosition - 20655.737704918025) / 163.93442623 * (FlxG.height - 550);
				else
					dastrum.y = 50 - (Conductor.songPosition - 20655.737704918025) / 163.93442623 * (dastrum.height - 50);
			}
		}
		else if (Conductor.songPosition >= 20819.672131147534 && Conductor.songPosition < 20983.60655737704)
		{
			if (dastrum.x < 640)
			{
				if (FlxG.save.data.downscroll)
					dastrum.y = dastrum.height - (Conductor.songPosition - 20819.672131147534) / 163.93442623 * (dastrum.height - 50);
				else
					dastrum.y = FlxG.height - (Conductor.songPosition - 20819.672131147534) / 163.93442623 * (FlxG.height - 550);
			}
		}
		else if (Conductor.songPosition >= 20983.60655737704 && Conductor.songPosition < 21147.54098360655)
		{
			if (dastrum.x > 640)
			{
				if (FlxG.save.data.downscroll)
					dastrum.y = 550 - (Conductor.songPosition - 20983.60655737704) / 163.93442623 * (FlxG.height - 550);
				else
					dastrum.y = 50 - (Conductor.songPosition - 20983.60655737704) / 163.93442623 * (dastrum.height - 50);
			}
		}
		else if (Conductor.songPosition >= 21147.54098360655 && Conductor.songPosition < 21311.475409836057)
		{
			if (dastrum.x > 640)
			{
				if (FlxG.save.data.downscroll)
					dastrum.y = dastrum.height - (Conductor.songPosition - 21147.54098360655) / 163.93442623 * (dastrum.height - 50);
				else
					dastrum.y = FlxG.height - (Conductor.songPosition - 21147.54098360655) / 163.93442623 * (FlxG.height - 550);
			}
		}
		else if (Conductor.songPosition >= 31475.409836065555 && Conductor.songPosition < 31576)
		{
			if (FlxG.save.data.downscroll)
				dastrum.y = 550;
			else
				dastrum.y = 50;
		}
		else if (Conductor.songPosition >= 73442.62295081967 && Conductor.songPosition < 74442.62295081967)
		{
			switch (dastrum.ID)
			{
				case 0:
					dastrum.x = 584;
					dastrum.y = 162;
				case 1:
					dastrum.x = 584;
					dastrum.y = 50;
				case 2:
					dastrum.x = 696;
					dastrum.y = 50;
				case 3:
					dastrum.x = 696;
					dastrum.y = 162;
			}
		}
		else if (Conductor.songPosition >= 104918.0327868854 && Conductor.songPosition < 107540.98360655754)
		{
			if (FlxG.save.data.downscroll)
				cent = [
					218,
					FlxMath.lerp(550, 300, (Conductor.songPosition - 104918.0327868854) / 2622.95081967)
				];
			else
				cent = [
					218,
					FlxMath.lerp(50, 300, (Conductor.songPosition - 104918.0327868854) / 2622.95081967)
				];
			dastrum.x = cent[0] + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 163.93442623);
			dastrum.y = cent[1] + (1.5 - dastrum.ID) * 112 * FlxMath.fastSin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 107540.98360655754 && Conductor.songPosition < 108852.45901639361)
		{
			cent = [
				FlxMath.lerp(218, 1000, (Conductor.songPosition - 107540.98360655754) / 1311.47540983),
				300
			];
			dastrum.x = cent[0] + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 163.93442623);
			dastrum.y = cent[1] + (1.5 - dastrum.ID) * 112 * FlxMath.fastSin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 108852.45901639361 && Conductor.songPosition < 109508.19672131164)
		{
			cent = [
				FlxMath.lerp(1000, 218, (Conductor.songPosition - 108852.45901639361) / 655.737704917),
				300
			];
			dastrum.x = cent[0] + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 163.93442623);
			dastrum.y = cent[1] + (1.5 - dastrum.ID) * 112 * FlxMath.fastSin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 109508.19672131164 && Conductor.songPosition < 110163.93442622968)
		{
			cent = [
				FlxMath.lerp(218, 1000, (Conductor.songPosition - 109508.19672131164) / 655.737704917),
				300
			];
			dastrum.x = cent[0] + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 163.93442623);
			dastrum.y = cent[1] + (1.5 - dastrum.ID) * 112 * FlxMath.fastSin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 110163.93442622968 && Conductor.songPosition < 112786.88524590182)
		{
			if (FlxG.save.data.downscroll)
				cent = [
					FlxMath.lerp(1000, 218, (Conductor.songPosition - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 50, (Conductor.songPosition - 110163.93442622968) / 2622.95081967)
				];
			else
				cent = [
					FlxMath.lerp(1000, 218, (Conductor.songPosition - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 550, (Conductor.songPosition - 110163.93442622968) / 2622.95081967)
				];
			dastrum.x = cent[0] + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 163.93442623);
			dastrum.y = cent[1] + (1.5 - dastrum.ID) * 112 * FlxMath.fastSin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 112786.88524590182 && Conductor.songPosition < 115409.836066)
		{
			if (FlxG.save.data.downscroll)
				cent = [
					218,
					FlxMath.lerp(50, 550, (Conductor.songPosition - 112786.88524590182) / 2622.95081967)
				];
			else
				cent = [
					218,
					FlxMath.lerp(550, 50, (Conductor.songPosition - 112786.88524590182) / 2622.95081967)
				];
			dastrum.x = cent[0] + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 163.93442623);
			dastrum.y = cent[1] + (1.5 - dastrum.ID) * 112 * FlxMath.fastSin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 83934.42622950824 && Conductor.songPosition < 94426.22950819682)
		{
			dastrum.x = PlayMoving.oxlist[dastrum.ID];
			if (FlxG.save.data.downscroll)
				dastrum.y = 550 - 30 * (dastrum.ID);
			else
				dastrum.y = 50 + 30 * (dastrum.ID);
			PlayMoving.ylist[dastrum.ID] = dastrum.y;
		}
		else if (Conductor.songPosition >= 94426.22950819682 && Conductor.songPosition < 104918.0327868854)
		{
			if (Conductor.songPosition < 94508.19672131157)
			{
				if (FlxG.save.data.downscroll)
					dastrum.y = FlxMath.lerp(550 - 30 * (dastrum.ID), 550, (Conductor.songPosition - 94426.22950819682) / 81.9672131148);
				else
					dastrum.y = FlxMath.lerp(50 + 30 * (dastrum.ID), 50, (Conductor.songPosition - 94426.22950819682) / 81.9672131148);
			}
			else
				dastrum.y = strumLine.y;
			if (dastrum.x < 640)
			{
				dastrum.x = 218 + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 655.73770492);
				PlayMoving.xlist[dastrum.ID] = dastrum.x;
			}
			else
			{
				dastrum.x = 858 + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 655.73770492);
				PlayMoving.pxlist[dastrum.ID] = dastrum.x;
			}
		}
		else if (Conductor.songPosition >= 115409.83606557397 && Conductor.songPosition < 115509.83606557397)
		{
			if (dastrum.x < 640)
				dastrum.x = PlayMoving.oxlist[dastrum.ID];
			else
				dastrum.x = PlayMoving.poxlist[dastrum.ID];
			dastrum.y = strumLine.y;
		}
		else if (Conductor.songPosition >= 157377.04918032826 && Conductor.songPosition < 178273.22404371633)
		{
			if (FlxG.save.data.downscroll)
				dastrum.y = FlxMath.lerp(550, 550 - 30 * (dastrum.ID), (Conductor.songPosition % 1311.47540984) / 1311.47540984);
			else
				dastrum.y = FlxMath.lerp(50, 50 + 30 * (dastrum.ID), (Conductor.songPosition % 1311.47540984) / 1311.47540984);
			PlayMoving.ylist[dastrum.ID] = dastrum.y;
		}
		else if (Conductor.songPosition >= 178360.6557377054 && Conductor.songPosition < 178460.6557377054)
		{
			if (FlxG.save.data.downscroll)
				dastrum.y = 550;
			else
				dastrum.y = 50;
			PlayMoving.ylist[dastrum.ID] = dastrum.y;
		}
		else if (Conductor.songPosition >= 188852.459016394 && Conductor.songPosition < 199344.26229508256)
		{
			if (dastrum.x < 640)
			{
				dastrum.x = 50 + 56 * dastrum.ID * (FlxMath.fastCos(Conductor.songPosition / 1311.47540984 * 3.1415926) + 1);
				PlayMoving.xlist[dastrum.ID] = dastrum.x;
			}
			else
			{
				dastrum.x = 1026 - 56 * (3 - dastrum.ID) * (FlxMath.fastCos(Conductor.songPosition / 1311.47540984 * 3.1415926) + 1);
				PlayMoving.pxlist[dastrum.ID] = dastrum.x;
			}
		}
		else if (Conductor.songPosition >= 199344.26229508256 && Conductor.songPosition < 209836.065574)
		{
			if (Conductor.songPosition >= 204590.16393442685 && Conductor.songPosition < 204640.16393442685)
			{
				if (FlxG.save.data.downscroll)
					PlayMoving.sy = 550;
				else
					PlayMoving.sy = 50;
			}
			if (Conductor.songPosition >= 207213.114754099 && Conductor.songPosition < 207263.114754099)
			{
				if (FlxG.save.data.downscroll)
					PlayMoving.sy = 550;
				else
					PlayMoving.sy = 50;
			}
			if (dastrum.x < 640)
				dastrum.x = PlayMoving.oxlist[dastrum.ID];
			else
				dastrum.x = PlayMoving.poxlist[dastrum.ID];
			dastrum.y = PlayMoving.sy;
		}
		else if (Conductor.songPosition >= 209836.065574 && Conductor.songPosition < 220327.868852)
		{
			if (dastrum.x < 640)
				dastrum.y = PlayMoving.ylist[dastrum.ID];
			else
				dastrum.y = PlayMoving.pylist[dastrum.ID];
		}
		else if (Conductor.songPosition >= 220327.8688524597 && Conductor.songPosition < 241229.5081967221)
		{
			if (FlxG.save.data.downscroll)
				dastrum.y = 550;
			else
				dastrum.y = 50;
		}
	}

	public static function pspos(dastrum:NoteStrum, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 73442.62295081967 && Conductor.songPosition < 74442.62295081967)
		{
			switch (dastrum.ID)
			{
				case 0:
					dastrum.x = 584;
					dastrum.y = 468;
				case 1:
					dastrum.x = 584;
					dastrum.y = 356;
				case 2:
					dastrum.x = 696;
					dastrum.y = 356;
				case 3:
					dastrum.x = 696;
					dastrum.y = 468;
			}
		}
		else if (Conductor.songPosition >= 83934.42622950824 && Conductor.songPosition < 94426.22950819682)
		{
			dastrum.x = PlayMoving.poxlist[dastrum.ID];
		}
		else if (Conductor.songPosition >= 104918.0327868854 && Conductor.songPosition < 115409.836066)
		{
			dastrum.x = 858 + (dastrum.ID - 1.5) * 112 * FlxMath.fastCos(Conductor.songPosition * 3.1415926 / 163.93442623);
			dastrum.y = strumLine.y + (1.5 - dastrum.ID) * 112 * FlxMath.fastSin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
	}

	public static function ongood(daNote:Note):Void
	{
		if (daNote.strumTime >= 199344 && daNote.strumTime < 204427)
		{
			PlayMoving.sy = 600 - PlayMoving.sy;
		}
		else if (daNote.strumTime >= 204590 && daNote.strumTime < 209755)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.sy -= 5;
			else
				PlayMoving.sy += 5;
		}
		else if (daNote.strumTime >= 209836 && daNote.strumTime < 220164)
		{
			if (FlxG.save.data.downscroll)
			{
				if (daNote.mustPress)
					PlayMoving.pylist[daNote.noteData] -= 30;
				else
					PlayMoving.ylist[daNote.noteData] -= 30;
			}
			else
			{
				if (daNote.mustPress)
					PlayMoving.pylist[daNote.noteData] += 30;
				else
					PlayMoving.ylist[daNote.noteData] += 30;
			}
		}
	}

	inline static public function show(daNote:Note):Bool
	{
		if (daNote.strumTime > 20983 && daNote.strumTime < 31388)
		{
			if (FlxG.save.data.downscroll)
				return daNote.y > FlxG.height;
			else
				return daNote.y < -daNote.height;
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return daNote.y < -daNote.height;
			else
				return daNote.y > FlxG.height;
		}
	}

	inline static public function kill(daNote:Note):Bool
	{
		if (daNote.strumTime > 20983 && daNote.strumTime < 31388)
		{
			if (FlxG.save.data.downscroll)
				return daNote.y < -daNote.height;
			else
				return daNote.y > FlxG.height;
		}
		else if (daNote.strumTime > 73442 && daNote.strumTime < 83847)
		{
			return (daNote.x > FlxG.width || daNote.x < -daNote.width) && Conductor.songPosition > daNote.strumTime;
		}
		else if (daNote.strumTime >= 199344 && daNote.strumTime < 220164)
		{
			return Conductor.songPosition > daNote.strumTime + 1000 / 6;
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return daNote.y > FlxG.height;
			else
				return daNote.y < -daNote.height;
		}
	}
}
