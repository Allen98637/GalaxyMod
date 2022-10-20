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

class M_game
{
	public static var times:Float = 0;
	public static var temp:Float = 0;
	public static var ptemp:Float = 0;

	public static function reset()
	{
		times = 0;
		temp = 0;
		ptemp = 0;
	}

	public static function pos(daNote:Note, strumLine:FlxSprite)
	{
		if (daNote.strumTime > 122553)
		{
			if (daNote.mustPress)
				daNote.x = PlayMoving.pxlist[daNote.noteData];
			else
				daNote.x = PlayMoving.xlist[daNote.noteData];
			if (daNote.isSustainNote)
				daNote.x += daNote.width;
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(1.5, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(1.5, 2)));
			if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
			{
				daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * 1.5;
				daNote.updateHitbox();
			}
		}
		else if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
		{
			if ((FlxG.save.data.downscroll && daNote.y <= strumLine.y)
				|| (!FlxG.save.data.downscroll && daNote.y >= strumLine.y)
				|| daNote.strumTime <= Conductor.songPosition)
			{
				if (daNote.mustPress)
					daNote.x = PlayMoving.pxlist[daNote.noteData];
				else
					daNote.x = PlayMoving.xlist[daNote.noteData];
			}
			else
			{
				if (daNote.mustPress)
					daNote.x = PlayMoving.pnlist[daNote.noteData];
				else
					daNote.x = PlayMoving.nlist[daNote.noteData];
			}
			if (daNote.isSustainNote)
				daNote.x += daNote.width;
			if (FlxG.save.data.downscroll)
				daNote.y = 700
					- 775 * (((daNote.strumTime - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
			else
				daNote.y = -75
					+ 775 * (((daNote.strumTime - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
			if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
			{
				daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * 1;
				daNote.updateHitbox();
			}
		}
		else if (daNote.strumTime > 44255 && daNote.strumTime < 47517)
		{
			if (2.7 + (2.7 / 1000) * (Conductor.songPosition - daNote.strumTime) > 0)
			{
				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y
						+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed * 1.5, 2))
						+ (1.35 * 0.45 * (Conductor.songPosition - daNote.strumTime) * (Conductor.songPosition - daNote.strumTime) / 1000));
				else
					daNote.y = (strumLine.y
						- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed * 1.5, 2))
						- (1.35 * 0.45 * (Conductor.songPosition - daNote.strumTime) * (Conductor.songPosition - daNote.strumTime) / 1000));
			}
			else
			{
				if (FlxG.save.data.downscroll)
					daNote.y = -500;
				else
					daNote.y = 1000;
			}
		}
		else if (daNote.strumTime > 26382 && daNote.strumTime < 44114)
		{
			daNote.y = (PlayMoving.sy
				- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(((300 - PlayMoving.sy) / 250) * PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime > 47659 && daNote.strumTime < 67944)
		{
			if (times == 1)
			{
				if (daNote.mustPress)
					daNote.x = PlayMoving.pxlist[daNote.noteData];
				else
					daNote.x = PlayMoving.xlist[daNote.noteData];
				if (daNote.isSustainNote)
					daNote.x += daNote.width;
			}
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
		{
			daNote.y = (PlayMoving.ylist[daNote.noteData]
				- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(((300 - PlayMoving.ylist[daNote.noteData]) / 250) * PlayState.SONG.speed,
					2)));
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
		if (Conductor.songPosition >= 122553.19148936185)
		{
			PlayMoving.xlist = [274, 50, 162, 386];
			PlayMoving.pxlist = [914, 690, 802, 1026];
			if (dastrum.x > 640)
				dastrum.x = PlayMoving.pxlist[dastrum.ID];
			else
				dastrum.x = PlayMoving.xlist[dastrum.ID];
			if (FlxG.save.data.downscroll)
				dastrum.y = 550;
			else
				dastrum.y = 50;
			strumLine.y = dastrum.y;
		}
		else if (Conductor.songPosition >= 95319.14893617031 && Conductor.songPosition < 122553.19148936185)
		{
			if ((Conductor.songPosition - 108936.17021276608) / (97021.27659574478 - 95319.14893617031) > times)
			{
				temp = PlayMoving.xlist[0];
				ptemp = PlayMoving.pxlist[0];
				PlayMoving.xlist[0] = PlayMoving.xlist[1];
				PlayMoving.xlist[1] = PlayMoving.xlist[2];
				PlayMoving.xlist[2] = PlayMoving.xlist[3];
				PlayMoving.xlist[3] = temp;
				PlayMoving.pxlist[0] = PlayMoving.pxlist[1];
				PlayMoving.pxlist[1] = PlayMoving.pxlist[2];
				PlayMoving.pxlist[2] = PlayMoving.pxlist[3];
				PlayMoving.pxlist[3] = ptemp;
				PlayMoving.nlist[0] = PlayMoving.xlist[1];
				PlayMoving.nlist[1] = PlayMoving.xlist[2];
				PlayMoving.nlist[2] = PlayMoving.xlist[3];
				PlayMoving.nlist[3] = PlayMoving.xlist[0];
				PlayMoving.pnlist[0] = PlayMoving.pxlist[1];
				PlayMoving.pnlist[1] = PlayMoving.pxlist[2];
				PlayMoving.pnlist[2] = PlayMoving.pxlist[3];
				PlayMoving.pnlist[3] = PlayMoving.pxlist[0];
				times += 1;
			}
			if (dastrum.x > 640)
				dastrum.x = PlayMoving.pxlist[dastrum.ID];
			else
				dastrum.x = PlayMoving.xlist[dastrum.ID];
			if (FlxG.save.data.downscroll)
				dastrum.y = 700
					- 775 * (((Conductor.songPosition - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
			else
				dastrum.y = -75
					+
					775 * (((Conductor.songPosition - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
			strumLine.y = dastrum.y;
		}
		else if (Conductor.songPosition >= 68085.10638297877 && Conductor.songPosition <= 95177.3049645391)
		{
			times = 0;
			if (dastrum.x > 640)
			{
				dastrum.x = PlayMoving.poxlist[dastrum.ID];
				PlayMoving.pxlist[dastrum.ID] = dastrum.x;
			}
			else
			{
				dastrum.x = PlayMoving.oxlist[dastrum.ID];
				PlayMoving.xlist[dastrum.ID] = dastrum.x;
			}
			switch (Std.int((Conductor.songPosition - 68085.10638297877) / (68510.63829787239 - 68085.10638297877)) % 8)
			{
				case 0:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550
								- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						else
							dastrum.y = 50
								+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550;
						else
							dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
				case 1:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50;
						else
							dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550;
						else
							dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
				case 2:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50;
						else
							dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550
								- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						else
							dastrum.y = 50
								+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
				case 3:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50;
						else
							dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50;
						else
							dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
				case 4:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50
								+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						else
							dastrum.y = 550
								- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50;
						else
							dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
				case 5:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550;
						else
							dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50;
						else
							dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
				case 6:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550;
						else
							dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 50
								+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						else
							dastrum.y = 550
								- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
									- 68085.10638297877)) * 500;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
				case 7:
					if (dastrum.ID == 0 || dastrum.ID == 2)
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550;
						else
							dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
					else
					{
						if (FlxG.save.data.downscroll)
							dastrum.y = 550;
						else
							dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = dastrum.y;
					}
			}
		}
		else if (Conductor.songPosition >= 47659.57446808513 && Conductor.songPosition <= 67943.26241134756)
		{
			/*if (times == 0)
				{
					while (nlist[0] == PlayMoving.xlist[0] && nlist[1] == PlayMoving.xlist[1] && nlist[2] == PlayMoving.xlist[2] && nlist[3] == PlayMoving.xlist[3])
					{
						var dalist:Array<Int> = [];
						var numlist:Array<Int> = [0,1,2,3];
						for (i in 0...4)
						{
							var num = FlxG.random.int(0,3-i);
							dalist.push(numlist[num]);
							numlist.remove(numlist[num]);
							nlist[i] = PlayMoving.oxlist[dalist[i]];
							pnlist[i] = PlayMoving.poxlist[dalist[i]];
						}
						trace(nlist+" "+xlist);
					}
					for (i in 0...4)
					{
						PlayMoving.xlist[i] = nlist[i];
						PlayMoving.pxlist[i] = pnlist[i];
					}
					times += 1;
			}*/
			if (Conductor.songPosition <= 47759.57446808513)
			{
				if (dastrum.x > 640)
				{
					dastrum.x = 858 - (47759.57446808513 - Conductor.songPosition) / 100 * (858 - PlayMoving.poxlist[dastrum.ID]);
					PlayMoving.pxlist[dastrum.ID] = dastrum.x;
				}
				else
				{
					dastrum.x = 218 - (47759.57446808513 - Conductor.songPosition) / 100 * (218 - PlayMoving.oxlist[dastrum.ID]);
					PlayMoving.xlist[dastrum.ID] = dastrum.x;
				}
			}
			else if (Conductor.songPosition >= 67843.26241134756)
			{
				if (dastrum.x > 640)
				{
					dastrum.x = PlayMoving.poxlist[dastrum.ID] - (67943.26241134756 - Conductor.songPosition) / 100 * (PlayMoving.poxlist[dastrum.ID] - 858);
					PlayMoving.pxlist[dastrum.ID] = dastrum.x;
				}
				else
				{
					dastrum.x = PlayMoving.oxlist[dastrum.ID] - (67943.26241134756 - Conductor.songPosition) / 100 * (PlayMoving.oxlist[dastrum.ID] - 218);
					PlayMoving.xlist[dastrum.ID] = dastrum.x;
				}
			}
			else
			{
				if (dastrum.x > 640)
				{
					dastrum.x = 858;
					PlayMoving.pxlist[dastrum.ID] = dastrum.x;
				}
				else
				{
					dastrum.x = 218;
					PlayMoving.xlist[dastrum.ID] = dastrum.x;
				}
			}
			times = 1;
			dastrum.y = strumLine.y;
		}
		else if (Conductor.songPosition >= 40851.06382978724 && Conductor.songPosition <= 44113.47517730498)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.sy = (550 - 500 * (44113.47517730498 - Conductor.songPosition) / (44113.47517730498 - 40851.06382978724));
			else
				PlayMoving.sy = (50 + 500 * (44113.47517730498 - Conductor.songPosition) / (44113.47517730498 - 40851.06382978724));
			strumLine.y = PlayMoving.sy;
			dastrum.y = PlayMoving.sy;
		}
		else if (Conductor.songPosition >= 27092.19858156028 && Conductor.songPosition <= 40851.06382978724)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.sy = 50;
			else
				PlayMoving.sy = 550;
			strumLine.y = PlayMoving.sy;
			dastrum.y = PlayMoving.sy;
		}
		else if (Conductor.songPosition >= 26382.978723404252 && Conductor.songPosition <= 27092.19858156028)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.sy = (50 + 500 * (27092.19858156028 - Conductor.songPosition) / (27092.19858156028 - 26382.978723404252));
			else
				PlayMoving.sy = (550 - 500 * (27092.19858156028 - Conductor.songPosition) / (27092.19858156028 - 26382.978723404252));
			strumLine.y = PlayMoving.sy;
			dastrum.y = PlayMoving.sy;
		}
		else
		{
			dastrum.y = strumLine.y;
		}
	}

	inline static public function show(daNote:Note):Bool
	{
		if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
		{
			return (daNote.strumTime - Conductor.songPosition) > (96595.74468085116 - 95319.14893617031);
		}
		else if (daNote.strumTime > 26382 && daNote.strumTime < 44114)
		{
			return (Math.abs(daNote.y - 300) > Math.abs(((300 - PlayMoving.sy) / 250)) * 360);
		}
		else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
		{
			return (Math.abs(daNote.y - 300) > Math.abs(((300 - PlayMoving.ylist[daNote.noteData]) / 250)) * 360);
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
		if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
		{
			return daNote.tooLate;
		}
		else if (daNote.strumTime > 26382 && daNote.strumTime < 44114)
		{
			return ((Math.abs(daNote.y - 300) > Math.abs(((300 - PlayMoving.sy) / 250)) * 50) && daNote.tooLate);
		}
		else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
		{
			return ((Math.abs(daNote.y - 300) > Math.abs(((300 - PlayMoving.ylist[daNote.noteData]) / 250)) * 50) && daNote.tooLate);
		}
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
		if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
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
		else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
		{
			if (PlayMoving.ylist[daNote.noteData] > 300)
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
			if (strumLine.y > 300)
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
		if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
		{
			return strumLine.y;
		}
		else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
		{
			return PlayMoving.ylist[daNote.noteData];
		}
		else
		{
			return strumLine.y;
		}
	}
}
