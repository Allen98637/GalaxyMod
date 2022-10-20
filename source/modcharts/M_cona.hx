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

class M_cona
{
	public static function pos(daNote:Note, strumLine:FlxSprite)
	{
		if (daNote.strumTime >= 15000 && daNote.strumTime < 21562)
		{
			if (Conductor.songPosition < 15000)
			{
				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y
						+ (15000 - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						+ (Conductor.songPosition - 15000) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				else
					daNote.y = (strumLine.y
						- (15000 - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						- (Conductor.songPosition - 15000) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
			}
			else
			{
				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
			}
			if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
			{
				daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed / 1.5;
				daNote.updateHitbox();
			}
		}
		else if (daNote.strumTime >= 22500 && daNote.strumTime < 26016)
		{
			if (Conductor.songPosition < 22500)
			{
				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y
						+ (22500 - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						+ (Conductor.songPosition - 22500) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				else
					daNote.y = (strumLine.y
						- (22500 - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						- (Conductor.songPosition - 22500) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
			}
			else
			{
				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
			}
			if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
			{
				daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed / 1.5;
				daNote.updateHitbox();
			}
		}
		else if ((daNote.strumTime >= 45000 && daNote.strumTime < 59766)
			|| (daNote.strumTime >= 45000 && daNote.strumTime < 65625.0 && daNote.mustPress))
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 60000 && daNote.strumTime < 74766)
		{
			if (!daNote.mustPress)
			{
				switch (daNote.noteData)
				{
					case 0:
						daNote.x = (218 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 300;
						if (daNote.x > 500)
							daNote.alpha = (550 - daNote.x) / 50;
						else
							daNote.alpha = 1;
					case 1:
						daNote.x = 218;
						daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					case 2:
						daNote.x = 218;
						daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					case 3:
						daNote.x = (218 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 300;
						if (daNote.x > 500)
							daNote.alpha = (550 - daNote.x) / 50;
						else
							daNote.alpha = 1;
				}
			}
			else
			{
				switch (daNote.noteData)
				{
					case 0:
						daNote.x = (858 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 300;
						if (daNote.x < 570)
							daNote.alpha = (daNote.x - 520) / 50;
						else
							daNote.alpha = 1;
					case 1:
						daNote.x = 858;
						daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					case 2:
						daNote.x = 858;
						daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					case 3:
						daNote.x = (858 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
						daNote.y = 300;
						if (daNote.x < 570)
							daNote.alpha = (daNote.x - 520) / 50;
						else
							daNote.alpha = 1;
				}
			}
		}
		else if (daNote.strumTime >= 90000 && daNote.strumTime < 120000)
		{
			if (FlxG.save.data.downscroll)
			{
				if ((Std.int((daNote.strumTime - 90000) / 7500) % 2 == 0 && daNote.mustPress)
					|| Std.int((daNote.strumTime - 90000) / 7500) % 2 == 1
					&& !daNote.mustPress)
				{
					if (daNote.mustPress)
						daNote.y = (PlayMoving.ylist[0]
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = (PlayMoving.ylist[1]
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
				else
				{
					if (daNote.mustPress)
						daNote.y = (PlayMoving.ylist[0]
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = (PlayMoving.ylist[1]
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
			}
			else
			{
				if ((Std.int((daNote.strumTime - 90000) / 7500) % 2 == 0 && daNote.mustPress)
					|| Std.int((daNote.strumTime - 90000) / 7500) % 2 == 1
					&& !daNote.mustPress)
				{
					if (daNote.mustPress)
						daNote.y = (PlayMoving.ylist[0]
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = (PlayMoving.ylist[1]
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
				else
				{
					if (daNote.mustPress)
						daNote.y = (PlayMoving.ylist[0]
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = (PlayMoving.ylist[1]
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
			}
		}
		else if (daNote.strumTime >= 120000)
		{
			if (daNote.mustPress)
			{
				daNote.x = PlayMoving.pxlist[daNote.noteData];
				if (FlxG.save.data.downscroll)
					daNote.y = (PlayMoving.ylist[0] + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (PlayMoving.ylist[0] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				if (daNote.isSustainNote)
					daNote.x += daNote.width;
			}
			else
			{
				daNote.x = PlayMoving.xlist[daNote.noteData];
				if (FlxG.save.data.downscroll)
					daNote.y = (PlayMoving.ylist[1] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (PlayMoving.ylist[1] + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				if (daNote.isSustainNote)
					daNote.x += daNote.width;
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

	public static function spos(dastrum:NoteStrum, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 30000 && Conductor.songPosition < 45000)
		{
			if (FlxG.save.data.downscroll)
			{
				if (Std.int((Conductor.songPosition - 30000) / 937.5) % 2 == 0)
					dastrum.y = 550 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				else
					dastrum.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
			}
			else
			{
				if (Std.int((Conductor.songPosition - 30000) / 937.5) % 2 == 0)
					dastrum.y = 50 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				else
					dastrum.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
			}
			strumLine.y = dastrum.y;
		}
		else if (Conductor.songPosition >= 45000 && Conductor.songPosition < 59531.25)
		{
			switch (Std.int((Conductor.songPosition - 30000) / 937.5) % 4)
			{
				case 0:
					if (dastrum.ID % 2 == 0)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
						else
							dastrum.y = 50 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					}
				case 1:
					if (dastrum.ID % 2 == 0)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
						else
							dastrum.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					}
				case 2:
					if (dastrum.ID % 2 == 1)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
						else
							dastrum.y = 50 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					}
				case 3:
					if (dastrum.ID % 2 == 1)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
						else
							dastrum.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					}
			}
			PlayMoving.ylist[dastrum.ID] = dastrum.y;
		}
		else if (Conductor.songPosition >= 59531.25 && Conductor.songPosition < 73125)
		{
			if (Conductor.songPosition < 60000.0)
			{
				if (dastrum.x > 640)
				{
					if (dastrum.ID % 2 == 1)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
						else
							dastrum.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					}
					PlayMoving.ylist[dastrum.ID] = dastrum.y;
				}
				else
				{
					dastrum.x = PlayMoving.oxlist[dastrum.ID] - (Conductor.songPosition - 59531.25) / 468.75 * (PlayMoving.oxlist[dastrum.ID] - 218);
					if (FlxG.save.data.downscroll)
						dastrum.y = 550 - (Conductor.songPosition - 59531.25) / 468.75 * 250;
					else
						dastrum.y = 50 + (Conductor.songPosition - 59531.25) / 468.75 * 250;
				}
			}
			else if (Conductor.songPosition >= 63750.0 && Conductor.songPosition < 64218.75)
			{
				if (dastrum.x > 640)
				{
					dastrum.x = PlayMoving.poxlist[dastrum.ID] - (Conductor.songPosition - 63750.0) / 468.75 * (PlayMoving.poxlist[dastrum.ID] - 858);
					if (FlxG.save.data.downscroll)
						dastrum.y = 550 - (Conductor.songPosition - 63750.0) / 468.75 * 250;
					else
						dastrum.y = 50 + (Conductor.songPosition - 63750.0) / 468.75 * 250;
				}
			}
		}
		else if (Conductor.songPosition >= 74531.25 && Conductor.songPosition < 75468.75)
		{
			if (Conductor.songPosition < 75000.0)
			{
				if (dastrum.x < 640)
				{
					dastrum.x = 218 - (Conductor.songPosition - 74531.25) / 468.75 * (218 - PlayMoving.oxlist[dastrum.ID]);
					if (FlxG.save.data.downscroll)
						dastrum.y = 300 + (Conductor.songPosition - 74531.25) / 468.75 * 250;
					else
						dastrum.y = 300 - (Conductor.songPosition - 74531.25) / 468.75 * 250;
				}
			}
			else if (Conductor.songPosition >= 75000.0 && Conductor.songPosition < 75468.75)
			{
				if (dastrum.x > 640)
				{
					dastrum.x = 858 + (Conductor.songPosition - 75000.0) / 468.75 * (PlayMoving.poxlist[dastrum.ID] - 858);
					if (FlxG.save.data.downscroll)
						dastrum.y = 300 + (Conductor.songPosition - 75000.0) / 468.75 * 250;
					else
						dastrum.y = 300 - (Conductor.songPosition - 75000.0) / 468.75 * 250;
				}
			}
		}
		else if (Conductor.songPosition >= 89531.25 && Conductor.songPosition < 90000)
		{
			if (dastrum.x < 640)
			{
				if (FlxG.save.data.downscroll)
					dastrum.y = 550 - (Conductor.songPosition - 89531.25) / 468.75 * 500;
				else
					dastrum.y = 50 + (Conductor.songPosition - 89531.25) / 468.75 * 500;
			}
		}
		else if (Conductor.songPosition >= 90000 && Conductor.songPosition < 120000)
		{
			if (FlxG.save.data.downscroll)
			{
				if ((Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 0 && dastrum.x > 640)
					|| Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 1
					&& dastrum.x < 640)
				{
					if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
						dastrum.y = 550 - ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
					else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
						dastrum.y = 550 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
					else
						dastrum.y = 350 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				}
				else
				{
					if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
						dastrum.y = 50 + ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
					else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
						dastrum.y = 50 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
					else
						dastrum.y = 250 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				}
			}
			else
			{
				if ((Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 0 && dastrum.x > 640)
					|| Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 1
					&& dastrum.x < 640)
				{
					if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
						dastrum.y = 50 + ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
					else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
						dastrum.y = 50 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
					else
						dastrum.y = 250 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				}
				else
				{
					if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
						dastrum.y = 550 - ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
					else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
						dastrum.y = 550 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
					else
						dastrum.y = 350 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				}
			}
			if (dastrum.x < 640)
				PlayMoving.ylist[1] = dastrum.y;
			else
				PlayMoving.ylist[0] = dastrum.y;
		}
		else if (Conductor.songPosition >= 120000 && Conductor.songPosition < 120937.5)
		{
			if (dastrum.x > 472 + dastrum.ID * 112)
			{
				dastrum.x = PlayMoving.poxlist[dastrum.ID]
					+ ((Conductor.songPosition - 120000) % 937.5) / 937.5 * (472 + dastrum.ID * 112 - PlayMoving.poxlist[dastrum.ID]);
				if (FlxG.save.data.downscroll)
					dastrum.y = 550 - ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				else
					dastrum.y = 50 + ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				PlayMoving.ylist[0] = dastrum.y;
				PlayMoving.pxlist[dastrum.ID] = dastrum.x;
			}
			else
			{
				dastrum.x = PlayMoving.oxlist[dastrum.ID]
					+ ((Conductor.songPosition - 120000) % 937.5) / 937.5 * (472 + dastrum.ID * 112 - PlayMoving.oxlist[dastrum.ID]);
				if (FlxG.save.data.downscroll)
					dastrum.y = 50 + ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				else
					dastrum.y = 550 - ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				PlayMoving.ylist[1] = dastrum.y;
				PlayMoving.xlist[dastrum.ID] = dastrum.x;
			}
		}
		else if (Conductor.songPosition >= 120937.5)
		{
			dastrum.x = 472 + dastrum.ID * 112;
			dastrum.y = 300;
			PlayMoving.ylist[0] = dastrum.y;
			PlayMoving.pxlist[dastrum.ID] = dastrum.x;
			PlayMoving.ylist[1] = dastrum.y;
			PlayMoving.xlist[dastrum.ID] = dastrum.x;
		}
	}

	inline static public function kill(daNote:Note):Bool
	{
		if (daNote.strumTime >= 60000 && daNote.strumTime < 74766)
			return ((daNote.x < -daNote.width)
				|| (daNote.x > FlxG.width)
				|| (daNote.y < -daNote.height)
				|| (daNote.y > FlxG.height)
				|| (daNote.alpha <= 0))
				&& Conductor.songPosition > daNote.strumTime;
		else if (daNote.strumTime >= 90000)
			return ((daNote.y < -daNote.height) || (daNote.y > FlxG.height)) && daNote.tooLate;
		else
		{
			if (FlxG.save.data.downscroll)
				return daNote.y > FlxG.height;
			else
				return daNote.y < -daNote.height;
		}
	}

	inline static public function ups(daNote:Note, strumLine:FlxSprite)
	{
		if (daNote.strumTime >= 90000 && daNote.strumTime < 120000)
		{
			if (FlxG.save.data.downscroll)
			{
				if ((Std.int((daNote.strumTime - 90000) / 7500) % 2 == 0 && daNote.mustPress)
					|| Std.int((daNote.strumTime - 90000) / 7500) % 2 == 1
					&& !daNote.mustPress)
				{
					daNote.angle = 180;
					return 1;
				}
				else
				{
					daNote.angle = 0;
					return 2;
				}
			}
			else
			{
				if ((Std.int((daNote.strumTime - 90000) / 7500) % 2 == 0 && daNote.mustPress)
					|| Std.int((daNote.strumTime - 90000) / 7500) % 2 == 1
					&& !daNote.mustPress)
				{
					daNote.angle = 0;
					return 2;
				}
				else
				{
					daNote.angle = 180;
					return 1;
				}
			}
		}
		else if (daNote.strumTime > 120000)
		{
			if (FlxG.save.data.downscroll)
			{
				if (daNote.mustPress)
				{
					daNote.angle = 180;
					return 1;
				}
				else
				{
					daNote.angle = 0;
					return 2;
				}
			}
			else
			{
				if (daNote.mustPress)
				{
					daNote.angle = 0;
					return 2;
				}
				else
				{
					daNote.angle = 180;
					return 1;
				}
			}
		}
		else
		{
			if (FlxG.save.data.downscroll)
			{
				daNote.angle = 180;
				return 1;
			}
			else
			{
				daNote.angle = 0;
				return 2;
			}
		}
	}

	inline static public function stry(daNote:Note, strumLine:FlxSprite)
	{
		if ((daNote.strumTime >= 45000 && daNote.strumTime < 59766)
			|| (daNote.strumTime >= 45000 && daNote.strumTime < 65625.0 && daNote.mustPress))
			return PlayMoving.ylist[daNote.noteData];
		else if (daNote.strumTime >= 90000)
		{
			if (daNote.mustPress)
				return PlayMoving.ylist[0];
			else
				return PlayMoving.ylist[1];
		}
		else
			return strumLine.y;
	}
}
