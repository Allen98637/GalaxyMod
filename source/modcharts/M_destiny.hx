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

class M_destiny
{
	public static var generated:Int = 0;
	public static var remains:Array<Int> = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
	public static var objs:Array<NoteObject> = [];

	public static function reset()
	{
		generated = 0;
		remains = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
		objs = [];
	}

	public static function pos(daNote:Note)
	{
		if (daNote.strumTime < 12715.23178807947)
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = 1 - (daNote.strumTime - Conductor.songPosition - 794.701986755) / 397.350993377;
				if (daNote.isSustainNote)
					daNote.alpha *= 0.6;
				var ylist:Array<Float> = [-40, 160, 560, 760];
				var y:Float = ylist[daNote.noteData];
				if (daNote.strumTime >= 9536.423841059603)
				{
					if (FlxG.save.data.downscroll)
						y = NoteObject.toWorld(0,
							(550
								+ (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[daNote.noteData] / 2)[1];
					else
						y = NoteObject.toWorld(0,
							(50
								- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[daNote.noteData] / 2)[1];
				}
				else if (daNote.strumTime > 6357.6158940397345)
					y = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[daNote.noteData] / 2)[1],
						(daNote.strumTime - 6357.6158940397345) / 3178.80794702);
				else if (daNote.strumTime > 4768.2119205298)
					y = 360;
				else if (daNote.strumTime > 3178.8079470198672)
					y = FlxMath.lerp(ylist[daNote.noteData], 360, (daNote.strumTime - 3178.8079470198672) / 1589.40397351);
				daNote.z = 200 / 0.7 + FlxMath.fastSin((daNote.strumTime / 794.701986755 - 1 + daNote.noteData * 0.5) * Math.PI) * 50;
				daNote.wx = 150 + FlxMath.fastCos((daNote.strumTime / 794.701986755 - 1 + daNote.noteData * 0.5) * Math.PI) * 270;
				if (daNote.strumTime > 11125.827814569537)
				{
					daNote.z = 200 / 0.7 + FlxMath.fastSin((daNote.strumTime / 794.701986755 * 2 - 1 + daNote.noteData * 0.5) * Math.PI) * 50;
					daNote.wx = 150 + FlxMath.fastCos((daNote.strumTime / 794.701986755 * 2 - 1 + daNote.noteData * 0.5) * Math.PI) * 270;
				}
				daNote.wy = y;
				var x2:Float = NoteObject.toScreen(daNote.wx + Note.noteWidth[daNote.noteData] / 1.4, daNote.wy, daNote.z)[0];
				var x1:Float = NoteObject.toScreen(daNote.wx - Note.noteWidth[daNote.noteData] / 1.4, daNote.wy, daNote.z)[0];
				if (!daNote.isSustainNote)
				{
					daNote.setGraphicSize(Std.int(x2 - x1));
					daNote.updateHitbox();
				}
				daNote.x = x1;
				daNote.y = NoteObject.toScreen(daNote.wx - Note.noteWidth[daNote.noteData] / 1.4, daNote.wy - Note.noteWidth[daNote.noteData] / 1.4,
					daNote.z)[1];
				if (daNote.isSustainNote)
				{
					var h:Float = daNote.height * 0.7;
					var len:Float = Conductor.stepCrochet;
					if (daNote.animation.curAnim.name.endsWith('hold'))
					{
						h *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
					}
					else
					{
						len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
					}
					if (FlxG.save.data.downscroll)
					{
						y += h;
						h *= -1;
					}
					daNote.renderer = new R_destiny(0, [
						daNote.strumTime - Conductor.stepCrochet,
						daNote.strumTime - Conductor.stepCrochet + len,
						daNote.noteData,
						daNote.width
					]);
					if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet)
						daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
					daNote.pathrender();
				}
			}
		}
		else if (daNote.strumTime > 14304 && (daNote.strumTime < 27019 || (daNote.strumTime < 27218 && daNote.mustPress)))
		{
			var diff = (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
			diff = (diff + 250) * (diff + 250) * (diff + 250) / (250 * 250) - 250;
			if (FlxG.save.data.downscroll)
				daNote.y = (550 + diff);
			else
				daNote.y = (50 - (diff));
			if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
			{
				var diff2 = (Conductor.songPosition - daNote.strumTime - Conductor.stepCrochet) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				diff2 = (diff2 + 250) * (diff2 + 250) * (diff2 + 250) / (250 * 250) - 250;
				var diff3 = Std.int(Math.abs(diff - diff2));
				if (diff3 == 0)
					daNote.setGraphicSize(Std.int(daNote.width), 1);
				else
					daNote.setGraphicSize(Std.int(daNote.width), diff3);
				daNote.updateHitbox();
			}
			if (daNote.spec > 0)
			{
				var poses:Array<Array<Float>> = [[], [168, 150], [468, 360], [168, 570], [808, 150], [1108, 360], [808, 570]];

				if (daNote.isEnd)
				{
					daNote.scale.set(0.5, 0.5);
					daNote.updateHitbox();
					daNote.x = poses[daNote.spec][0] - (daNote.width + daNote.offset.x) / 2;
					daNote.y = poses[daNote.spec][1] - (daNote.height + daNote.offset.y) / 2;
					daNote.z = 250;
					daNote.alpha = (Conductor.songPosition - daNote.strumTime + 794.701986755) / 397.350993377;
				}
				else if (daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						case 0:
							daNote.animation.play('purplehold');
						case 1:
							daNote.animation.play('bluehold');
						case 2:
							daNote.animation.play('greenhold');
						case 3:
							daNote.animation.play('redhold');
					}
					daNote.z = 280;
					daNote.alpha = ((Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet * (daNote.sustainOrder + 1) +
						794.701986755) / 397.350993377) * 0.8;
					if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet * (daNote.sustainOrder + 1) - 397.350993377)
						daNote.alpha = 0.8;
					daNote.renderer = new RenderPath(0, [
						daNote.sustainOrder,
						daNote.sustainLength,
						poses[daNote.spec][0],
						poses[daNote.spec][1],
						90
					]);
					if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / Conductor.stepCrochet;
					daNote.pathrender();
				}
				else
				{
					var sc = (1 + (daNote.strumTime - Conductor.songPosition) / 397.350993377) * 0.7;
					if (Conductor.songPosition > daNote.strumTime)
						sc = 0.7;
					daNote.scale.set(sc, sc);
					daNote.x = poses[daNote.spec][0] - daNote.width / 2;
					daNote.y = poses[daNote.spec][1] - daNote.height / 2;
					daNote.z = 200;
					daNote.alpha = 1 - (daNote.strumTime - Conductor.songPosition) / 794.701986755;
				}
			}
		}
		else if (daNote.strumTime >= 27019 && (daNote.strumTime < 39734 || (daNote.strumTime < 39835 && daNote.mustPress)))
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;
			}
			daNote.wx = 100 + 320 * daNote.noteData + FlxMath.fastSin((daNote.strumTime / 794.701986755 + daNote.noteData) * Math.PI) * 150;
			daNote.z = 200 / 0.7 + FlxMath.fastCos((daNote.strumTime / 794.701986755 + daNote.noteData) * Math.PI) * 50;
			if (FlxG.save.data.downscroll)
				daNote.wy = (670 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.wy = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			daNote.scaleW();
			if (daNote.isSustainNote)
			{
				daNote.renderer = new R_destiny(1, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime,
					daNote.noteData,
					daNote.width
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / Conductor.stepCrochet;
				daNote.pathrender();
			}
		}
		else if (daNote.strumTime >= 39735 && daNote.strumTime < 65165)
		{
			if (!daNote.mustPress)
			{
				daNote.alpha = daNote.isSustainNote ? 0.36 : 0.6;
			}
			var spins:Array<Array<Float>> = [
				[
					0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, -20, -10, 5, 20, 0, 5, -20, -10, 5, 20, 0, 5, -20,
					-10,
					5, 20, 0, 5, -20, -10, 5, 20, 0, 5
				],
				[
					0, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5,
					-15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5
				],
				[
					0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					0, 0
				],
				[
					640, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280,
					640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640
				],
				[
					360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 720, 720,
					360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720
				],
				[
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
					200 / 0.7,
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
					200 / 0.7,
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
					200 / 0.7,
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7
				]
			];
			var st:Float = (Conductor.songPosition - 39735.09933774834) / 397.350993377;
			if (Conductor.songPosition < 39735.09933774834)
				st = 0;
			var round:Int = Std.int(Math.floor(st / 4));
			var non:Array<Array<Float>> = [];
			if (st % 4 > 3.9)
			{
				for (i in 0...6)
				{
					if (i < 3)
						spins[i][round * 3 + 3] *= PlayMoving.ease((st % 4 - 3.9) * 10, 1);
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 4));
				}
			}
			else if (st % 4 >= 3)
			{
				for (i in 0...6)
				{
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
				}
			}
			else if (st % 4 > 2.9)
			{
				for (i in 0...6)
				{
					if (i < 3)
						spins[i][round * 3 + 2] *= PlayMoving.ease((st % 4 - 2.9) * 10, 1);
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
				}
			}
			else if (st % 4 >= 1.5)
			{
				for (i in 0...6)
				{
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
				}
			}
			else if (st % 4 > 1.4)
			{
				for (i in 0...6)
				{
					if (i < 3)
						spins[i][round * 3 + 1] *= PlayMoving.ease((st % 4 - 1.4) * 10, 1);
					non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
				}
			}
			else
			{
				for (i in 0...6)
				{
					non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 1));
				}
			}
			var x:Float = 640 - daNote.width * 0.35;
			var y:Float = 360 - daNote.height * 0.35;
			switch (daNote.noteData)
			{
				case 0:
					x += (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				case 1:
					y -= (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				case 2:
					y += (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
				case 3:
					x -= (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
			}
			var w:Float = daNote.width * 0.7;
			var h:Float = daNote.height * 0.7;
			var tri:Array<Array<Float>> = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, non[0], non[1], non[2], non[3], non[4], non[5]);
			daNote.render(tri[0], tri[1]);
		}
		else if (daNote.strumTime >= 65165 && daNote.strumTime < 90503)
		{
			if (!daNote.mustPress)
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8;
			var st:Float = (Conductor.songPosition - 65165.56291390731) / 397.350993377;
			var times:Array<Float> = [
				0, 65165.56291390731, 65960.26490066228, 66754.96688741725, 67549.66887417222, 68344.37086092719, 69139.07284768215, 71523.17880794706,
				72317.88079470203, 73112.582781457, 73907.28476821196, 74701.98675496693, 75496.6887417219, 77880.7947019868, 78675.49668874177,
				79470.19867549674, 80264.9006622517, 84238.41059602654, 85033.11258278151, 85827.81456953648, 86622.51655629145
			];
			if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				daNote.renderer = new R_destiny(2, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width,
					daNote.noteData
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else
			{
				var time:Float = daNote.strumTime;
				if (daNote.spec != 0)
				{
					time = times[daNote.spec];
					if ((daNote.strumTime / 397.350993377) % 2 < 1.2 || (daNote.strumTime / 397.350993377) % 2 > 1.8)
						daNote.alpha = 0;
				}
				var mst:Float = (time - 65165.56291390731) / 397.350993377;
				daNote.wx = 640 + 300 * FlxMath.fastCos(time / 794.701986755 * Math.PI);
				daNote.wy = 360 + 200 * FlxMath.fastSin(time / 794.701986755 * Math.PI);
				if (mst >= 32)
				{
					daNote.wx = 190 + 300 * daNote.noteData;
					daNote.wy = 360 + 400 * FlxMath.fastSin(time / 794.701986755 * Math.PI);
				}
				var group:Float = Math.floor(Math.floor(mst / 2) - st / 2);
				if (daNote.spec == 0)
				{
					group += (mst / 2) % 1;
				}
				if ((st > 12 && st < 16) || (st > 28 && st < 32) || (st > 40 && st < 48) || (st > 56 && st < 64) || st < 0)
				{
					daNote.z = 200 + 1050 * (mst - st) / 2;
				}
				else if (st % 2 > 1.5)
				{
					daNote.z = 200 + 1050 * group + 50 + 2000 * (2 - st % 2);
				}
				else
				{
					group += 1;
					daNote.z = 200 + 1050 * group + 50 * (1.5 - st % 2) / 1.5;
				}
				daNote.scaleW();
			}
		}
		else if (daNote.strumTime >= 90596 && daNote.strumTime < 115828)
		{
			/*if (!daNote.mustPress)
				daNote.alpha = daNote.isSustainNote ? 0.48 : 0.8; */
			if (daNote.isSustainNote)
			{
				daNote.z = 300;
				if (Conductor.songPosition > 103311.25827814577)
					daNote.z = 300
						+ 300 * Math.abs(FlxMath.fastSin(((Conductor.songPosition +
							daNote.sustainOrder * Conductor.stepCrochet) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				daNote.renderer = new R_destiny(3, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width,
					daNote.noteData,
					daNote.sustainOrder,
					(daNote.mustPress ? 1 : 0)
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
			}
			else
			{
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				if (Conductor.songPosition < 90596.02649006629)
					ang = 0;
				var x = 160 * (1.5 - daNote.noteData);
				var y = (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2)) * (FlxG.save.data.downscroll ? 1 : -1) * (daNote.mustPress ? 1 : -1);
				daNote.wx = 640 - FlxMath.fastCos(ang) * x - FlxMath.fastSin(ang) * y;
				daNote.wy = 360 - FlxMath.fastSin(ang) * x + FlxMath.fastCos(ang) * y;
				daNote.z = 300;
				if (Conductor.songPosition > 103311.25827814577)
					daNote.z = 300 + 300 * Math.abs(FlxMath.fastSin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
				daNote.scaleW();
			}
		}
		else if (daNote.strumTime > 116026)
		{
			if (daNote.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!daNote.animation.curAnim.name.endsWith('hold'))
				{
					len /= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				}
				daNote.renderer = new R_destiny(4, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					daNote.width,
					daNote.noteData,
					(daNote.mustPress ? 1 : 0)
				]);
				if (Conductor.songPosition > daNote.strumTime - Conductor.stepCrochet
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					daNote.renderer.bili = 1 - (Conductor.songPosition - daNote.strumTime + Conductor.stepCrochet) / len;
				daNote.pathrender();
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				if (Conductor.songPosition < 116026.49006622526)
					ang = 0;
				daNote.z = 200 / 0.7 - FlxMath.fastSin(ang) * (daNote.mustPress ? 100 : -100);
			}
			else
			{
				var x = NoteObject.toWorld(daNote.mustPress ? 1040 : 240, 360)[0];
				daNote.wy = NoteObject.toWorld(640,
					(FlxG.save.data.downscroll ? (550 + Note.noteHeight[daNote.noteData] / 2) : (50 + Note.noteHeight[daNote.noteData] / 2)) +
					(Conductor.songPosition
						- daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * (FlxG.save.data.downscroll ? 1 : -1))[1];
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				if (Conductor.songPosition < 116026.49006622526)
					ang = 0;
				daNote.z = 200 / 0.7 - FlxMath.fastSin(ang) * (daNote.mustPress ? 100 : -100);
				daNote.wx = 640 + FlxMath.fastCos(ang) * (x - 640) + 160 * (daNote.noteData - 1.5);
				if (daNote.isEnd)
				{
					daNote.offsetWhenDraw = false;
					// daNote.wx -= 18;
					// daNote.wy -= FlxG.save.data.downscroll ? 36 : 18;
				}
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
		if (Conductor.songPosition < 12715.23178807947)
		{
			if (dastrum.player == 0)
			{
				var zlist:Array<Float> = [200 / 0.7, 200 / 0.7 - 50, 200 / 0.7, 200 / 0.7 + 50];
				var ylist:Array<Float> = [-40, 160, 560, 760];
				var y:Float = ylist[dastrum.ID];
				if (Conductor.songPosition > 9536.423841059603)
					y = NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[dastrum.ID] / 2)[1];
				else if (Conductor.songPosition > 6357.6158940397345)
					y = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[dastrum.ID] / 2)[1],
						(Conductor.songPosition - 6357.6158940397345) / 3178.80794702);
				else if (Conductor.songPosition > 4768.2119205298)
					y = 360;
				else if (Conductor.songPosition > 3178.8079470198672)
					y = FlxMath.lerp(ylist[dastrum.ID], 360, (Conductor.songPosition - 3178.8079470198672) / 1589.40397351);
				dastrum.z = 200 / 0.7 + FlxMath.fastSin((Conductor.songPosition / 794.701986755 - 1 + dastrum.ID * 0.5) * Math.PI) * 50;
				dastrum.wx = 150 + FlxMath.fastCos((Conductor.songPosition / 794.701986755 - 1 + dastrum.ID * 0.5) * Math.PI) * 270;
				if (Conductor.songPosition > 11125.827814569537)
				{
					dastrum.z = 200 / 0.7 + FlxMath.fastSin((Conductor.songPosition / 794.701986755 * 2 - 1 + dastrum.ID * 0.5) * Math.PI) * 50;
					dastrum.wx = 150 + FlxMath.fastCos((Conductor.songPosition / 794.701986755 * 2 - 1 + dastrum.ID * 0.5) * Math.PI) * 270;
				}
				dastrum.wy = y;
				var x2:Float = NoteObject.toScreen(dastrum.wx + Note.noteWidth[dastrum.ID] / 1.4, dastrum.wy, dastrum.z)[0];
				var x1:Float = NoteObject.toScreen(dastrum.wx - Note.noteWidth[dastrum.ID] / 1.4, dastrum.wy, dastrum.z)[0];
				dastrum.setGraphicSize(Std.int(x2 - x1));
				dastrum.updateHitbox();
				dastrum.x = x1;
				dastrum.y = NoteObject.toScreen(dastrum.wx - Note.noteWidth[dastrum.ID] / 1.4, dastrum.wy - Note.noteWidth[dastrum.ID] / 1.4, dastrum.z)[1];
				dastrum.spec = -1;
			}
		}
		if (Conductor.songPosition > 12715.23178807947 && Conductor.songPosition <= 13907.2847682)
		{
			if (dastrum.spec == -1)
			{
				dastrum.wy = NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[dastrum.ID] / 2)[1]
					+ (Conductor.songPosition - 12715.23178807947) * (Conductor.songPosition - 12715.23178807947) / 500;
				var x2:Float = NoteObject.toScreen(dastrum.wx + Note.noteWidth[dastrum.ID] / 1.4, dastrum.wy, dastrum.z)[0];
				var x1:Float = NoteObject.toScreen(dastrum.wx - Note.noteWidth[dastrum.ID] / 1.4, dastrum.wy, dastrum.z)[0];
				dastrum.setGraphicSize(Std.int(x2 - x1));
				dastrum.updateHitbox();
				dastrum.x = x1;
				dastrum.y = NoteObject.toScreen(dastrum.wx - Note.noteWidth[dastrum.ID] / 1.4, dastrum.wy - Note.noteWidth[dastrum.ID] / 1.4, dastrum.z)[1];
				if (dastrum.y >= FlxG.height)
					dastrum.mustBeKilled = true;
			}
			else if (dastrum.player == 0)
			{
				if (FlxG.save.data.downscroll)
				{
					dastrum.y = 550 + PlayMoving.ease((13907.2847682 - Conductor.songPosition) / 397.350993377, 0) * (FlxG.height - 550);
				}
				else
				{
					dastrum.y = 50 + PlayMoving.ease((13907.2847682 - Conductor.songPosition) / 397.350993377, 0) * (-dastrum.height - 50);
				}
			}
		}
		else if (Conductor.songPosition > 14304.635761589405 && Conductor.songPosition <= 26622.516556291383 && dastrum.spec > 0)
		{
			var times:Array<Float> = [
				0,
				15894.039735099339,
				16291.390728476823,
				16688.741721854305,
				22251.65562913907,
				22649.006622516554,
				23046.357615894038
			];
			var holds:Array<Float> = [0, 1, 1, 1.5, 1, 1, 1.5];
			dastrum.alpha = (Conductor.songPosition - times[dastrum.spec] + 794.701986755) / 397.350993377;
			if (Conductor.songPosition > times[dastrum.spec] + 397.350993377 * holds[dastrum.spec])
				dastrum.mustBeKilled = true;
		}
		else if (Conductor.songPosition >= 27019.867549668867 && Conductor.songPosition < 39635.09933774834)
		{
			if (dastrum.spec == 1)
			{
				dastrum.alpha += 0.05;
				dastrum.wx = 100 + 320 * dastrum.ID + FlxMath.fastSin((Conductor.songPosition / 794.701986755 + dastrum.ID) * Math.PI) * 150;
				dastrum.z = 200 / 0.7 + FlxMath.fastCos((Conductor.songPosition / 794.701986755 + dastrum.ID) * Math.PI) * 50;
				dastrum.scaleW();
			}
			else
			{
				dastrum.y = (FlxG.save.data.downscroll ? 550 : 50)
					+ (Conductor.songPosition - 27019.867549668867) * (Conductor.songPosition - 27019.867549668867) / 500;
				dastrum.angle += dastrum.player == 0 ? -3 : 3;
				if (dastrum.y >= FlxG.height)
					dastrum.mustBeKilled = true;
			}
		}
		else if (Conductor.songPosition >= 39635.09933774834 && Conductor.songPosition < 39735.09933774834)
		{
			dastrum.wx = FlxMath.lerp(100 + 320 * dastrum.ID + FlxMath.fastSin(dastrum.ID * Math.PI) * 150, 640,
				(Conductor.songPosition - 39635.09933774834) / 100);
			dastrum.wy = FlxMath.lerp(FlxG.save.data.downscroll ? 670 : 50, 360, (Conductor.songPosition - 39635.09933774834) / 100);
			dastrum.z = FlxMath.lerp(200 / 0.7 + FlxMath.fastCos(dastrum.ID * Math.PI) * 50, 200 / 0.7, (Conductor.songPosition - 39635.09933774834) / 100);
			dastrum.scaleW();
		}
		else if (Conductor.songPosition >= 39735.09933774834 && Conductor.songPosition < 65165.56291390731)
		{
			dastrum.z = 200 / 0.7;
			var spins:Array<Array<Float>> = [
				[
					0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, -20, -10, 5, 20, 0, 5, -20, -10, 5, 20, 0, 5, -20,
					-10,
					5, 20, 0, 5, -20, -10, 5, 20, 0, 5
				],
				[
					0, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5,
					-15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5
				],
				[
					0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					0, 0
				],
				[
					640, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280,
					640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640
				],
				[
					360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 720, 720,
					360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720
				],
				[
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
					200 / 0.7,
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
					200 / 0.7,
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
					200 / 0.7,
					200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7
				]
			];
			var st:Float = (Conductor.songPosition - 39735.09933774834) / 397.350993377;
			var round:Int = Std.int(Math.floor(st / 4));
			var non:Array<Array<Float>> = [];
			if (st % 4 > 3.9)
			{
				for (i in 0...6)
				{
					if (i < 3)
						spins[i][round * 3 + 3] *= PlayMoving.ease((st % 4 - 3.9) * 10, 1);
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 4));
				}
			}
			else if (st % 4 >= 3)
			{
				for (i in 0...6)
				{
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
				}
			}
			else if (st % 4 > 2.9)
			{
				for (i in 0...6)
				{
					if (i < 3)
						spins[i][round * 3 + 2] *= PlayMoving.ease((st % 4 - 2.9) * 10, 1);
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
				}
			}
			else if (st % 4 >= 1.5)
			{
				for (i in 0...6)
				{
					non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
				}
			}
			else if (st % 4 > 1.4)
			{
				for (i in 0...6)
				{
					if (i < 3)
						spins[i][round * 3 + 1] *= PlayMoving.ease((st % 4 - 1.4) * 10, 1);
					non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
				}
			}
			else
			{
				for (i in 0...6)
				{
					non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 1));
				}
			}
			var x:Float = 640 - dastrum.width * 0.35;
			var y:Float = 360 - dastrum.height * 0.35;
			var w:Float = dastrum.width * 0.7;
			var h:Float = dastrum.height * 0.7;
			if (dastrum.animation.curAnim.name == 'confirm')
			{
				x -= (238 - 157) / 2 * 0.7;
				y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var tri:Array<Array<Float>> = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, non[0], non[1], non[2], non[3], non[4], non[5]);

			dastrum.render(tri[0], tri[1]);
		}
		else if (Conductor.songPosition >= 65165.56291390731 && Conductor.songPosition < 65265.56291390731)
		{
			dastrum.alpha = (65265.56291390731 - Conductor.songPosition) / 100;
		}
		else if (Conductor.songPosition >= 65265.56291390731 && Conductor.songPosition < 90596.02649006629)
		{
			dastrum.rendermode = 0;
			if (Conductor.songPosition > 79470.19867549674)
			{
				dastrum.wx = 190 + 300 * dastrum.ID;
				dastrum.wy = 360 + 400 * FlxMath.fastSin(Conductor.songPosition / 794.701986755 * Math.PI);
			}
			else
			{
				dastrum.wx = 640 + 300 * FlxMath.fastCos(Conductor.songPosition / 794.701986755 * Math.PI);
				dastrum.wy = 360 + 200 * FlxMath.fastSin(Conductor.songPosition / 794.701986755 * Math.PI);
			}
			dastrum.z = 200;
			if (Conductor.songPosition > 69933.77483443712 && Conductor.songPosition < 71523.17880794706)
				dastrum.alpha = 0.1;
			else if (Conductor.songPosition > 69833.77483443712 && Conductor.songPosition < 69933.77483443712)
				dastrum.alpha = (Conductor.songPosition - 69833.77483443712) / 1000;
			else if (Conductor.songPosition > 76291.39072847686 && Conductor.songPosition < 77880.7947019868)
				dastrum.alpha = 0.1;
			else if (Conductor.songPosition > 76191.39072847686 && Conductor.songPosition < 76291.39072847686)
				dastrum.alpha = (Conductor.songPosition - 76191.39072847686) / 1000;
			else if (Conductor.songPosition > 81059.60264900667 && Conductor.songPosition < 84238.41059602654)
				dastrum.alpha = 0.4;
			else if (Conductor.songPosition > 80959.60264900667 && Conductor.songPosition < 81059.60264900667)
				dastrum.alpha = (Conductor.songPosition - 80959.60264900667) / 250;
			else if (Conductor.songPosition > 87417.21854304642 && Conductor.songPosition < 90596.02649006629)
				dastrum.alpha = 0.4;
			else if (Conductor.songPosition > 87317.21854304642 && Conductor.songPosition < 87417.21854304642)
				dastrum.alpha = (Conductor.songPosition - 87317.21854304642) / 250;
			else
				dastrum.alpha = 0;
			dastrum.scaleW();
		}
		else if (Conductor.songPosition > 90596.02649006629 && Conductor.songPosition < 115926.49006622526)
		{
			if (dastrum.spec == 0)
			{
				dastrum.alpha = 1;
				if (Conductor.songPosition < 90696.02649006629)
					dastrum.alpha = (Conductor.songPosition - 90596.02649006629) / 100;
				dastrum.z = 300;
				if (Conductor.songPosition > 103311.25827814577)
					dastrum.z = 300 + 300 * Math.abs(FlxMath.fastSin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
				if (dastrum.player == 1)
				{
					if (Conductor.songPosition < 90696.02649006629)
						dastrum.alpha = (Conductor.songPosition - 90596.02649006629) / 100;
					var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
					if (Conductor.songPosition % 794.701986755 > 694.701986755)
						ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
					dastrum.wx = 640 + 160 * (dastrum.ID - 1.5) * FlxMath.fastCos(ang);
					dastrum.wy = 360 + 160 * (dastrum.ID - 1.5) * FlxMath.fastSin(ang);
					dastrum.scaleW();
				}
				else
				{
					dastrum.alpha *= 0.8;
					var ang:Float = (Conductor.songPosition % 794.701986755) / 794.701986755;
					dastrum.wx = 640 + 500 * FlxMath.fastSin(ang * 2 * Math.PI);
					dastrum.wy = 360 - 500 * FlxMath.fastCos(ang * 2 * Math.PI);
					dastrum.angle = ang * 360;
					dastrum.scaleW();
				}
			}
			else
			{
				dastrum.z += 10;
				dastrum.scaleW();
				if (dastrum.z > 10000)
				{
					dastrum.mustBeKilled = true;
				}
			}
		}
		else if (Conductor.songPosition > 115926.49006622526)
		{
			if (dastrum.spec == -1)
			{
				dastrum.alpha = 1;
				if (Conductor.songPosition < 116026.49006622526)
					dastrum.alpha = (Conductor.songPosition - 115926.49006622526) / 100;
				var x = NoteObject.toWorld(dastrum.player == 1 ? 1040 : 240, 360)[0];
				dastrum.wy = NoteObject.toWorld(640,
					FlxG.save.data.downscroll ? (550 + Note.noteHeight[dastrum.ID] / 2) : (50 + Note.noteHeight[dastrum.ID] / 2))[1];
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				dastrum.z = 200 / 0.7 - FlxMath.fastSin(ang) * (dastrum.player == 1 ? 100 : -100);
				dastrum.wx = 640 + FlxMath.fastCos(ang) * (x - 640) + 160 * (dastrum.ID - 1.5);
				dastrum.scaleW();
			}
			else if (dastrum.spec == -2)
			{
				dastrum.alpha = 1;
				if (Conductor.songPosition < 116026.49006622526)
					dastrum.alpha = (Conductor.songPosition - 115926.49006622526) / 100;
				dastrum.alpha *= 0.8;
				dastrum.x = 640 - dastrum.width / 2;
				dastrum.y = 360 - dastrum.height / 2;
				var ang:Float = (Conductor.songPosition % 794.701986755) / 794.701986755;
				dastrum.angle = Math.floor(ang * 48) / 48 * 360;
			}
			else if (dastrum.spec == -3)
			{
				dastrum.alpha = 1;
				if (Conductor.songPosition < 116026.49006622526)
					dastrum.alpha = (Conductor.songPosition - 115926.49006622526) / 100;
				dastrum.alpha *= 0.6;
				var ang:Float = (Conductor.songPosition % 16.5562913907) / 16.5562913907;
				ang = Math.floor(ang * 48) / 48;
				dastrum.x = 640 + 150 * FlxMath.fastSin(ang * 2 * Math.PI) - dastrum.width / 2;
				dastrum.y = 360 - 150 * FlxMath.fastCos(ang * 2 * Math.PI) - dastrum.height / 2;
				dastrum.angle = ang * 360;
			}
			else
			{
				if (dastrum.player == 1)
				{
					var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
					if (Conductor.songPosition % 794.701986755 > 694.701986755)
						ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
					dastrum.wx = 640 + 160 * (dastrum.ID - 1.5) * FlxMath.fastCos(ang);
					dastrum.wy = 360 + 160 * (dastrum.ID - 1.5) * FlxMath.fastSin(ang);
					dastrum.scaleW();
				}
				else
				{
					var ang:Float = (Conductor.songPosition % 794.701986755) / 794.701986755;
					dastrum.wx = 640 + 500 * FlxMath.fastSin(ang * 2 * Math.PI);
					dastrum.wy = 360 - 500 * FlxMath.fastCos(ang * 2 * Math.PI);
					dastrum.angle = ang * 360;
					dastrum.scaleW();
				}
				if (Conductor.songPosition > 116026.49006622526)
					dastrum.z += 10;
				dastrum.scaleW();
				if (dastrum.z > 10000)
				{
					dastrum.mustBeKilled = true;
				}
			}
		}
	}

	public static function show(daNote:Note):Bool
	{
		if (daNote.strumTime < 9537)
		{
			return daNote.strumTime - Conductor.songPosition > 1192.05298013;
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return daNote.y < -daNote.height;
			else
				return daNote.y > FlxG.height;
		}
	}

	public static function kill(daNote:Note):Bool
	{
		if (daNote.strumTime > 14304 && daNote.strumTime < 27020 && daNote.spec > 0)
		{
			return true;
		}
		else if (daNote.strumTime >= 39735 && daNote.strumTime < 65165)
		{
			return Conductor.songPosition > 65165.56291390731;
		}
		else if (daNote.strumTime >= 65165 && daNote.strumTime < 90503)
		{
			if (daNote.spec != 0)
			{
				remains[daNote.spec] -= 1;
			}
			return true;
		}
		else if (daNote.strumTime >= 90596 && daNote.strumTime < 115828)
			return Conductor.songPosition > 116026.49006622526;
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
		if (daNote.strumTime >= 65165 && daNote.strumTime < 90502)
		{
			if (daNote.spec != 0)
			{
				remains[daNote.spec] -= 1;
			}
		}
	}

	public static function special(state:PlayState)
	{
		if (Conductor.songPosition > 13509.933774834437 && generated < 1)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i);
				ar.y = FlxG.height;
			}
			generated = 1;
		}
		if (Conductor.songPosition > 14304.635761589405 && generated < 2)
		{
			for (i in 1...7)
			{
				var poses:Array<Array<Float>> = [[], [168, 150], [468, 360], [168, 570], [808, 150], [1108, 360], [808, 570]];
				var ids:Array<Int> = [0, 0, 3, 1, 0, 3, 1];
				var ar:NoteStrum = state.generateStaticArrow(i < 4 ? 0 : 1, ids[i], "null", i);
				ar.x = poses[i][0] - ar.width / 2;
				ar.y = poses[i][1] - ar.height / 2;
				ar.z = 250;
				ar.alpha = 0;
			}
			generated = 2;
		}
		if (Conductor.songPosition > 27019.867549668867 && generated < 3)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.wy = FlxG.save.data.downscroll ? 670 : 50;
				ar.alpha = 0;
			}
			generated = 3;
		}
		if (Conductor.songPosition >= 63576.15894039738 && Conductor.songPosition < 90502.53213868335)
		{
			if (generated < 4)
			{
				for (i in 1...21)
				{
					var nobj:NoteObject = new NoteObject(0, 0);
					nobj.spec = i;
					objs.push(nobj);
					state.addObject(nobj);
				}
				generated = 4;
			}
			for (daNote in objs)
			{
				var st:Float = (Conductor.songPosition - 65165.56291390731) / 397.350993377;
				var times:Array<Float> = [
					0, 65165.56291390731, 65960.26490066228, 66754.96688741725, 67549.66887417222, 68344.37086092719, 69139.07284768215, 71523.17880794706,
					72317.88079470203, 73112.582781457, 73907.28476821196, 74701.98675496693, 75496.6887417219, 77880.7947019868, 78675.49668874177,
					79470.19867549674, 80264.9006622517, 84238.41059602654, 85033.11258278151, 85827.81456953648, 86622.51655629145
				];
				var datas:Array<Float> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 0, 1, 2, 3, 0, 1];
				daNote.loadGraphic(Paths.image('num' + remains[daNote.spec]));
				daNote.strumTime = 0;
				var time:Float = times[daNote.spec];
				var mst:Float = (time - 65165.56291390731) / 397.350993377;
				daNote.wx = 640 + 300 * FlxMath.fastCos(time / 794.701986755 * Math.PI);
				daNote.wy = 360 + 200 * FlxMath.fastSin(time / 794.701986755 * Math.PI);
				if (mst >= 32)
				{
					daNote.wx = 190 + 300 * datas[daNote.spec];
					daNote.wy = 360 + 400 * FlxMath.fastSin(time / 794.701986755 * Math.PI);
				}
				var group:Float = Math.floor(Math.floor(mst / 2) - st / 2);
				if ((st > 12 && st < 16) || (st > 28 && st < 32) || (st > 40 && st < 48) || (st > 56 && st < 64) || st < 0)
				{
					daNote.z = 200 + 1050 * (mst - st) / 2;
				}
				else if (st % 2 > 1.5)
				{
					daNote.z = 200 + 1050 * group + 50 + 2000 * (2 - st % 2);
				}
				else
				{
					group += 1;
					daNote.z = 200 + 1050 * group + 50 * (1.5 - st % 2) / 1.5;
				}
				daNote.scaleW();
				daNote.z -= 100;
				if (remains[daNote.spec] <= 0)
				{
					state.destroyObject(daNote);
					objs.remove(daNote);
				}
			}
		}
		if (Conductor.songPosition > 90596.02649006629 && generated < 5)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.alpha = 0;
			}
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", 0);
			ar.alpha = 0.4;
			generated = 5;
		}
		if (Conductor.songPosition > 115926.49006622526 && generated < 6)
		{
			for (i in 0...8)
			{
				var ar:NoteStrum = state.generateStaticArrow(i < 4 ? 0 : 1, i % 4, "null", -1);
				ar.y = FlxG.height;
			}
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", -2);
			ar.alpha = 0.8;
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", -3);
			ar.alpha = 0.6;
			generated = 6;
		}
	}

	public static function beatHit(state:PlayState, curBeat:Int)
	{
		if (curBeat >= 36 && curBeat < 100)
		{
			if (state.camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				state.camHUD.zoom += 0.03;
			}
		}
	}
}

class R_destiny extends RenderPath
{
	override function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // 3dspin [stime, etime, noteData, width]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var ylist:Array<Float> = [-40, 160, 560, 760];
				var y:Float = ylist[Std.int(par[2])];
				var y2:Float = ylist[Std.int(par[2])];
				if (stime >= 9536.423841059603)
				{
					if (FlxG.save.data.downscroll)
						y = NoteObject.toWorld(0,
							(550
								+ (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(par[2])] / 2)[1];
					else
						y = NoteObject.toWorld(0,
							(50
								- (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(par[2])] / 2)[1];
				}
				else if (stime > 6357.6158940397345)
					y = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[Std.int(par[2])] / 2)[1],
						(stime - 6357.6158940397345) / 3178.80794702);
				else if (stime > 4768.2119205298)
					y = 360;
				else if (stime > 3178.8079470198672)
					y = FlxMath.lerp(ylist[Std.int(par[2])], 360, (stime - 3178.8079470198672) / 1589.40397351);

				if (etime > 9536.423841059603)
				{
					if (FlxG.save.data.downscroll)
						y2 = NoteObject.toWorld(0,
							(550
								+ (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(par[2])] / 2)[1];
					else
						y2 = NoteObject.toWorld(0,
							(50
								- (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(par[2])] / 2)[1];
				}
				else if (etime > 6357.6158940397345)
					y2 = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[Std.int(par[2])] / 2)[1],
						(etime - 6357.6158940397345) / 3178.80794702);
				else if (etime > 4768.2119205298)
					y2 = 360;
				else if (etime > 3178.8079470198672)
					y2 = FlxMath.lerp(ylist[Std.int(par[2])], 360, (etime - 3178.8079470198672) / 1589.40397351);

				var z1:Float = 200 / 0.7 + FlxMath.fastSin((stime / 794.701986755 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 50;
				var x1:Float = 150 + FlxMath.fastCos((stime / 794.701986755 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 270;
				if (stime > 11125.827814569537)
				{
					z1 = 200 / 0.7 + FlxMath.fastSin((stime / 794.701986755 * 2 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 50;
					x1 = 150 + FlxMath.fastCos((stime / 794.701986755 * 2 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 270;
				}

				var z2:Float = 200 / 0.7 + FlxMath.fastSin((etime / 794.701986755 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 50;
				var x2:Float = 150 + FlxMath.fastCos((etime / 794.701986755 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 270;
				if (etime > 11125.827814569537)
				{
					z2 = 200 / 0.7 + FlxMath.fastSin((etime / 794.701986755 * 2 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 50;
					x2 = 150 + FlxMath.fastCos((etime / 794.701986755 * 2 - 1 + Std.int(par[2]) * 0.5) * Math.PI) * 270;
				}

				var p0:Array<Float> = NoteObject.toScreen(x1, y - par[3] / 2, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1, y + par[3] / 2, z1);
				if (stime > 9536.423841059603)
				{
					p0 = NoteObject.toScreen(x1 - par[3] / 2, y, z1);
					p1 = NoteObject.toScreen(x1 + par[3] / 2, y, z1);
				}
				var p2:Array<Float> = NoteObject.toScreen(x2, y2 - par[3] / 2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x2, y2 + par[3] / 2, z2);
				if (etime > 9536.423841059603)
				{
					p2 = NoteObject.toScreen(x2 - par[3] / 2, y2, z2);
					p3 = NoteObject.toScreen(x2 + par[3] / 2, y2, z2);
				}

				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 1: // spin2 [stime, etime, noteData, width]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var wx:Float = 100 + 320 * par[2] + FlxMath.fastSin((stime / 794.701986755 + par[2]) * Math.PI) * 150;
				var z:Float = 200 / 0.7 + FlxMath.fastCos((stime / 794.701986755 + par[2]) * Math.PI) * 50;
				var wy:Float = (50 - (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				if (FlxG.save.data.downscroll)
					wy = (670 + (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				var wx2:Float = 100 + 320 * par[2] + FlxMath.fastSin((etime / 794.701986755 + par[2]) * Math.PI) * 150;
				var z2:Float = 200 / 0.7 + FlxMath.fastCos((etime / 794.701986755 + par[2]) * Math.PI) * 50;
				var wy2:Float = (50 - (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				if (FlxG.save.data.downscroll)
					wy2 = (670 + (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				var w0 = NoteObject.toScreen(wx - par[3] / 2, wy, z);
				var w1 = NoteObject.toScreen(wx + par[3] / 2, wy, z);
				var w2 = NoteObject.toScreen(wx2 - par[3] / 2, wy2, z2);
				var w3 = NoteObject.toScreen(wx2 + par[3] / 2, wy2, z2);
				return [[w0[0], w0[1], w1[0], w1[1], w2[0], w2[1], w3[0], w3[1]], uvt];
			case 2: // whatever [stime, etime, width,noteData]
				var st:Float = (Conductor.songPosition - 65165.56291390731) / 397.350993377;
				var times:Array<Float> = [
					0, 65165.56291390731, 65960.26490066228, 66754.96688741725, 67549.66887417222, 68344.37086092719, 69139.07284768215, 71523.17880794706,
					72317.88079470203, 73112.582781457, 73907.28476821196, 74701.98675496693, 75496.6887417219, 77880.7947019868, 78675.49668874177,
					79470.19867549674, 80264.9006622517, 84238.41059602654, 85033.11258278151, 85827.81456953648, 86622.51655629145
				];
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var mst1:Float = (stime - 65165.56291390731) / 397.350993377;
				var x1:Float = 640 + 300 * FlxMath.fastCos(stime / 794.701986755 * Math.PI);
				var y1:Float = 360 + 200 * FlxMath.fastSin(stime / 794.701986755 * Math.PI);
				var group1:Float = Math.floor(Math.floor(mst1 / 2) - st / 2);
				group1 += (mst1 / 2) % 1;

				var mst2:Float = (etime - 65165.56291390731) / 397.350993377;
				var x2:Float = 640 + 300 * FlxMath.fastCos(etime / 794.701986755 * Math.PI);
				var y2:Float = 360 + 200 * FlxMath.fastSin(etime / 794.701986755 * Math.PI);
				var group2:Float = Math.floor(Math.floor(mst2 / 2) - st / 2);
				group2 += (mst2 / 2) % 1;
				if (mst1 >= 32)
				{
					x1 = 190 + 300 * par[3];
					y1 = 360 + 400 * FlxMath.fastSin(stime / 794.701986755 * Math.PI);
					x2 = 190 + 300 * par[3];
					y2 = 360 + 400 * FlxMath.fastSin(etime / 794.701986755 * Math.PI);
				}

				var z1:Float = 0;
				var z2:Float = 0;

				if ((st > 12 && st < 16) || (st > 28 && st < 32) || (st > 40 && st < 48) || (st > 56 && st < 64) || st < 0)
				{
					z1 = 200 + 1050 * (mst1 - st) / 2;
					z2 = 200 + 1050 * (mst2 - st) / 2;
				}
				else if (st % 2 > 1.5)
				{
					z1 = 200 + 1050 * group1 + 50 + 2000 * (2 - st % 2);
					z2 = 200 + 1050 * group2 + 50 + 2000 * (2 - st % 2);
				}
				else
				{
					group1 += 1;
					z1 = 200 + 1050 * group1 + 50 * (1.5 - st % 2) / 1.5;
					group2 += 1;
					z2 = 200 + 1050 * group2 + 50 * (1.5 - st % 2) / 1.5;
				}

				var p0:Array<Float> = NoteObject.toScreen(x1, y1 - par[2] / 2, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1, y1 + par[2] / 2, z1);
				var p2:Array<Float> = NoteObject.toScreen(x2, y2 - par[2] / 2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x2, y2 + par[2] / 2, z2);

				if (z1 < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 3: // stupid [stime, etime, width, noteData, order]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var z1:Float = 300;
				var z2:Float = 300;
				if (stime > 103311.25827814577)
				{
					if (Conductor.songPosition > stime - par[4] * Conductor.stepCrochet)
					{
						var abb = (Conductor.songPosition - stime + par[4] * Conductor.stepCrochet) / Conductor.stepCrochet;
						if (abb > par[4] + head)
							z1 = 300 + 300 * Math.abs(FlxMath.fastSin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						else
							z1 = 300
								+ 300 * Math.abs(FlxMath.fastSin(((Conductor.songPosition - (par[4] +
									head - abb) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						if (abb > par[4] + tail)
							z2 = 300 + 300 * Math.abs(FlxMath.fastSin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						else
							z2 = 300
								+ 300 * Math.abs(FlxMath.fastSin(((Conductor.songPosition - (par[4] +
									tail - abb) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
					}
					else
					{
						z1 = 300
							+ 300 * Math.abs(FlxMath.fastSin(((Conductor.songPosition - (par[4] + head) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						z2 = 300
							+ 300 * Math.abs(FlxMath.fastSin(((Conductor.songPosition - (par[4] + tail) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
					}
				}

				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				if (Conductor.songPosition < 90596.02649006629)
					ang = 0;
				var x01 = 160 * (1.5 - par[3]) - par[2] / 2;
				var x02 = 160 * (1.5 - par[3]) + par[2] / 2;
				var y01 = (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2)) * (FlxG.save.data.downscroll ? 1 : -1) * (par[5] == 1 ? 1 : -1);
				var y02 = (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2)) * (FlxG.save.data.downscroll ? 1 : -1) * (par[5] == 1 ? 1 : -1);
				var x0 = 640 - FlxMath.fastCos(ang) * x01 - FlxMath.fastSin(ang) * y01;
				var y0 = 360 - FlxMath.fastSin(ang) * x01 + FlxMath.fastCos(ang) * y01;
				var x1 = 640 - FlxMath.fastCos(ang) * x02 - FlxMath.fastSin(ang) * y01;
				var y1 = 360 - FlxMath.fastSin(ang) * x02 + FlxMath.fastCos(ang) * y01;
				var x2 = 640 - FlxMath.fastCos(ang) * x01 - FlxMath.fastSin(ang) * y02;
				var y2 = 360 - FlxMath.fastSin(ang) * x01 + FlxMath.fastCos(ang) * y02;
				var x3 = 640 - FlxMath.fastCos(ang) * x02 - FlxMath.fastSin(ang) * y02;
				var y3 = 360 - FlxMath.fastSin(ang) * x02 + FlxMath.fastCos(ang) * y02;

				var p0:Array<Float> = NoteObject.toScreen(x0, y0, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1, y1, z1);
				var p2:Array<Float> = NoteObject.toScreen(x2, y2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x3, y3, z2);

				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 4: // renderer is too great to not use  [stime, etime, width, noteData, mustpress]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var x = NoteObject.toWorld((par[4] == 1) ? 1040 : 240, 360)[0];
				var y1 = NoteObject.toWorld(640,
					(FlxG.save.data.downscroll ? (550 + Note.noteHeight[Std.int(par[3])] / 2) : (50 + Note.noteHeight[Std.int(par[3])] / 2)) +
					(Conductor.songPosition
						- stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * (FlxG.save.data.downscroll ? 1 : -1))[1];
				var y2 = NoteObject.toWorld(640,
					(FlxG.save.data.downscroll ? (550 + Note.noteHeight[Std.int(par[3])] / 2) : (50 + Note.noteHeight[Std.int(par[3])] / 2)) +
					(Conductor.songPosition
						- etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) * (FlxG.save.data.downscroll ? 1 : -1))[1];
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				if (Conductor.songPosition < 116026.49006622526)
					ang = 0;
				var z = 200 / 0.7 - FlxMath.fastSin(ang) * (par[4] == 1 ? 100 : -100);
				x = 640 + FlxMath.fastCos(ang) * (x - 640) + 160 * (par[3] - 1.5);

				var p0:Array<Float> = NoteObject.toScreen(x - par[2] / 2, y1, z);
				var p1:Array<Float> = NoteObject.toScreen(x + par[2] / 2, y1, z);
				var p2:Array<Float> = NoteObject.toScreen(x - par[2] / 2, y2, z);
				var p3:Array<Float> = NoteObject.toScreen(x + par[2] / 2, y2, z);
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
		}
		return null;
	}
}
