package modcharts;

import Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import haxe.Exception;
import modcharts.RenderPath;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class M_peace
{
	public static var generated:Int = 0;

	public static function reset()
	{
		generated = 0;
	}

	public static function pos(daNote:Note)
	{
		if (daNote.strumTime < 38100.0 || (daNote.strumTime <= 38400.0 && daNote.mustPress))
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;
			}
			if (daNote.isSustainNote)
			{
				daNote.z = (daNote.strumTime - Conductor.songPosition) * 2.5;
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				daNote.renderer = new R_peace(0, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width,
					daNote.noteData,
					daNote.sustainOrder
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else
			{
				daNote.wy = 360 + FlxMath.fastSin(Conductor.songPosition / 1200 * Math.PI) * 200;
				daNote.wx = 100 + daNote.noteData * 360 + FlxMath.fastCos(daNote.strumTime / 1200 * Math.PI) * 100;
				daNote.z = (daNote.strumTime - Conductor.songPosition) * 2.5;
				if (daNote.isEnd)
				{
					daNote.wy = 360 + FlxMath.fastSin((Conductor.songPosition + daNote.sustainLength * Conductor.stepCrochet) / 1200 * Math.PI) * 200;
					daNote.offsetWhenDraw = false;
				}
				daNote.scaleW();
			}
		}
		else if (daNote.strumTime >= 38100 && (daNote.strumTime < 57525 || (daNote.strumTime <= 57600 && daNote.mustPress)))
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;
			}

			if (daNote.isSustainNote)
			{
				daNote.z = 250 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				daNote.renderer = new R_peace(1, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width,
					daNote.noteData,
					daNote.spec
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else if (daNote.spec == 0)
			{
				var x:Float = 280 + daNote.noteData * 240;
				var y:Float = 600
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * FlxMath.SQUARE_ROOT_OF_TWO;
				var abc = NoteObject.triangles(x - daNote.width / 2, y - daNote.height / 2, 250, daNote.width, daNote.height, -45, 0, 0, x, 600, 250, false);
				daNote.z = 250 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				daNote.render(abc[0], abc[1]);
			}
			else
			{
				daNote.z = 250 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				daNote.wx = 640 + FlxMath.fastCos(daNote.strumTime / 600 * Math.PI) * 500;
				daNote.wy = 400
					+ FlxMath.fastSin(daNote.strumTime / 600 * Math.PI) * 200
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				if (daNote.strumTime >= 48000)
				{
					daNote.wx = 640 + FlxMath.fastCos(daNote.strumTime / 600 * Math.PI) * 500;
					daNote.wy = 400
						+ FlxMath.fastSin(daNote.strumTime / 300 * Math.PI) * 200
						+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				}
				if (daNote.isEnd)
				{
					daNote.offsetWhenDraw = false;
				}
				daNote.scaleW();
			}
		}
		else if (daNote.strumTime >= 57600 && (daNote.strumTime < 76500 || (daNote.strumTime < 76800 && daNote.mustPress)))
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.36 : 0.6;
			}
			var cang:Float = 0.125 + 0.25 * daNote.noteData;
			if (Conductor.songPosition >= 67200)
				cang += Conductor.songPosition / 1200;
			daNote.z = 200 + 640 * FlxMath.fastSin(cang * Math.PI);
			if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				daNote.renderer = new R_peace(2, [
					1,
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width,
					cang,
					((Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))) ? 1 : 0)
				]);
				daNote.pathrender();
			}
			else
			{
				daNote.renderer = new R_peace(2, [0, daNote.strumTime, daNote.width, daNote.height, cang]);
				daNote.pathrender();
			}
		}
		else if (daNote.strumTime >= 76800 && daNote.strumTime < 96000)
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;
			}
			daNote.visible = true;
			var ang:Float = 0;
			var anglist:Array<Float> = [-90, 180, 0, 90];

			if (Conductor.songPosition < 76800)
				ang = (76800 - Conductor.songPosition) / 300 * 180;
			if (Conductor.songPosition >= 86700)
			{
				if (Conductor.songPosition % 300 < 50)
					ang = (Math.floor(Conductor.songPosition / 300) - 1 + (Conductor.songPosition % 300) / 50) * 380 / 16;
				else
					ang = Math.floor(Conductor.songPosition / 300) * 380 / 16;
			}

			if (daNote.spec == 1)
			{
				if (daNote.mustPress)
					daNote.visible = Conductor.songPosition >= 90900;
				else
					daNote.visible = daNote.strumTime - Conductor.songPosition < 300;
				daNote.x = 640 - daNote.width / 2;
				daNote.y = 260 - daNote.height / 2;
			}
			else if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				var sdist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 2;
				var edist = -(Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2)) / 2;
				ang = ang + anglist[daNote.noteData];

				daNote.renderer = new RenderPath(1, [
					sdist,
					edist,
					640 + 300 * FlxMath.fastSin(ang / 180 * Math.PI),
					360 - 300 * FlxMath.fastCos(ang / 180 * Math.PI),
					daNote.width * 0.7,
					ang,
					300
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else
			{
				var dis:Float = 300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 2;
				daNote.angle = ang;

				ang = ang + anglist[daNote.noteData];
				daNote.x = 640 + FlxMath.fastSin(ang / 180 * Math.PI) * dis - daNote.width / 2;
				daNote.y = 360 - FlxMath.fastCos(ang / 180 * Math.PI) * dis - daNote.height / 2;

				if (dis < 0)
					daNote.visible = false;
			}
		}
		else if (daNote.strumTime >= 96000 && daNote.strumTime <= 115050)
		{
			var ang:Float = 0;
			if (Conductor.songPosition >= 105600)
				ang = Conductor.songPosition / 1200 * 360;
			else if (Conductor.songPosition >= 96000)
				ang = Conductor.songPosition / 2400 * 360;

			daNote.wy = NoteObject.toWorld(640,
				FlxG.save.data.downscroll ? (450 + Note.noteHeight[daNote.noteData] / 2) : (150 + Note.noteHeight[daNote.noteData] / 2))[1];
			var cx = NoteObject.toWorld(daNote.mustPress ? 1040 : 240, 360)[0];
			var dx:Float = 0;
			var adj:Bool = true;

			if (daNote.spec == 3)
			{
				if (!daNote.mustPress)
				{
					if (Conductor.songPosition >= 105300)
					{
						daNote.visible = true;
						adj = false;
						daNote.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? 1 : -1);
						var x = (Conductor.songPosition % 300) / 50;
						daNote.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
						var ex = NoteObject.toWorld(1040, 360)[0];
						daNote.wx = FlxMath.lerp(ex + 240, cx - 240, (Conductor.songPosition - 105300) / 300);
						daNote.z = 200 / 0.7 + FlxMath.fastSin(ang / 180 * Math.PI) * (-100 + (Conductor.songPosition - 105300) / 3 * 2);
					}
					else if (Conductor.songPosition >= 94800 && daNote.strumTime < 105300)
					{
						daNote.visible = true;
						if (Conductor.songPosition < 94900)
						{
							dx = -240 - daNote.width + daNote.width * (Conductor.songPosition - 83900) / 100;
							daNote.wy = NoteObject.toWorld(640, 300 + Note.noteHeight[daNote.noteData] / 2)[1];
						}
						else if (Conductor.songPosition < 95100)
						{
							dx = -240;
							daNote.wy = NoteObject.toWorld(640, 300 + Note.noteHeight[daNote.noteData] / 2)[1];
						}
						else if (Conductor.songPosition < 95700)
						{
							dx = -240;
							daNote.angle = 360 * (Conductor.songPosition % 150) / 150;
							daNote.wy = NoteObject.toWorld(640, 300 + Note.noteHeight[daNote.noteData] / 2)[1];
						}
						else
						{
							dx = -240;
							daNote.angle = 360 * (Conductor.songPosition % 150) / 150;
							var x = (Conductor.songPosition - 95700) / 50;
							daNote.wy = NoteObject.toWorld(640,
								(-0.485702260396 * x * x + 2.41421356237 * x) * 50 * (FlxG.save.data.downscroll ? -1 : 1) + 300 +
								Note.noteHeight[daNote.noteData] / 2)[1];
						}
					}
					else
						daNote.visible = false;
				}
				else
				{
					if (Conductor.songPosition >= 110100)
					{
						daNote.visible = true;
						adj = false;
						daNote.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
						var x = (Conductor.songPosition % 300) / 50;
						daNote.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
						var ex = NoteObject.toWorld(240, 360)[0];
						daNote.wx = FlxMath.lerp(ex + 240, cx - 240, (Conductor.songPosition - 110100) / 300);
						daNote.z = 200 / 0.7 + FlxMath.fastSin(ang / 180 * Math.PI) * (-100 + (Conductor.songPosition - 110100) / 3 * 2);
					}
					else if (Conductor.songPosition >= 100500 && daNote.strumTime < 110100)
					{
						daNote.visible = true;
						adj = false;
						daNote.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
						var x = (Conductor.songPosition % 300) / 50;
						daNote.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
						var ex = NoteObject.toWorld(240, 360)[0];
						daNote.wx = FlxMath.lerp(ex + 240, cx - 240, (Conductor.songPosition - 100500) / 300);
						daNote.z = 200 / 0.7 + FlxMath.fastSin(ang / 180 * Math.PI) * (-100 + (Conductor.songPosition - 100500) / 3 * 2);
					}
					else
						daNote.visible = false;
				}
			}
			else if (daNote.spec == 0)
			{
				dx = 160 * (daNote.noteData - 1.5);
				if ((Conductor.songPosition >= 96000 && Conductor.songPosition < 100800 && !daNote.mustPress)
					|| (Conductor.songPosition >= 100800 && Conductor.songPosition < 105600 && daNote.mustPress)
					|| (Conductor.songPosition >= 105600 && Conductor.songPosition < 110400 && !daNote.mustPress)
					|| (Conductor.songPosition >= 110400 && Conductor.songPosition < 115200 && daNote.mustPress))
				{
					var x = (Conductor.songPosition % 300) / 50;
					daNote.wy += (-x * x + 6 * x) * 100 / 6.3 * (FlxG.save.data.downscroll ? 1 : -1);
				}
				if (FlxG.save.data.downscroll)
					daNote.wy += (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				else
					daNote.wy -= (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
			}
			else
			{
				if (((Conductor.songPosition >= 96000 && Conductor.songPosition < 100500)
					|| (Conductor.songPosition >= 105600 && Conductor.songPosition < 110100))
					&& !daNote.mustPress)
				{
					daNote.visible = true;
					if (Conductor.songPosition % 600 < 300)
					{
						daNote.animation.play('redsync');
						dx = -240 + (Conductor.songPosition % 300) / 300 * 480;
						daNote.angle = (540 - 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
					}
					else
					{
						daNote.animation.play('purplesync');
						dx = 240 - (Conductor.songPosition % 300) / 300 * 480;
						daNote.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
					}
					var x = (Conductor.songPosition % 300) / 50;
					daNote.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
				}
				else if (((Conductor.songPosition >= 100800 && Conductor.songPosition < 105300) || Conductor.songPosition >= 110400)
					&& daNote.mustPress)
				{
					daNote.visible = true;
					if (Conductor.songPosition % 600 < 300)
					{
						daNote.animation.play('redsync');
						dx = -240 + (Conductor.songPosition % 300) / 300 * 480;
						daNote.angle = (540 - 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
					}
					else
					{
						daNote.animation.play('purplesync');
						dx = 240 - (Conductor.songPosition % 300) / 300 * 480;
						daNote.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
					}
					var x = (Conductor.songPosition % 300) / 50;
					if (Conductor.songPosition < 114900)
						daNote.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
				}
				else
					daNote.visible = false;
			}
			if (adj)
			{
				daNote.wx = 640 + FlxMath.fastCos(ang / 180 * Math.PI) * (cx - 640);
				daNote.wx += dx;
				daNote.z = 200 / 0.7 + FlxMath.fastSin(ang / 180 * Math.PI) * (daNote.mustPress ? 100 : -100);
			}
			daNote.scaleW();
			if (daNote.spec != 0)
				daNote.z -= 1;
		}
		else if (daNote.strumTime >= 115200 && (daNote.strumTime < 134400 || (daNote.strumTime < 134500 && daNote.mustPress)))
		{
			if (daNote.spec == 0)
			{
				var tx:Float = Conductor.songPosition % 300;
				var x:Float = (tx >= 150 ? tx - 300 : tx) / 50;
				daNote.z = (-0.1 * x * x * x + 0.233333333333 * x) * 100 + 200;
				if (tx < 150)
					daNote.z += 400;
				if (Conductor.songPosition < 115200)
					daNote.z += Math.floor((115200 - Conductor.songPosition) / 1200) * 1600;
				daNote.wx = NoteObject.toWorld((daNote.mustPress ? PlayMoving.poxlist[daNote.noteData] : PlayMoving.oxlist[daNote.noteData])
					+ Note.noteWidth[daNote.noteData] / 2,
					360)[0];
				daNote.wy = NoteObject.toWorld(640, (FlxG.save.data.downscroll ? 550 : 50) + Note.noteHeight[daNote.noteData] / 2)[1];
				daNote.wy += (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2)) / (FlxG.save.data.downscroll ? 0.7 : -0.7);
				daNote.z += 400 * (1 - (Math.floor(Conductor.songPosition / 300) % 2)) - 200;
				if (daNote.mustPress && Conductor.songPosition % 1200 >= 600)
					daNote.z += 800;
				if (!daNote.mustPress && Conductor.songPosition % 1200 < 600)
					daNote.z += 800;

				if (Conductor.songPosition > 124800)
				{
					if (daNote.isEnd && Conductor.songPosition < daNote.strumTime)
					{
						var sum:Float = daNote.sustainLength * 300 / 4;
						var len:Float = 0;
						if (Conductor.songPosition > daNote.strumTime - daNote.sustainLength * 300 / 4)
							len = Conductor.songPosition - daNote.strumTime + daNote.sustainLength * 300 / 4;
						len = (sum - len) / sum;
						var diff = 100 * FlxMath.fastSin(((Conductor.songPosition + 150 - 150 * len) % 300) / 300 * Math.PI);
						if ((Conductor.songPosition % 300) / 300 >= (len + 1) / 2)
							diff = 0;
						switch (daNote.noteData)
						{
							case 0:
								daNote.wx -= diff;
							case 1:
								daNote.wy += diff;
							case 2:
								daNote.wy -= diff;
							case 3:
								daNote.wx += diff;
						}
					}
					else if (Conductor.songPosition % 300 <= 150)
					{
						var diff = 100 * FlxMath.fastCos((Conductor.songPosition % 150) / 300 * Math.PI);
						switch (daNote.noteData)
						{
							case 0:
								daNote.wx -= diff;
							case 1:
								daNote.wy += diff;
							case 2:
								daNote.wy -= diff;
							case 3:
								daNote.wx += diff;
						}
					}
				}

				if (daNote.isEnd)
				{
					daNote.offsetWhenDraw = false;
					daNote.clones[0].offsetWhenDraw = false;
				}

				if (daNote.isSustainNote)
				{
					var len:Float = Conductor.stepCrochet;
					if (!daNote.animation.curAnim.name.endsWith('hold'))
					{
						len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
					}
					daNote.renderer = new R_peace(3, [
						daNote.strumTime - Conductor.stepCrochet,
						daNote.strumTime - Conductor.stepCrochet + len,
						daNote.width,
						daNote.noteData,
						daNote.mustPress ? 1 : 0,
						daNote.z,
						daNote.sustainOrder,
						daNote.sustainLength
					]);
					if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
					daNote.pathrender();

					if (daNote.strumTime - Conductor.songPosition <= 1500)
					{
						daNote.clones[0].renderer = new R_peace(3, [
							daNote.strumTime - Conductor.stepCrochet,
							daNote.strumTime - Conductor.stepCrochet + len,
							daNote.width,
							daNote.noteData,
							daNote.mustPress ? 1 : 0,
							daNote.z + 1600
						]);
						daNote.clones[0].renderer.bili = daNote.renderer.bili;
						daNote.clones[0].pathrender();
					}
				}
				else
				{
					daNote.scaleW();

					if (daNote.strumTime - Conductor.songPosition <= 1500)
					{
						daNote.clones[0].visible = true;
						daNote.clones[0].alpha = daNote.alpha;
						daNote.clones[0].wx = daNote.wx;
						daNote.clones[0].wy = daNote.wy;
						daNote.clones[0].z = daNote.z + 1600;
						daNote.clones[0].scaleW();
					}
				}
			}
			else
			{
				daNote.alpha = daNote.mustPress ? 1 : 0.6;
				daNote.visible = daNote.mustPress ? (daNote.noteData == 1 ? ((Conductor.songPosition >= 119400 && daNote.strumTime < 126000)
					|| Conductor.songPosition >= 129000) : ((Conductor.songPosition >= 119700 && daNote.strumTime < 126000)
						|| Conductor.songPosition >= 129300)) : (daNote.strumTime - Conductor.songPosition <= 600);
				daNote.wy = 360;
				daNote.wx = 640 + 250 * FlxMath.fastCos(daNote.strumTime / 300 * Math.PI);
				daNote.z = 200 / 0.7 - 100 * FlxMath.fastSin(daNote.strumTime / 300 * Math.PI);
				daNote.scaleW();
			}
		}
		else if (daNote.strumTime >= 134400 && (daNote.strumTime < 153600 || (daNote.strumTime < 153700 && daNote.mustPress)))
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;
			}

			if (daNote.isSustainNote)
			{
				daNote.z = 250 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				daNote.renderer = new R_peace(1, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width,
					daNote.noteData,
					daNote.spec
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else if (daNote.spec == 0)
			{
				var x:Float = 280 + daNote.noteData * 240;
				var y:Float = 600
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * FlxMath.SQUARE_ROOT_OF_TWO;
				var abc = NoteObject.triangles(x - daNote.width / 2, y - daNote.height / 2, 250, daNote.width, daNote.height, -45, 0, 0, x, 600, 250, false);
				daNote.z = 250 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				daNote.render(abc[0], abc[1]);
			}
			else
			{
				daNote.z = 250 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				daNote.wx = 340 + FlxMath.fastCos(daNote.strumTime / 600 * Math.PI) * 200;
				daNote.wy = 400
					+ FlxMath.fastSin(daNote.strumTime / 600 * Math.PI) * 200
					+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				if (daNote.spec == 2)
				{
					daNote.wx = 940 - FlxMath.fastCos(daNote.strumTime / 600 * Math.PI) * 200;
				}
				if (daNote.isEnd)
				{
					daNote.offsetWhenDraw = false;
				}
				daNote.scaleW();
			}
		}
		else if (daNote.strumTime >= 153600 && (daNote.strumTime < 172800 || (daNote.strumTime < 172900 && daNote.mustPress)))
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;
			}

			var ang:Float = (Conductor.songPosition / 2400) * 360;
			var anglist:Array<Float> = [-90, 180, 0, 90];

			if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}

				daNote.renderer = new R_peace(4, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width * 0.7,
					anglist[daNote.noteData]
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else
			{
				var dis:Float = 300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 2;

				var x:Float = 640 + FlxMath.fastSin(anglist[daNote.noteData] / 180 * Math.PI) * dis - daNote.width * 0.35;
				var y:Float = 360 - FlxMath.fastCos(anglist[daNote.noteData] / 180 * Math.PI) * dis - daNote.height * 0.35;
				var z:Float = 200 + 360 * FlxMath.fastSin(Math.PI / 12);

				var abc = NoteObject.multiTriangles(x, y, z, daNote.width * 0.7, daNote.height * 0.7, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640],
					[360, 360, 360], [z, z, z]);
				daNote.render(abc[0], abc[1]);

				if (dis < 0)
					daNote.visible = false;
			}
		}
		else if (daNote.strumTime >= 172800 && !daNote.mustPress)
		{
			daNote.z = 1000 - 100 * (daNote.strumTime - Conductor.songPosition) / 300;

			daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;

			if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}

				daNote.renderer = new R_peace(5, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else
			{
				var dis:Float = (daNote.strumTime - Conductor.songPosition) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 4;
				var ang:Float = (daNote.strumTime - Conductor.songPosition) / 600;

				daNote.wx = 640 + FlxMath.fastCos(ang * Math.PI) * dis;
				daNote.wy = 360 + FlxMath.fastSin(ang * Math.PI) * dis;
				daNote.scaleW();
			}
		}
		else
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
	}

	public static function spos(dastrum:NoteStrum)
	{
		if (Conductor.songPosition < 0)
			dastrum.mustBeKilled = true;
		else if (Conductor.songPosition > 38100 && Conductor.songPosition < 57600 && dastrum.spec != 2)
		{
			if (dastrum.spec == 0)
			{
				if (Conductor.songPosition < 38200)
					dastrum.alpha = (Conductor.songPosition - 38100) / 100;
				else
					dastrum.alpha = 1;
				var x:Float = 280 + dastrum.ID * 240;
				var y:Float = 600;
				var w = dastrum.width;
				var h = dastrum.height;
				if (dastrum.animation.curAnim.name == 'confirm')
				{
					w *= 238 / 157;
					h *= 235 / 154;
				}
				var abc = NoteObject.triangles(x - w / 2, y - h / 2, 250, w, h, -45, 0, 0, x, 600, 250, false);
				dastrum.z = 250;
				dastrum.render(abc[0], abc[1]);
				dastrum.z = 99999;
			}
			else
			{
				if (Conductor.songPosition < 38200)
					dastrum.alpha = (Conductor.songPosition - 38100) / 1000;
				else
					dastrum.alpha = 0.1;
				dastrum.z = 250;
				dastrum.wx = 640 + FlxMath.fastCos(Conductor.songPosition / 600 * Math.PI) * 500;
				dastrum.wy = 400 + FlxMath.fastSin(Conductor.songPosition / 600 * Math.PI) * 200;
				if (Conductor.songPosition >= 48000)
				{
					dastrum.wx = 640 + FlxMath.fastCos(Conductor.songPosition / 600 * Math.PI) * 500;
					dastrum.wy = 400 + FlxMath.fastSin(Conductor.songPosition / 300 * Math.PI) * 200;
				}
				dastrum.scaleW();
			}
		}
		else if (Conductor.songPosition >= 57400
			&& (Conductor.songPosition < 76500 || (Conductor.songPosition < 77100 && dastrum.spec == 2)))
		{
			if (dastrum.spec == 2)
			{
				var cang:Float = 0.125 + 0.25 * dastrum.ID;
				if (Conductor.songPosition >= 67200)
					cang += Conductor.songPosition / 1200;
				dastrum.z = 200 + 640 * FlxMath.fastSin(cang * Math.PI);
				dastrum.renderer = new R_peace(2, [
					2,
					(dastrum.animation.curAnim.name == 'confirm' ? 1 : 0),
					dastrum.width,
					dastrum.height,
					cang
				]);
				dastrum.pathrender();
				if (Conductor.songPosition >= 77000)
					dastrum.mustBeKilled = true;
			}
			else
			{
				dastrum.alpha -= 0.05;
				if (dastrum.alpha <= 0)
					dastrum.mustBeKilled = true;
			}
		}
		else if (Conductor.songPosition >= 76500 && Conductor.songPosition < 96000)
		{
			var r:Float = 300;
			dastrum.alpha = 1;
			if (Conductor.songPosition < 76800)
			{
				r = 300 * (Conductor.songPosition - 76500) / 300;
				dastrum.alpha = (Conductor.songPosition - 76500) / 300;
			}
			var ang:Float = 0;
			var anglist:Array<Float> = [-90, 180, 0, 90];

			if (Conductor.songPosition < 76800)
				ang = (76800 - Conductor.songPosition) / 300 * 180;
			if (Conductor.songPosition >= 86700)
			{
				if (Conductor.songPosition % 300 < 50)
					ang = (Math.floor(Conductor.songPosition / 300) - 1 + (Conductor.songPosition % 300) / 50) * 380 / 16;
				else
					ang = Math.floor(Conductor.songPosition / 300) * 380 / 16;
			}

			if (dastrum.spec == 0)
			{
				dastrum.angle = ang;

				ang = ang + anglist[dastrum.ID];
				dastrum.x = 640 + FlxMath.fastSin(ang / 180 * Math.PI) * r - dastrum.width / 2;
				dastrum.y = 360 - FlxMath.fastCos(ang / 180 * Math.PI) * r - dastrum.height / 2;
			}
			else if (dastrum.spec == -1)
			{
				ang = 0;

				if (Conductor.songPosition >= 86400)
					ang = Conductor.songPosition / 150 * 180;

				dastrum.angle = ang;
				dastrum.x = 640 + FlxMath.fastSin(ang / 180 * Math.PI) * r / 3 - dastrum.width / 2;
				dastrum.y = 360 - FlxMath.fastCos(ang / 180 * Math.PI) * r / 3 - dastrum.height / 2;
			}
			else if (dastrum.spec == -2)
			{
				var x:Float = 190;
				var y:Float = 360;
				var w = dastrum.width * 0.7;
				var h = dastrum.height * 0.7;
				ang = 0;
				if (Conductor.songPosition < 76800)
					x = 190 - (190 + dastrum.width) * (76800 - Conductor.songPosition) / 300;
				else if (Conductor.songPosition >= 87000)
					dastrum.mustBeKilled = true;
				else if (Conductor.songPosition >= 86700)
					x = 190 - (190 + dastrum.width) * (Conductor.songPosition - 86700) / 300;
				else
				{
					if (Conductor.songPosition % 1200 < 200)
						ang = (Conductor.songPosition % 1200) / 200 * 180;
				}
				var abc = NoteObject.triangles(x - w / 2, y - h / 2, 200 / 0.7, w, h, ang, 0, 0, 240, 360, 200 / 0.7);
				dastrum.render(abc[0], abc[1]);
			}
		}
		else if (Conductor.songPosition > 96000 && Conductor.songPosition < 116000 && dastrum.spec < 2)
		{
			var bang:Float = 0;
			if (Conductor.songPosition >= 105600)
				bang = Conductor.songPosition / 1200 * 360;
			else if (Conductor.songPosition >= 96000)
				bang = Conductor.songPosition / 2400 * 360;

			if (dastrum.spec == 0)
			{
				if (dastrum.player == 1)
					dastrum.mustBeKilled = true;
				var ang:Float = 0;
				if (Conductor.songPosition % 300 < 50)
					ang = (Math.floor(Conductor.songPosition / 300) - 1 + (Conductor.songPosition % 300) / 50) * 380 / 16;
				else
					ang = Math.floor(Conductor.songPosition / 300) * 380 / 16;

				var x = 640 - dastrum.width * 0.7 / 2;
				var y = 360 - dastrum.height * 0.7 / 2;
				switch (dastrum.ID)
				{
					case 0:
						x -= 300;
					case 1:
						y += 300;
					case 2:
						y -= 300;
					case 3:
						x += 300;
				}
				var w = dastrum.width * 0.7;
				var h = dastrum.height * 0.7;

				var ppp:Float = 45;
				if (Conductor.songPosition < 96100)
				{
					ppp = (Conductor.songPosition - 96000) * 45 / 100;
					dastrum.alpha = 1 - (Conductor.songPosition - 96000) / 200;
				}

				var abc = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, [0, ppp, 0], [0, 0, bang], [ang, 0, 0], [640, 640, 640], [360, 360, 360],
					[200 / 0.7, 200 / 0.7, 200 / 0.7]);
				dastrum.z = NoteObject.multiWorldSpin(x + dastrum.width * 0.7 / 2, y + 260 - dastrum.height * 0.7 / 2, 200 / 0.7, [0, ppp, 0], [0, 0, bang],
					[ang, 0, 0], [640, 640, 640], [360, 360, 360], [200 / 0.7, 200 / 0.7, 200 / 0.7])[1][0];
				dastrum.render(abc[0], abc[1]);
			}
			else if (dastrum.spec == -1)
			{
				if (dastrum.player == 1)
					dastrum.mustBeKilled = true;
				var ang = (Conductor.songPosition - 96000) * 45 / 100;

				var x = 640 - dastrum.width * 0.7 / 2;
				var y = 260 - dastrum.height * 0.7 / 2;
				var w = dastrum.width * 0.7;
				var h = dastrum.height * 0.7;

				var ppp:Float = 45;
				if (Conductor.songPosition < 96100)
				{
					ppp = Conductor.songPosition - 96000;
					dastrum.alpha = 1 - (Conductor.songPosition - 96000) / 200;
				}

				var abc = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, [0, ppp, 0], [0, 0, bang], [ang, 0, 0], [640, 640, 640], [360, 360, 360],
					[200 / 0.7, 200 / 0.7, 200 / 0.7]);
				dastrum.z = NoteObject.multiWorldSpin(x + dastrum.width * 0.7 / 2, y + 260 - dastrum.height * 0.7 / 2, 200 / 0.7, [0, ppp, 0], [0, 0, bang],
					[ang, 0, 0], [640, 640, 640], [360, 360, 360], [200 / 0.7, 200 / 0.7, 200 / 0.7])[1][0];
				dastrum.render(abc[0], abc[1]);
			}
			else
			{
				if (Conductor.songPosition < 96100)
					dastrum.alpha = (Conductor.songPosition - 96000) / 100;
				else
					dastrum.alpha = 1;
				dastrum.wy = NoteObject.toWorld(640,
					FlxG.save.data.downscroll ? (450 + Note.noteHeight[dastrum.ID] / 2) : (150 + Note.noteHeight[dastrum.ID] / 2))[1];
				if ((Conductor.songPosition >= 96000 && Conductor.songPosition < 100800 && dastrum.player == 0)
					|| (Conductor.songPosition >= 100800 && Conductor.songPosition < 105600 && dastrum.player == 1)
					|| (Conductor.songPosition >= 105600 && Conductor.songPosition < 110400 && dastrum.player == 0)
					|| (Conductor.songPosition >= 110400 && Conductor.songPosition < 115200 && dastrum.player == 1))
				{
					var x = (Conductor.songPosition % 300) / 50;
					dastrum.wy += (-x * x + 6 * x) * 100 / 6.3 * (FlxG.save.data.downscroll ? 1 : -1);
				}
				var cx = NoteObject.toWorld(dastrum.player == 1 ? 1040 : 240, 360)[0];
				var dx = 160 * (dastrum.ID - 1.5);
				dastrum.wx = 640 + FlxMath.fastCos(bang / 180 * Math.PI) * (cx - 640);
				dastrum.wx += dx;
				dastrum.z = 200 / 0.7 + FlxMath.fastSin(bang / 180 * Math.PI) * (dastrum.player == 1 ? 100 : -100);
				dastrum.scaleW();
			}

			if (Conductor.songPosition >= 115200)
			{
				dastrum.alpha = (115300 - Conductor.songPosition) / 100;
				if (dastrum.spec < 1)
					dastrum.alpha *= -1;
				if (Conductor.songPosition >= 115300)
					dastrum.mustBeKilled = true;
			}
		}
		else if (Conductor.songPosition > 112800 && Conductor.songPosition < 140000 && dastrum.spec > 1 && dastrum.spec < 5)
		{
			if (dastrum.spec < 4)
			{
				if (Conductor.songPosition > 134300)
				{
					dastrum.alpha = (134400 - Conductor.songPosition) / 100;
					if (Conductor.songPosition > 134400)
						dastrum.mustBeKilled = true;
				}
				var tx:Float = Conductor.songPosition % 300;
				var x:Float = (tx >= 150 ? tx - 300 : tx) / 50;
				dastrum.z = (-0.1 * x * x * x + 0.233333333333 * x) * 100 + 200;
				if (tx < 150)
					dastrum.z += 400;
				if (Conductor.songPosition < 115200)
					dastrum.z += Math.floor((115200 - Conductor.songPosition) / 1200) * 1600;
				dastrum.wx = NoteObject.toWorld((dastrum.player == 1 ? PlayMoving.poxlist[dastrum.ID] : PlayMoving.oxlist[dastrum.ID])
					+ Note.noteWidth[dastrum.ID] / 2, 360)[0];
				dastrum.wy = NoteObject.toWorld(640, (FlxG.save.data.downscroll ? 550 : 50) + Note.noteHeight[dastrum.ID] / 2)[1];

				if (Conductor.songPosition > 124800)
				{
					if (Conductor.songPosition % 300 <= 150)
					{
						var diff = 100 * FlxMath.fastCos((Conductor.songPosition % 150) / 300 * Math.PI);
						switch (dastrum.ID)
						{
							case 0:
								dastrum.wx -= diff;
							case 1:
								dastrum.wy += diff;
							case 2:
								dastrum.wy -= diff;
							case 3:
								dastrum.wx += diff;
						}
					}
				}

				dastrum.z += 400 * (1 - (Math.floor(Conductor.songPosition / 300) % 2));
				if (dastrum.player == 1 && Conductor.songPosition % 1200 >= 600)
					dastrum.z += 800;
				if (dastrum.player == 0 && Conductor.songPosition % 1200 < 600)
					dastrum.z += 800;
				dastrum.z += (dastrum.spec - 2) * 1600 - 200;
				dastrum.scaleW();
			}
			else if (dastrum.spec == 4)
			{
				dastrum.alpha = 0.2;
				if (Conductor.songPosition > 134300)
				{
					dastrum.alpha = (134400 - Conductor.songPosition) / 500;
					if (Conductor.songPosition > 134400)
						dastrum.mustBeKilled = true;
				}
				dastrum.wy = 360;
				dastrum.wx = 640 + 250 * FlxMath.fastCos(Conductor.songPosition / 300 * Math.PI);
				dastrum.z = 200 / 0.7 - 100 * FlxMath.fastSin(Conductor.songPosition / 300 * Math.PI);
				dastrum.scaleW();
			}
		}
		else if (Conductor.songPosition > 134300 && Conductor.songPosition < 154500 && (dastrum.spec <= 1 || dastrum.spec == 5))
		{
			if (dastrum.spec == 0)
			{
				if (Conductor.songPosition < 134400)
					dastrum.alpha = (Conductor.songPosition - 134300) / 100;
				else if (Conductor.songPosition >= 153600)
				{
					dastrum.alpha = (153700 - Conductor.songPosition) / 100;
					if (Conductor.songPosition >= 153700)
						dastrum.mustBeKilled = true;
				}
				else
					dastrum.alpha = 1;
				var x:Float = 280 + dastrum.ID * 240;
				var y:Float = 600;
				var w = dastrum.width;
				var h = dastrum.height;
				if (dastrum.animation.curAnim.name == 'confirm')
				{
					w *= 238 / 157;
					h *= 235 / 154;
				}
				var abc = NoteObject.triangles(x - w / 2, y - h / 2, 250, w, h, -45, 0, 0, x, 600, 250, false);
				dastrum.z = 250;
				dastrum.render(abc[0], abc[1]);
				dastrum.z = 99999;
			}
			else
			{
				if (Conductor.songPosition < 134400)
					dastrum.alpha = (Conductor.songPosition - 134300) / 1000;
				else if (Conductor.songPosition >= 153600)
				{
					dastrum.alpha = (153700 - Conductor.songPosition) / 1000;
					if (Conductor.songPosition >= 153700)
						dastrum.mustBeKilled = true;
				}
				else
					dastrum.alpha = 0.1;
				dastrum.z = 250;
				dastrum.wx = 340 + FlxMath.fastCos(Conductor.songPosition / 600 * Math.PI) * 200;
				dastrum.wy = 400 + FlxMath.fastSin(Conductor.songPosition / 600 * Math.PI) * 200;
				if (dastrum.spec == 5)
				{
					dastrum.wx = 940 - FlxMath.fastCos(Conductor.songPosition / 600 * Math.PI) * 200;
				}
				dastrum.scaleW();
			}
		}
		else if (Conductor.songPosition > 153500 && dastrum.spec == 2)
		{
			if (Conductor.songPosition < 153600)
				dastrum.alpha = (Conductor.songPosition - 153500) / 100;
			else if (Conductor.songPosition >= 172800)
			{
				dastrum.alpha = (172900 - Conductor.songPosition) / 100;
				if (Conductor.songPosition >= 172900)
					dastrum.mustBeKilled = true;
			}
			else
				dastrum.alpha = 1;

			var ang:Float = (Conductor.songPosition / 2400) * 360;
			var anglist:Array<Float> = [-90, 180, 0, 90];

			var dis:Float = 300;

			var x:Float = 640 + FlxMath.fastSin(anglist[dastrum.ID] / 180 * Math.PI) * dis - dastrum.width * 0.35;
			var y:Float = 360 - FlxMath.fastCos(anglist[dastrum.ID] / 180 * Math.PI) * dis - dastrum.height * 0.35;
			var w = dastrum.width * 0.7;
			var h = dastrum.height * 0.7;
			var z:Float = 200 + 360 * FlxMath.fastSin(Math.PI / 12);

			if (dastrum.animation.curAnim.name == 'confirm')
			{
				x -= (238 - 157) / 2 * 0.7;
				y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}

			var abc = NoteObject.multiTriangles(x, y, z, w, h, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z]);
			dastrum.render(abc[0], abc[1]);
		}
		else if (Conductor.songPosition > 172700 && dastrum.spec == 0)
		{
			if (Conductor.songPosition < 72800)
				dastrum.alpha = (Conductor.songPosition - 172700) / 100;
			else
				dastrum.alpha = 1;
			dastrum.wx = 640;
			dastrum.wy = 360;
			dastrum.z = 1000;
			dastrum.scaleW();
		}
	}

	public static function show(daNote:Note):Bool
	{
		if (daNote.strumTime >= 115200
			&& (daNote.strumTime < 134400 || (daNote.strumTime < 134500 && daNote.mustPress))
			&& daNote.spec == 0)
			return daNote.strumTime - Conductor.songPosition > 1500;
		else
			return false;
	}

	public static function kill(daNote:Note):Bool
	{
		if (daNote.strumTime < 57525 || (daNote.strumTime < 57600 && daNote.mustPress))
			return true;
		else if (daNote.strumTime >= 57600 && (daNote.strumTime < 76500 || (daNote.strumTime < 76800 && daNote.mustPress)))
			return Conductor.songPosition - daNote.strumTime > 1000;
		else if (daNote.strumTime >= 76800 && daNote.strumTime < 96000)
		{
			if (daNote.spec == 1)
				return true;
			else
				return daNote.y > FlxG.height || daNote.y < -daNote.height || daNote.x > FlxG.width || daNote.x < -daNote.width;
		}
		else if (daNote.strumTime >= 96000 && daNote.strumTime <= 115050 && daNote.spec != 0)
			return true;
		if (daNote.strumTime >= 115200 && (daNote.strumTime < 134400 || (daNote.strumTime < 134500 && daNote.mustPress)))
		{
			if (daNote.spec == 0)
			{
				var dood:Bool = Conductor.songPosition - daNote.strumTime > 1000;
				if (dood)
					PlayState.playstate.destroyObject(daNote.clones[0]);
				return dood;
			}
			else
				return true;
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return daNote.y > FlxG.height;
			else
				return daNote.y < -daNote.height;
		}
	}

	public static function ongood(daNote:Note):Void
	{
		if (PlayState.storyDifficulty != 0
			&& daNote.strumTime >= 115200
			&& (daNote.strumTime < 134400 || (daNote.strumTime < 134500 && daNote.mustPress))
			&& daNote.spec == 0)
		{
			PlayState.playstate.destroyObject(daNote.clones[0]);
		}
		else if (daNote.strumTime >= 172800 && !daNote.mustPress)
			PlayState.playstate.changeHealth(-0.023);
	}

	public static function clone(daNote:Note)
	{
		if (daNote.strumTime >= 115200
			&& (daNote.strumTime < 134400 || (daNote.strumTime < 134500 && daNote.mustPress))
			&& daNote.spec == 0)
		{
			var clone = new Note(daNote.strumTime, daNote.noteData, daNote.prevNote, daNote.synced, daNote.isSustainNote, daNote.isEnd);
			clone.scrollFactor.set();
			clone.visible = false;
			clone.isClone = true;
			daNote.clones.push(clone);
			PlayState.playstate.addObject(clone);
		}
	}

	public static function special(state:PlayState)
	{
		if (Conductor.songPosition >= 38100 && generated < 1)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.alpha = 0;
			}
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.alpha = 0;
			}
			generated = 1;
		}
		if (Conductor.songPosition >= 57400 && generated < 2)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 2);
			}
			generated = 2;
		}
		if (Conductor.songPosition >= 76500 && generated < 3)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.y = -200;
			}
			var ar:NoteStrum = state.generateStaticArrow(1, 2, "null", -1);
			ar.y = -200;
			var ar:NoteStrum = state.generateStaticArrow(0, 0, "null", -2);
			ar.y = -200;
			generated = 3;
		}
		if (Conductor.songPosition > 96000 && generated < 4)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 0);
				ar.y = -200;
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 1);
				ar.alpha = 0;
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.alpha = 0;
			}
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", -1);
			ar.y = -200;
			generated = 4;
		}
		if (Conductor.songPosition > 112800 && generated < 5)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 2);
				ar.y = -200;
				ar = state.generateStaticArrow(1, i, "null", 2);
				ar.y = -200;
				ar = state.generateStaticArrow(0, i, "null", 3);
				ar.y = -200;
				ar = state.generateStaticArrow(1, i, "null", 3);
				ar.y = -200;
				ar = state.generateStaticArrow(1, i, "null", 4);
				ar.alpha = 0;
			}
			generated = 5;
		}
		if (Conductor.songPosition > 134300 && generated < 6)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.alpha = 0;
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.alpha = 0;
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 5);
				ar.alpha = 0;
			}
			generated = 6;
		}
		if (Conductor.songPosition > 153500 && generated < 7)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 2);
				ar.alpha = 0;
			}
			generated = 7;
		}
		if (Conductor.songPosition > 172700 && generated < 8)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 0);
				ar.alpha = 0;
			}
			generated = 8;
		}
	}

	public static function beatHit(curBeat:Int)
	{
		if (curBeat == 319)
			PlayState.playstate.dad.playAnim("singPOSE1", true);
		if (curBeat == 336)
			PlayState.playstate.dad.playAnim("singPOSE2", true);
		if (curBeat == 368)
			PlayState.playstate.dad.playAnim("singPOSE2", true);
		if (curBeat == 383)
			PlayState.playstate.dad.playAnim("singPOSE1", true);
	}
}

class R_peace extends RenderPath
{
	override function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // forward [stime, etime, width, noteData, order]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var y1 = 360 + FlxMath.fastSin((Conductor.songPosition + (par[4] + head) * Conductor.stepCrochet) / 1200 * Math.PI) * 200;
				var x1 = 100 + par[3] * 360 + FlxMath.fastCos(stime / 1200 * Math.PI) * 100;
				var z1 = (stime - Conductor.songPosition) * 2.5;

				var y2 = 360 + FlxMath.fastSin((Conductor.songPosition + (par[4] + tail) * Conductor.stepCrochet) / 1200 * Math.PI) * 200;
				var x2 = 100 + par[3] * 360 + FlxMath.fastCos(etime / 1200 * Math.PI) * 100;
				var z2 = (etime - Conductor.songPosition) * 2.5;

				var p0:Array<Float> = NoteObject.toScreen(x1 - par[2], y1, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1 + par[2], y1, z1);
				var p2:Array<Float> = NoteObject.toScreen(x2 - par[2], y2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x2 + par[2], y2, z2);

				if (z1 < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 1: // arcaea [stime, etime, width, noteData,spec]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				if (par[4] == 0)
				{
					var x:Float = 280 + par[3] * 240;
					var y:Float = 600 + (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * FlxMath.SQUARE_ROOT_OF_TWO;
					var y2 = 600 + (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * FlxMath.SQUARE_ROOT_OF_TWO;
					var p0 = NoteObject.worldSpin(x - par[2] / 2, y, 250, -45, 0, 0, x, 600, 250, false);
					var p1 = NoteObject.worldSpin(x + par[2] / 2, y, 250, -45, 0, 0, x, 600, 250, false);
					var p2 = NoteObject.worldSpin(x - par[2] / 2, y2, 250, -45, 0, 0, x, 600, 250, false);
					var p3 = NoteObject.worldSpin(x + par[2] / 2, y2, 250, -45, 0, 0, x, 600, 250, false);
					if (p0[1][0] < 0)
						return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
					return [
						[p0[0][0], p0[0][1], p1[0][0], p1[0][1], p2[0][0], p2[0][1], p3[0][0], p3[0][1]],
						uvt
					];
				}
				else
				{
					var z = 250 - (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
					var x = 640 + FlxMath.fastCos(stime / 600 * Math.PI) * 500;
					var y = 400
						+ FlxMath.fastSin(stime / 600 * Math.PI) * 200
						+ (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));

					var z2 = 250 - (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
					var x2 = 640 + FlxMath.fastCos(etime / 600 * Math.PI) * 500;
					var y2 = 400
						+ FlxMath.fastSin(stime / 600 * Math.PI) * 200
						+ (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));

					if (stime >= 134400)
					{
						x = 340 + FlxMath.fastCos(stime / 600 * Math.PI) * 200;
						x2 = 340 + FlxMath.fastCos(etime / 600 * Math.PI) * 200;
						if (par[4] == 2)
						{
							x = 940 - FlxMath.fastCos(stime / 600 * Math.PI) * 200;
							x2 = 940 - FlxMath.fastCos(etime / 600 * Math.PI) * 200;
						}
					}
					else if (stime >= 48000)
					{
						x = 640 + FlxMath.fastCos(stime / 600 * Math.PI) * 500;
						y = 400
							+ FlxMath.fastSin(stime / 300 * Math.PI) * 200
							+ (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
						x2 = 640 + FlxMath.fastCos(etime / 600 * Math.PI) * 500;
						y2 = 400
							+ FlxMath.fastSin(etime / 300 * Math.PI) * 200
							+ (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
					}
					var p0:Array<Float> = NoteObject.toScreen(x - par[2], y, z);
					var p1:Array<Float> = NoteObject.toScreen(x + par[2], y, z);
					var p2:Array<Float> = NoteObject.toScreen(x2 - par[2], y2, z2);
					var p3:Array<Float> = NoteObject.toScreen(x2 + par[2], y2, z2);

					if (z < 0)
						return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
			case 2: // Circ note:[0,time,width,height,cang] hold:[1,stime,etime,width,cang,cut?] strum:[2,confirm?,width,height,cang]
				// r = 800
				if (par[0] == 0)
				{
					var wid = par[2];
					var hi = par[3];
					if (isSplash)
					{
						wid *= 2;
						hi *= 2;
					}
					var sumang = wid / (640 * Math.PI);
					var sang = par[4] - sumang * (0.5 - head);
					sang %= 1;
					var eang = par[4] - sumang * (0.5 - tail);
					eang %= 1;
					if (eang < sang)
						eang += 1;
					var y:Float = (FlxG.save.data.downscroll ? 720 : 0)
						+ (Conductor.songPosition - par[1]) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * (FlxG.save.data.downscroll ? 1 : -1);
					if (isSplash)
						y = (FlxG.save.data.downscroll ? 720 : 0);
					var x1 = 640 - 640 * FlxMath.fastCos(sang * Math.PI);
					var x2 = 640 - 640 * FlxMath.fastCos(eang * Math.PI);
					var z1 = 200 + 300 * FlxMath.fastSin(sang * Math.PI);
					var z2 = 200 + 300 * FlxMath.fastSin(eang * Math.PI);

					var p0:Array<Float> = NoteObject.toScreen(x1, y - hi / 2, z1);
					var p1:Array<Float> = NoteObject.toScreen(x2, y - hi / 2, z2);
					var p2:Array<Float> = NoteObject.toScreen(x1, y + hi / 2, z1);
					var p3:Array<Float> = NoteObject.toScreen(x2, y + hi / 2, z2);

					uvt = [head, 0, 200 / z1, tail, 0, 200 / z2, head, 1, 200 / z1, tail, 1, 200 / z2];

					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
				else if (par[0] == 1)
				{
					var sumang = par[3] / (640 * Math.PI);
					var sang = par[4] - sumang * (0.5 - head);
					sang %= 1;
					var eang = par[4] - sumang * (0.5 - tail);
					eang %= 1;
					if (eang < sang)
						eang += 1;
					var y1:Float = (FlxG.save.data.downscroll ? 720 : 0)
						+ (Conductor.songPosition - par[1]) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * (FlxG.save.data.downscroll ? 1 : -1);
					var y2:Float = (FlxG.save.data.downscroll ? 720 : 0)
						+ (Conductor.songPosition - par[2]) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * (FlxG.save.data.downscroll ? 1 : -1);
					var shead:Float = 0;
					if (par[5] == 1)
					{
						shead = (Conductor.songPosition - par[1]) / (par[2] - par[1]);
						y1 = FlxG.save.data.downscroll ? 550 : 50;
						if ((FlxG.save.data.downscroll && y2 > y1) || (!FlxG.save.data.downscroll && y2 < y1))
							return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
					}
					var x1 = 640 - 640 * FlxMath.fastCos(sang * Math.PI);
					var x2 = 640 - 640 * FlxMath.fastCos(eang * Math.PI);
					var z1 = 200 + 300 * FlxMath.fastSin(sang * Math.PI);
					var z2 = 200 + 300 * FlxMath.fastSin(eang * Math.PI);

					var p0:Array<Float> = NoteObject.toScreen(x1, y1, z1);
					var p1:Array<Float> = NoteObject.toScreen(x2, y1, z2);
					var p2:Array<Float> = NoteObject.toScreen(x1, y2, z1);
					var p3:Array<Float> = NoteObject.toScreen(x2, y2, z2);

					uvt = [
						head, shead, 200 / z1, tail, shead, 200 / z2, head, 1, 200 / z1, tail, 1, 200 / z2
					];

					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
				else if (par[0] == 2)
				{
					var wid = par[2];
					var hi = par[3];
					if (par[1] == 1)
					{
						wid *= (238 / 157);
						hi *= (235 / 154);
					}
					var sumang = wid / (640 * Math.PI);
					var sang = par[4] - sumang * (0.5 - head);
					sang %= 1;
					var eang = par[4] - sumang * (0.5 - tail);
					eang %= 1;
					if (eang < sang)
						eang += 1;
					var y:Float = FlxG.save.data.downscroll ? 720 : 0;
					if (Conductor.songPosition < 57600)
						y += (57600 - Conductor.songPosition) * (FlxG.save.data.downscroll ? 2 : -2);
					if (Conductor.songPosition >= 76800)
						y += (Conductor.songPosition - 76800) * (FlxG.save.data.downscroll ? 2 : -2);
					var x1 = 640 - 640 * FlxMath.fastCos(sang * Math.PI);
					var x2 = 640 - 640 * FlxMath.fastCos(eang * Math.PI);
					var z1 = 200 + 300 * FlxMath.fastSin(sang * Math.PI);
					var z2 = 200 + 300 * FlxMath.fastSin(eang * Math.PI);

					var p0:Array<Float> = NoteObject.toScreen(x1, y - hi / 2, z1);
					var p1:Array<Float> = NoteObject.toScreen(x2, y - hi / 2, z2);
					var p2:Array<Float> = NoteObject.toScreen(x1, y + hi / 2, z1);
					var p3:Array<Float> = NoteObject.toScreen(x2, y + hi / 2, z2);

					uvt = [head, 0, 200 / z1, tail, 0, 200 / z2, head, 1, 200 / z1, tail, 1, 200 / z2];

					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
			case 3: // multi note[stime,etime,width,noteData,mustPress,z,order,len]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var sorder:Float = par[6] + head;
				var eorder:Float = par[6] + tail;

				var x:Float = NoteObject.toWorld((par[4] == 1 ? PlayMoving.poxlist[Std.int(par[3])] : PlayMoving.oxlist[Std.int(par[3])])
					+ Note.noteWidth[Std.int(par[3])] / 2, 360)[0];
				var y:Float = NoteObject.toWorld(640, (FlxG.save.data.downscroll ? 550 : 50) + Note.noteHeight[Std.int(par[3])] / 2)[1];
				var y1:Float = y
					+ (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / (FlxG.save.data.downscroll ? 0.7 : -0.7);
				var y2:Float = y
					+ (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / (FlxG.save.data.downscroll ? 0.7 : -0.7);
				var x1:Float = x;
				var x2:Float = x;

				if (Conductor.songPosition > 124800)
				{
					if (Conductor.songPosition < etime)
					{
						var slen = sorder / par[7];
						var elen = eorder / par[7];
						if (Conductor.songPosition > stime - sorder * 300 / 4)
						{
							slen = (sorder - (Conductor.songPosition - stime + sorder * 300 / 4) / (300 / 4)) / par[7];
							elen = (eorder - (Conductor.songPosition - stime + sorder * 300 / 4) / (300 / 4)) / par[7];
						}
						var sdiff = 100 * FlxMath.fastSin(((Conductor.songPosition + 150 - 150 * slen) % 300) / 300 * Math.PI);
						var ediff = 100 * FlxMath.fastSin(((Conductor.songPosition + 150 - 150 * elen) % 300) / 300 * Math.PI);
						if ((Conductor.songPosition % 300) / 300 >= (slen + 1) / 2)
							sdiff = 0;
						if ((Conductor.songPosition % 300) / 300 >= (elen + 1) / 2)
							ediff = 0;
						switch (par[3])
						{
							case 0:
								x1 -= sdiff;
								x2 -= ediff;
							case 1:
								y1 += sdiff;
								y2 += ediff;
							case 2:
								y1 -= sdiff;
								y2 -= ediff;
							case 3:
								x1 += sdiff;
								x2 += ediff;
						}
					}
					else if (Conductor.songPosition % 300 <= 150)
					{
						var diff = 100 * FlxMath.fastCos((Conductor.songPosition % 150) / 300 * Math.PI);
						switch (par[3])
						{
							case 0:
								x1 -= diff;
								x2 -= diff;
							case 1:
								y1 += diff;
								y2 += diff;
							case 2:
								y1 -= diff;
								y2 -= diff;
							case 3:
								x1 += diff;
								x2 += diff;
						}
					}
				}

				var p0:Array<Float> = NoteObject.toScreen(x1 - par[2] / 2, y1, par[5]);
				var p1:Array<Float> = NoteObject.toScreen(x1 + par[2] / 2, y1, par[5]);
				var p2:Array<Float> = NoteObject.toScreen(x2 - par[2] / 2, y2, par[5]);
				var p3:Array<Float> = NoteObject.toScreen(x2 + par[2] / 2, y2, par[5]);

				if (par[5] < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 4: // lol [stime,etime,width,ang]
				var ang:Float = (Conductor.songPosition / 2400) * 360;

				var tael:Float = tail;

				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var sdis:Float = 300 + (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 2;
				var edis:Float = 300 + (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 2;

				if (sdis < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				if (edis < 0)
				{
					tael = head + (sdis) / (sdis - edis) * (tail - head);
					edis = 0;
				}

				var x1:Float = 640 - FlxMath.fastCos(par[3] / 180 * Math.PI) * par[2] / 2 + FlxMath.fastSin(par[3] / 180 * Math.PI) * sdis;
				var y1:Float = 360 - FlxMath.fastSin(par[3] / 180 * Math.PI) * par[2] / 2 - FlxMath.fastCos(par[3] / 180 * Math.PI) * sdis;
				var x2:Float = 640 + FlxMath.fastCos(par[3] / 180 * Math.PI) * par[2] / 2 + FlxMath.fastSin(par[3] / 180 * Math.PI) * sdis;
				var y2:Float = 360 + FlxMath.fastSin(par[3] / 180 * Math.PI) * par[2] / 2 - FlxMath.fastCos(par[3] / 180 * Math.PI) * sdis;
				var x3:Float = 640 - FlxMath.fastCos(par[3] / 180 * Math.PI) * par[2] / 2 + FlxMath.fastSin(par[3] / 180 * Math.PI) * edis;
				var y3:Float = 360 - FlxMath.fastSin(par[3] / 180 * Math.PI) * par[2] / 2 - FlxMath.fastCos(par[3] / 180 * Math.PI) * edis;
				var x4:Float = 640 + FlxMath.fastCos(par[3] / 180 * Math.PI) * par[2] / 2 + FlxMath.fastSin(par[3] / 180 * Math.PI) * edis;
				var y4:Float = 360 + FlxMath.fastSin(par[3] / 180 * Math.PI) * par[2] / 2 - FlxMath.fastCos(par[3] / 180 * Math.PI) * edis;

				var z:Float = 200 + 360 * FlxMath.fastSin(Math.PI / 12);

				var p0 = NoteObject.multiWorldSpin(x1, y1, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];
				var p1 = NoteObject.multiWorldSpin(x2, y2, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];
				var p2 = NoteObject.multiWorldSpin(x3, y3, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];
				var p3 = NoteObject.multiWorldSpin(x4, y4, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];

				uvt = [0, head, 1, head, 0, tael, 1, tael];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 5: // [stime,etime,width]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var sz:Float = 1000 - 100 * (stime - Conductor.songPosition) / 300;
				var sdis:Float = (stime - Conductor.songPosition) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 4;
				var sang:Float = (stime - Conductor.songPosition) / 600;

				var ez:Float = 1000 - 100 * (stime - Conductor.songPosition) / 300;
				var edis:Float = (etime - Conductor.songPosition) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / 4;
				var eang:Float = (etime - Conductor.songPosition) / 600;

				// x+cos,y+sin
				var x1:Float = 640 - FlxMath.fastSin(sang * Math.PI) * par[2] / 2 + FlxMath.fastCos(sang * Math.PI) * sdis;
				var y1:Float = 360 + FlxMath.fastCos(sang * Math.PI) * par[2] / 2 + FlxMath.fastSin(sang * Math.PI) * sdis;
				var x2:Float = 640 + FlxMath.fastSin(sang * Math.PI) * par[2] / 2 + FlxMath.fastCos(sang * Math.PI) * sdis;
				var y2:Float = 360 - FlxMath.fastCos(sang * Math.PI) * par[2] / 2 + FlxMath.fastSin(sang * Math.PI) * sdis;
				var x3:Float = 640 - FlxMath.fastSin(eang * Math.PI) * par[2] / 2 + FlxMath.fastCos(eang * Math.PI) * edis;
				var y3:Float = 360 + FlxMath.fastCos(eang * Math.PI) * par[2] / 2 + FlxMath.fastSin(eang * Math.PI) * edis;
				var x4:Float = 640 + FlxMath.fastSin(eang * Math.PI) * par[2] / 2 + FlxMath.fastCos(eang * Math.PI) * edis;
				var y4:Float = 360 - FlxMath.fastCos(eang * Math.PI) * par[2] / 2 + FlxMath.fastSin(eang * Math.PI) * edis;

				var p0:Array<Float> = NoteObject.toScreen(x1, y1, sz);
				var p1:Array<Float> = NoteObject.toScreen(x2, y2, sz);
				var p2:Array<Float> = NoteObject.toScreen(x3, y3, ez);
				var p3:Array<Float> = NoteObject.toScreen(x4, y4, ez);

				if (ez < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
		}
		return null;
	}
}
