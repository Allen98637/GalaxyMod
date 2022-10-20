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

class M_underworld
{
	public static function pos(daNote:Note, strumLine:FlxSprite)
	{
		if (daNote.strumTime < 24114)
		{
			if (FlxG.save.data.downscroll)
			{
				if (Std.int(Conductor.songPosition / 1518.98734177) == Std.int(daNote.strumTime / 1518.98734177))
					daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (strumLine.y
						+ (Conductor.songPosition - daNote.strumTime - 189.873417722) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			}
			else
			{
				if (Std.int(Conductor.songPosition / 1518.98734177) == Std.int(daNote.strumTime / 1518.98734177))
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				else
					daNote.y = (strumLine.y
						- (Conductor.songPosition - daNote.strumTime - 189.873417722) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			}
		}
		else if (daNote.strumTime >= 24303 && daNote.strumTime < 30190)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (PlayMoving.ylist[daNote.noteData]
					- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 30379 && daNote.strumTime < 36266)
		{
			if (!daNote.isSustainNote)
				daNote.angle += 5;
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
		{
			if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				var sdist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				var edist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2));
				var x = (daNote.mustPress ? 1110 : 50) + Note.noteWidth[daNote.noteData] * 0.5;
				var y = (daNote.mustPress ? 132 + daNote.noteData * 112 : 468 - daNote.noteData * 112) + Note.noteHeight[daNote.noteData] * 0.5;

				daNote.renderer = new RenderPath(1, [
					sdist,
					edist,
					x,
					y,
					daNote.width * 0.7,
					daNote.mustPress ? 90 : 270,
					Math.abs(x - 640)
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else if (daNote.mustPress)
			{
				daNote.x = (1110 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				daNote.y = 132 + daNote.noteData * 112;
			}
			else
			{
				daNote.x = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				daNote.y = 468 - daNote.noteData * 112;
			}
		}
		else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
		{
			if (daNote.isSustainNote)
			{
				var anglist:Array<Float> = [-90, 180, 0, 90];
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				var sdist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				var edist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2));
				var x:Float = 0;
				var y:Float = 0;

				if (daNote.mustPress)
				{
					switch (daNote.noteData)
					{
						case 0:
							y = 300;
							x = 690;
						case 3:
							y = 300;
							x = 1110;
						case 1:
							y = 510;
							x = 900;
						case 2:
							y = 90;
							x = 900;
					}
				}
				else
				{
					switch (daNote.noteData)
					{
						case 0:
							y = 300;
							x = 50;
						case 3:
							y = 300;
							x = 470;
						case 1:
							y = 510;
							x = 260;
						case 2:
							y = 90;
							x = 260;
					}
				}

				daNote.renderer = new RenderPath(1, [
					sdist,
					edist,
					x + Note.noteWidth[daNote.noteData] * 0.5,
					y + Note.noteHeight[daNote.noteData] * 0.5,
					daNote.width * 0.7,
					anglist[daNote.noteData],
					210
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else if (daNote.mustPress)
			{
				switch (daNote.noteData)
				{
					case 0:
						daNote.y = 300;
						daNote.x = (690 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					case 3:
						daNote.y = 300;
						daNote.x = (1110 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					case 1:
						daNote.y = (510 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
						daNote.x = 900;
					case 2:
						daNote.y = (90 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
						daNote.x = 900;
				}
			}
			else
			{
				switch (daNote.noteData)
				{
					case 0:
						daNote.y = 300;
						daNote.x = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					case 3:
						daNote.y = 300;
						daNote.x = (470 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					case 1:
						daNote.y = (510 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
						daNote.x = 260;
					case 2:
						daNote.y = (90 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
						daNote.x = 260;
				}
			}
		}
		else if (daNote.strumTime >= 60759 && daNote.strumTime < 72722)
		{
			if (FlxG.save.data.downscroll)
			{
				if (!daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						case 0:
							daNote.angle = -90;
						case 3:
							daNote.angle = 90;
						case 2:
							daNote.angle = 180;
					}
				}
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			}
			else
			{
				if (!daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						case 0:
							daNote.angle = 90;
						case 3:
							daNote.angle = -90;
						case 1:
							daNote.angle = 180;
					}
				}
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			}
		}
		else if (daNote.strumTime >= 78987 && daNote.strumTime < 91045)
		{
			if (FlxG.save.data.downscroll)
			{
				if (daNote.mustPress)
				{
					if ((daNote.strumTime - 85063.29113924058) / 6075.94936709 < 0.5)
						daNote.y = ((550 - 500 * (daNote.strumTime - 85063.29113924058) / 6075.94936709)
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = ((550 - 500 * (daNote.strumTime - 85063.29113924058) / 6075.94936709)
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
				else
				{
					if ((daNote.strumTime - 78987.34177215197) / 6075.94936709 < 0.5)
						daNote.y = ((550 - 500 * (daNote.strumTime - 78987.34177215197) / 6075.94936709)
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = ((550 - 500 * (daNote.strumTime - 78987.34177215197) / 6075.94936709)
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
			}
			else
			{
				if (daNote.mustPress)
				{
					if ((daNote.strumTime - 85063.29113924058) / 6075.94936709 < 0.5)
						daNote.y = ((50 + 500 * (daNote.strumTime - 85063.29113924058) / 6075.94936709)
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = ((50 + 500 * (daNote.strumTime - 85063.29113924058) / 6075.94936709)
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
				else
				{
					if ((daNote.strumTime - 78987.34177215197) / 6075.94936709 < 0.5)
						daNote.y = ((50 + 500 * (daNote.strumTime - 78987.34177215197) / 6075.94936709)
							- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
					else
						daNote.y = ((50 + 500 * (daNote.strumTime - 78987.34177215197) / 6075.94936709)
							+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				}
			}
		}
		else if (daNote.strumTime >= 91139 && daNote.strumTime < 97026)
		{
			if (daNote.mustPress)
				daNote.x = PlayMoving.pxlist[daNote.noteData];
			else
				daNote.x = PlayMoving.xlist[daNote.noteData];
			if (daNote.isSustainNote)
				daNote.x += daNote.width;
			if (FlxG.save.data.downscroll)
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 97215 && daNote.strumTime < 109178)
		{
			if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				var sdist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				var edist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2));
				var x = (daNote.mustPress ? 690 : 520) + Note.noteWidth[daNote.noteData] * 0.5;
				var y = (daNote.mustPress ? 468 - daNote.noteData * 112 : 132 + daNote.noteData * 112) + Note.noteHeight[daNote.noteData] * 0.5;

				daNote.renderer = new RenderPath(1, [sdist, edist, x, y, daNote.width * 0.7, daNote.mustPress ? 270 : 90, 0]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else if (daNote.mustPress)
			{
				daNote.x = (690 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				daNote.y = 468 - daNote.noteData * 112;
			}
			else
			{
				daNote.x = (520 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				daNote.y = 132 + daNote.noteData * 112;
			}
		}
		else if (daNote.strumTime >= 109367 && daNote.strumTime < 121330)
		{
			/* x = ori + swagWidth / 2, y = 360, scale = 2
				eye(640,360,0), flat: z = 200
			 */
			var z:Float = 800 * (daNote.strumTime - Conductor.songPosition) / 379.746835444;
			var x0:Float = 640 - Note.swagWidth * (4 - daNote.noteData);
			var x:Float = 640 - Note.swagWidth * (4 - daNote.noteData) + Note.swagWidth / 1.4;
			if (daNote.mustPress)
			{
				x0 = 640 + Note.swagWidth * daNote.noteData;
				x = 640 + Note.swagWidth * daNote.noteData + Note.swagWidth / 1.4;
			}

			var nx0:Float = NoteObject.toScreen(x0, 360, z)[0];
			var nx:Float = NoteObject.toScreen(x, 360, z)[0];
			daNote.setGraphicSize(Std.int((nx - nx0) * 2));
			daNote.updateHitbox();
			daNote.x = nx - daNote.width / 2;
			daNote.y = 360 - daNote.height / 2;
			if (Conductor.songPosition > daNote.strumTime)
				daNote.alpha = 0;
		}
		else if (daNote.strumTime >= 121518 && daNote.strumTime < 145633)
		{
			if (daNote.mustPress)
			{
				daNote.x = 538 + (PlayMoving.poxlist[daNote.noteData] - 538) * FlxMath.fastCos(daNote.strumTime / 1518.98734177 * 3.1415926);
				daNote.y = 300 - (100 + 50 * daNote.noteData) * FlxMath.fastSin(daNote.strumTime / 1518.98734177 * 3.1415926);
			}
			else
			{
				daNote.x = 538 - (538 - PlayMoving.oxlist[daNote.noteData]) * FlxMath.fastCos(daNote.strumTime / 1518.98734177 * 3.1415926);
				daNote.y = 300 + (100 + 50 * (3 - daNote.noteData)) * FlxMath.fastSin(daNote.strumTime / 1518.98734177 * 3.1415926);
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
		if (Conductor.songPosition >= 24303.797468354438 && Conductor.songPosition < 30379.746835443053)
		{
			if (Conductor.songPosition % 759.493670886 < 379.746835443)
			{
				if (dastrum.ID % 2 == 0)
				{
					if (FlxG.save.data.downscroll)
					{
						dastrum.y = 450;
						PlayMoving.ylist[dastrum.ID] = 450;
					}
					else
					{
						dastrum.y = 150;
						PlayMoving.ylist[dastrum.ID] = 150;
					}
				}
				else
				{
					if (FlxG.save.data.downscroll)
					{
						dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = 550;
					}
					else
					{
						dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = 50;
					}
				}
			}
			else
			{
				if (dastrum.ID % 2 == 0)
				{
					if (FlxG.save.data.downscroll)
					{
						dastrum.y = 550;
						PlayMoving.ylist[dastrum.ID] = 550;
					}
					else
					{
						dastrum.y = 50;
						PlayMoving.ylist[dastrum.ID] = 50;
					}
				}
				else
				{
					if (FlxG.save.data.downscroll)
					{
						dastrum.y = 450;
						PlayMoving.ylist[dastrum.ID] = 450;
					}
					else
					{
						dastrum.y = 150;
						PlayMoving.ylist[dastrum.ID] = 150;
					}
				}
			}
		}
		else if (Conductor.songPosition >= 30379.746835443053 && Conductor.songPosition < 31189.873417721534)
		{
			if (FlxG.save.data.downscroll)
				dastrum.y = 550;
			else
				dastrum.y = 50;
		}
		else if (Conductor.songPosition >= 36455.69620253167 && Conductor.songPosition < 48227.84810126586)
		{
			if (dastrum.x > 640)
			{
				dastrum.x = 1110;
				dastrum.y = 132 + dastrum.ID * 112;
			}
			else
			{
				dastrum.x = 50;
				dastrum.y = 468 - dastrum.ID * 112;
			}
		}
		else if (Conductor.songPosition >= 48227.84810126586 && Conductor.songPosition < 48987.341772151936)
		{
			if (Conductor.songPosition < 48607.5949367089)
			{
				if (dastrum.x < 640)
				{
					switch (dastrum.ID)
					{
						case 0:
							dastrum.x = 50;
							dastrum.y = 468 - (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (168);
						case 1:
							dastrum.x = 50 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (210);
							dastrum.y = 356 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (154);
						case 2:
							dastrum.x = 50 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (210);
							dastrum.y = 244 - (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (154);
						case 3:
							dastrum.x = 50 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (420);
							dastrum.y = 132 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (168);
					}
				}
			}
			else
			{
				if (dastrum.x > 640)
				{
					switch (dastrum.ID)
					{
						case 0:
							dastrum.x = 1110 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (420);
							dastrum.y = 132 + (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (168);
						case 1:
							dastrum.x = 1110 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (210);
							dastrum.y = 244 + (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (266);
						case 2:
							dastrum.x = 1110 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (210);
							dastrum.y = 356 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (266);
						case 3:
							dastrum.x = 1110;
							dastrum.y = 468 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (168);
					}
				}
				else
				{
					switch (dastrum.ID)
					{
						case 0:
							dastrum.x = 50;
							dastrum.y = 300;
						case 1:
							dastrum.x = 260;
							dastrum.y = 510;
						case 2:
							dastrum.x = 260;
							dastrum.y = 90;
						case 3:
							dastrum.x = 470;
							dastrum.y = 300;
					}
				}
			}
		}
		else if (Conductor.songPosition >= 48987.341772151936 && Conductor.songPosition < 49987.341772151936)
		{
			if (dastrum.x > 640)
			{
				switch (dastrum.ID)
				{
					case 0:
						dastrum.x = 690;
						dastrum.y = 300;
					case 1:
						dastrum.x = 900;
						dastrum.y = 510;
					case 2:
						dastrum.x = 900;
						dastrum.y = 90;
					case 3:
						dastrum.x = 1110;
						dastrum.y = 300;
				}
			}
		}
		else if (Conductor.songPosition >= 72911.39240506335 && Conductor.songPosition < 78797.46835443044)
		{
			if (Conductor.songPosition < 73101.26582278487)
				dastrum.alpha = (73101.26582278487 - Conductor.songPosition) / 189.873417722;
			else
				dastrum.alpha = 0;
		}
		else if (Conductor.songPosition >= 78987.34177215197 && Conductor.songPosition < 91044.30379746843)
		{
			if (Conductor.songPosition < 79177.21518987349)
				dastrum.alpha = (Conductor.songPosition - 78987.34177215197) / 189.873417722;
			else
				dastrum.alpha = 1;
			if (Conductor.songPosition < 85063.29113924058)
			{
				if (dastrum.x < 640)
				{
					if (FlxG.save.data.downscroll)
						dastrum.y = 550 - 500 * (Conductor.songPosition - 78987.34177215197) / 6075.94936709;
					else
						dastrum.y = 50 + 500 * (Conductor.songPosition - 78987.34177215197) / 6075.94936709;
				}
			}
			else
			{
				if (dastrum.x > 640)
				{
					if (FlxG.save.data.downscroll)
						dastrum.y = 550 - 500 * (Conductor.songPosition - 85063.29113924058) / 6075.94936709;
					else
						dastrum.y = 50 + 500 * (Conductor.songPosition - 85063.29113924058) / 6075.94936709;
				}
			}
		}
		else if (Conductor.songPosition >= 91139.2405063292 && Conductor.songPosition < 97025.31645569629)
		{
			if (Conductor.songPosition % 1518.98734177 < 379.746835443)
			{
				if (dastrum.x > 640)
				{
					if (dastrum.ID % 2 == 0)
					{
						dastrum.x = PlayMoving.poxlist[dastrum.ID]
							+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.poxlist[dastrum.ID + 1] - PlayMoving.poxlist[dastrum.ID]);
						PlayMoving.pxlist[dastrum.ID] = dastrum.x;
					}
					else
					{
						dastrum.x = PlayMoving.poxlist[dastrum.ID]
							+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.poxlist[dastrum.ID - 1] - PlayMoving.poxlist[dastrum.ID]);
						PlayMoving.pxlist[dastrum.ID] = dastrum.x;
					}
				}
				else
				{
					if (dastrum.ID % 2 == 0)
					{
						dastrum.x = PlayMoving.oxlist[dastrum.ID]
							+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.oxlist[dastrum.ID + 1] - PlayMoving.oxlist[dastrum.ID]);
						PlayMoving.xlist[dastrum.ID] = dastrum.x;
					}
					else
					{
						dastrum.x = PlayMoving.oxlist[dastrum.ID]
							+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.oxlist[dastrum.ID - 1] - PlayMoving.oxlist[dastrum.ID]);
						PlayMoving.xlist[dastrum.ID] = dastrum.x;
					}
				}
			}
			else if (Conductor.songPosition % 1518.98734177 >= 759.493670886 && Conductor.songPosition % 1518.98734177 < 1139.24050633)
			{
				if (dastrum.x > 640)
				{
					if (dastrum.ID % 2 == 0)
					{
						dastrum.x = PlayMoving.poxlist[dastrum.ID + 1]
							- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.poxlist[dastrum.ID + 1] - PlayMoving.poxlist[dastrum.ID]);
						PlayMoving.pxlist[dastrum.ID] = dastrum.x;
					}
					else
					{
						dastrum.x = PlayMoving.poxlist[dastrum.ID - 1]
							- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.poxlist[dastrum.ID - 1] - PlayMoving.poxlist[dastrum.ID]);
						PlayMoving.pxlist[dastrum.ID] = dastrum.x;
					}
				}
				else
				{
					if (dastrum.ID % 2 == 0)
					{
						dastrum.x = PlayMoving.oxlist[dastrum.ID + 1]
							- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.oxlist[dastrum.ID + 1] - PlayMoving.oxlist[dastrum.ID]);
						PlayMoving.xlist[dastrum.ID] = dastrum.x;
					}
					else
					{
						dastrum.x = PlayMoving.oxlist[dastrum.ID - 1]
							- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.oxlist[dastrum.ID - 1] - PlayMoving.oxlist[dastrum.ID]);
						PlayMoving.xlist[dastrum.ID] = dastrum.x;
					}
				}
			}
		}
		else if (Conductor.songPosition >= 97215.18987341781 && Conductor.songPosition < 109177.21518987352)
		{
			if (dastrum.x > 640)
			{
				dastrum.x = 690;
				dastrum.y = 468 - dastrum.ID * 112;
			}
			else
			{
				dastrum.x = 520;
				dastrum.y = 132 + dastrum.ID * 112;
			}
		}
		else if (Conductor.songPosition >= 109367.08860759504 && Conductor.songPosition < 110886.0759493672)
		{
			if (Conductor.songPosition < 109556.962025)
			{
				dastrum.scale.x = (109556.962025 - Conductor.songPosition) / 189.873417722 * 0.7;
				dastrum.scale.y = (109556.962025 - Conductor.songPosition) / 189.873417722 * 0.7;
			}
			else
				dastrum.alpha = 0;
		}
		else if (Conductor.songPosition >= 121139.24050632922 && Conductor.songPosition < 121329.11392405075)
		{
			if (dastrum.x > 640)
				dastrum.x = PlayMoving.poxlist[dastrum.ID];
			else
				dastrum.x = PlayMoving.oxlist[dastrum.ID];
			dastrum.y = 300;
			dastrum.alpha = 1;
			dastrum.x = 538 - (538 - PlayMoving.oxlist[dastrum.ID]) * FlxMath.fastCos(Conductor.songPosition / 1518.98734177 * 3.1415926);
			dastrum.y = 300 + (100 + 50 * (3 - dastrum.ID)) * FlxMath.fastSin(Conductor.songPosition / 1518.98734177 * 3.1415926);
			dastrum.scale.x = (Conductor.songPosition - 121139.24050632922) / 189.873417722 * 0.7;
			dastrum.scale.y = (Conductor.songPosition - 121139.24050632922) / 189.873417722 * 0.7;
		}
		else if (Conductor.songPosition >= 121518.98734177227 && Conductor.songPosition < 145822.78481)
		{
			dastrum.scale.x = 0.7;
			dastrum.scale.y = 0.7;
			dastrum.x = 538 - (538 - PlayMoving.oxlist[dastrum.ID]) * FlxMath.fastCos(Conductor.songPosition / 1518.98734177 * 3.1415926);
			dastrum.y = 300 + (100 + 50 * (3 - dastrum.ID)) * FlxMath.fastSin(Conductor.songPosition / 1518.98734177 * 3.1415926);
		}
	}

	public static function pspos(dastrum:NoteStrum, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 121139.24050632922 && Conductor.songPosition < 145822.78481)
		{
			dastrum.scale.x = 0.7;
			dastrum.scale.y = 0.7;
			dastrum.x = 538 + (PlayMoving.poxlist[dastrum.ID] - 538) * FlxMath.fastCos(Conductor.songPosition / 1518.98734177 * 3.1415926);
			dastrum.y = 300 - (100 + 50 * dastrum.ID) * FlxMath.fastSin(Conductor.songPosition / 1518.98734177 * 3.1415926);
		}
	}

	inline static public function show(daNote:Note):Bool
	{
		if (Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
		{
			if (daNote.isSustainNote)
				return false;
			if (daNote.mustPress)
				return daNote.x < 640;
			else
				return daNote.x > 640;
		}
		else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
		{
			if (daNote.isSustainNote)
				return false;
			if (daNote.mustPress)
			{
				switch (daNote.noteData)
				{
					case 0:
						return daNote.x > 900;
					case 3:
						return daNote.x < 900;
					case 1:
						return daNote.y < 300;
					default:
						return daNote.y > 300;
				}
			}
			else
			{
				switch (daNote.noteData)
				{
					case 0:
						return daNote.x > 260;
					case 3:
						return daNote.x < 260;
					case 1:
						return daNote.y < 300;
					default:
						return daNote.y > 300;
				}
			}
		}
		else if (daNote.strumTime >= 109367 && daNote.strumTime < 121330)
			return daNote.strumTime - Conductor.songPosition > 379.746835444;
		else if (daNote.strumTime >= 121518 && daNote.strumTime < 145633)
			return daNote.strumTime - Conductor.songPosition > 759.493670885;
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
		if (Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
		{
			if (daNote.mustPress)
				return daNote.x > FlxG.width;
			else
				return false;
		}
		else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
		{
			if (daNote.mustPress)
				return (daNote.x > FlxG.width || daNote.x < 640 || daNote.y < -daNote.height || daNote.y > FlxG.height)
					&& Conductor.songPosition > daNote.strumTime;
			else
				return false;
		}
		else if (daNote.strumTime >= 78987 && daNote.strumTime < 91045)
			return ((daNote.y < -daNote.height) || (daNote.y > FlxG.height)) && Conductor.songPosition > daNote.strumTime;
		else if (daNote.strumTime >= 91139 && daNote.strumTime < 97026)
		{
			if (FlxG.save.data.downscroll)
				return daNote.y < -daNote.height;
			else
				return daNote.y > FlxG.height;
		}
		else if (daNote.strumTime >= 97215 && daNote.strumTime < 109178)
		{
			if (daNote.mustPress)
				return daNote.x < -daNote.width;
			else
				return daNote.x > FlxG.width;
		}
		else if (daNote.strumTime >= 109367 && daNote.strumTime < 121330)
		{
			return Conductor.songPosition - daNote.strumTime > (1000 / 6);
		}
		else if (daNote.strumTime >= 121518 && daNote.strumTime < 145633)
			return Conductor.songPosition - daNote.strumTime > (1000 / 6);
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
		if (Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
		{
			if (daNote.mustPress)
				return 3;
			else
				return 0;
		}
		else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
			return daNote.noteData;
		else if (daNote.strumTime >= 91139 && daNote.strumTime < 97026)
		{
			if (FlxG.save.data.downscroll)
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
		else if (daNote.strumTime >= 97215 && daNote.strumTime < 109178)
		{
			if (daNote.mustPress)
				return 0;
			else
				return 3;
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
		if (daNote.strumTime >= 24303 && daNote.strumTime < 30190)
			return PlayMoving.ylist[daNote.noteData];
		if (Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
		{
			if (daNote.mustPress)
				return 1110;
			else
				return 50;
		}
		else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
		{
			if (daNote.mustPress)
			{
				switch (daNote.noteData)
				{
					case 0:
						return 690;
					case 3:
						return 1110;
					case 1:
						return 510;
					default:
						return 90;
				}
			}
			else
			{
				switch (daNote.noteData)
				{
					case 0:
						return 50;
					case 3:
						return 470;
					case 1:
						return 510;
					default:
						return 90;
				}
			}
		}
		else if (daNote.strumTime >= 91139 && daNote.strumTime < 97026)
			return 550;
		else if (daNote.strumTime >= 97215 && daNote.strumTime < 109178)
		{
			if (daNote.mustPress)
				return 690;
			else
				return 520;
		}
		else
			return strumLine.y;
	}
}
