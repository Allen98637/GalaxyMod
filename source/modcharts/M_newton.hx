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

class M_newton
{
	public static var olist:Array<Int> = [0, 1, 2, 3];
	public static var nlist:Array<Int> = [0, 1, 2, 3];
	public static var my:Float = 720;
	public static var mz:Float = 200 / 0.7;

	public static function reset()
	{
		olist = [0, 1, 2, 3];
		nlist = [0, 1, 2, 3];
		my = 720;
		mz = 200 / 0.7;
	}

	public static function pos(daNote:Note)
	{
		if (daNote.strumTime >= 7058
			&& ((daNote.mustPress && daNote.strumTime < 14117) || (!daNote.mustPress && daNote.strumTime < 12000)))
		{
			if (daNote.mustPress)
				daNote.x = 858;
			else
				daNote.x = 218;
			switch (Std.int(Conductor.songPosition / (60000 / 136)) % 4)
			{
				case 0:
					daNote.animation.play('greenScroll');
				case 1:
					daNote.animation.play('redScroll');
				case 2:
					daNote.animation.play('blueScroll');
				case 3:
					daNote.animation.play('purpleScroll');
			}
			if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.7
				&& Conductor.songPosition % (60000 / 136) / (60000 / 136) >= 0.5)
			{
				daNote.angle = FlxMath.lerp(0, 90, (Conductor.songPosition % (60000 / 136) / (60000 / 136) - 0.5) / 0.2);
			}
			else if (Conductor.songPosition % (60000 / 136) / (60000 / 136) > 0.7)
			{
				daNote.angle = 90;
			}
			else
			{
				daNote.angle = 0;
			}
			if (FlxG.save.data.downscroll)
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 14117 && daNote.strumTime < 22942)
		{
			var y:Float = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			if (FlxG.save.data.downscroll)
				y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			var x:Float = PlayMoving.oxlist[daNote.noteData];
			if (daNote.mustPress)
				x = PlayMoving.poxlist[daNote.noteData];
			if (daNote.isSustainNote)
			{
				x += (Note.noteWidth[daNote.noteData] - daNote.width) / 2;
				daNote.alpha = 0.6;
			}
			var a:Float = 0;
			if (Conductor.songPosition >= 14117.647058823528)
				a = PlayMoving.ease((Conductor.songPosition - 14117.647058823528) / 882.352941176);
			if (Conductor.songPosition >= 14999.999999999998)
				a = 1;
			if (Conductor.songPosition >= 21176.47058823529)
				a = PlayMoving.ease((21264.7058824 - Conductor.songPosition) / 88.2352941176);
			if (Conductor.songPosition >= 21264.7058824)
				a = 0;
			var h:Float = daNote.height * 0.7;
			if (daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
			{
				h *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
			}
			if (daNote.isSustainNote && (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
			{
				if (FlxG.save.data.downscroll && y + h > 550 + Note.swagWidth / 2)
				{
					h = 550 + Note.swagWidth / 2 - y;
				}
				else if (!FlxG.save.data.downscroll && y < 50 + Note.swagWidth / 2)
				{
					h = y + h - 50 - Note.swagWidth / 2;
					y = 50 + Note.swagWidth / 2;
				}
			}
			/*if (daNote.isEnd)
				{
					x -= 18;
					y -= 18;
			}*/
			var non:Array<Array<Float>> = triangles(x, y, daNote.width * 0.7, h, a);
			if (FlxG.save.data.downscroll && daNote.isSustainNote)
			{
				non = triangles(x, y + h, daNote.width * 0.7, -h, a);
			}
			daNote.render(non[0], non[1]);
		}
		else if (daNote.strumTime >= 28235 && daNote.strumTime < 35294)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			if (!daNote.mustPress)
			{
				daNote.x = PlayMoving.xlist[daNote.noteData];
				if (daNote.isSustainNote)
				{
					daNote.x += (Note.noteWidth[daNote.noteData] - daNote.width) / 2;
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
					var y:Float = daNote.y;
					if (FlxG.save.data.downscroll)
					{
						y += h * 1.5;
						h *= -1;
						if (daNote.animation.curAnim.name.endsWith('end'))
						{
							y += h / 4;
						}
					}
					daNote.renderer = new R_newton(0, [
						daNote.strumTime - Conductor.stepCrochet,
						daNote.strumTime - Conductor.stepCrochet + len,
						daNote.x,
						y,
						daNote.width,
						h
					]);
					if (Conductor.songPosition > daNote.strumTime - len * 0.75)
					{
						daNote.renderer.bili = 1
							- (Conductor.songPosition
								- (daNote.strumTime - Conductor.stepCrochet + len - Conductor.stepCrochet * 0.75)) / (Conductor.stepCrochet * 0.75);
					}
					daNote.pathrender();
				}
			}
		}
		else if (daNote.strumTime >= 35294 && daNote.strumTime < 49302 || (daNote.strumTime < 49412 && daNote.mustPress))
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			daNote.x = daNote.mustPress ? PlayMoving.pxlist[daNote.noteData] : PlayMoving.xlist[daNote.noteData];
			if (daNote.isSustainNote)
				daNote.x += (Note.noteWidth[daNote.noteData] - daNote.width) / 2;
		}
		else if (daNote.strumTime >= 49411 && daNote.strumTime < 63528 || (daNote.strumTime < 63530 && daNote.mustPress))
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			daNote.alpha = FlxMath.fastCos((Conductor.songPosition / 441.176470588 * 2) * Math.PI) + 1;
			if (daNote.isSustainNote)
				daNote.alpha *= 0.6;
		}
		else if (daNote.strumTime >= 63529)
		{
			var y:Float = (PlayMoving.ylist[daNote.noteData]
				- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			if (FlxG.save.data.downscroll)
				y = (PlayMoving.ylist[daNote.noteData] + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			var x:Float = PlayMoving.xlist[daNote.noteData];
			if (daNote.mustPress)
				x = PlayMoving.pxlist[daNote.noteData];
			var a:Float = 1;
			if (Conductor.songPosition > 91764.70588235292)
				a = 1 + FlxMath.fastSin(Conductor.songPosition / 1764.70588235 * Math.PI) * 0.5;
			else if (Conductor.songPosition < 63529.411764705925)
				a = 0;
			else if (Conductor.songPosition < 63639.70588235298)
				a = PlayMoving.ease((Conductor.songPosition - 63529.411764705925) / 110.294117647);
			var proc:Float = (Math.abs(daNote.strumTime - Conductor.songPosition) % 441.176470588);
			var z:Float = mz + (proc) * (proc - 441.176470588) / 500;
			daNote.z = z;
			var non:Array<Array<Float>> = triangles(x, y, daNote.width * 0.7, daNote.height * 0.7, a, z, my);
			daNote.render(non[0], non[1]);
			if (daNote.isSustainNote)
			{
				x += (Note.noteWidth[daNote.noteData] - daNote.width) / 2;
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
				daNote.renderer = new R_newton(2, [
					daNote.strumTime - Conductor.stepCrochet,
					daNote.strumTime - Conductor.stepCrochet + len,
					x,
					y,
					daNote.width,
					h,
					a,
					my,
					mz
				]);
				if (!FlxG.save.data.downscroll
					&& y <= PlayMoving.ylist[daNote.noteData] + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var cw:Float = PlayMoving.ylist[daNote.noteData] + Note.swagWidth / 2 - y - daNote.offset.y;
					daNote.renderer.bili = 1 - (cw / h);
				}
				if (FlxG.save.data.downscroll
					&& y >= PlayMoving.ylist[daNote.noteData] + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var cw:Float = y - PlayMoving.ylist[daNote.noteData] - Note.swagWidth / 2;
					daNote.renderer.bili = 1 + (cw / h);
				}
				daNote.pathrender();
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
		if (Conductor.songPosition >= 0 && Conductor.songPosition < 60000 / 136 * 14)
		{
			if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.2)
			{
				while (nlist[0] == olist[0] && nlist[1] == olist[1] && nlist[2] == olist[2] && nlist[3] == olist[3])
				{
					new FlxRandom().shuffle(nlist);
				}
				dastrum.x = FlxMath.lerp(PlayMoving.oxlist[olist[dastrum.ID]], PlayMoving.oxlist[nlist[dastrum.ID]],
					(Conductor.songPosition % (60000 / 136) / (60000 / 136)) / 0.2);
			}
			else
			{
				dastrum.x = PlayMoving.oxlist[nlist[dastrum.ID]];
				olist[0] = nlist[0];
				olist[1] = nlist[1];
				olist[2] = nlist[2];
				olist[3] = nlist[3];
			}
		}
		else if (Conductor.songPosition > 60000 / 136 * 14 && Conductor.songPosition < 60000 / 136 * 16)
		{
			var slist = [810, 900, 720, 630];
			dastrum.angle = FlxMath.lerp(0, slist[dastrum.ID], (Conductor.songPosition - 60000 / 136 * 14) / (60000 / 68));
			if (Conductor.songPosition > 60000 / 136 * 15)
			{
				dastrum.x = FlxMath.lerp(PlayMoving.oxlist[nlist[dastrum.ID]], 218, (Conductor.songPosition - 60000 / 136 * 15) / (60000 / 136));
			}
		}
		else if (Conductor.songPosition > 60000 / 136 * 16 && Conductor.songPosition < 14117.647058823528)
		{
			var show:Int = -1;
			switch (Std.int(Conductor.songPosition / (60000 / 136)) % 4)
			{
				case 0:
					show = 2;
				case 1:
					show = 3;
				case 2:
					show = 1;
				case 3:
					show = 0;
			}
			if (Conductor.songPosition > 13235.294117647058 && dastrum.player == 0)
			{
				var slist:Array<Float> = [-90, 0, 180, 90];
				if (Conductor.songPosition >= 13676.470588235294)
				{
					dastrum.angle = 0;
					dastrum.x = PlayMoving.oxlist[dastrum.ID];
				}
				else
				{
					dastrum.angle = slist[dastrum.ID] * (13676.470588235294 - Conductor.songPosition) / 441.176470588;
					dastrum.x = 218 + (PlayMoving.oxlist[dastrum.ID] - 218) * (Conductor.songPosition - 13235.294117647058) / 441.176470588;
				}
				dastrum.alpha = 1;
			}
			else
			{
				dastrum.rendermode = 0;
				if (dastrum.ID == show)
				{
					dastrum.alpha = 1;
				}
				else
				{
					dastrum.alpha = 0;
				}
				if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.7
					&& Conductor.songPosition % (60000 / 136) / (60000 / 136) >= 0.5)
				{
					dastrum.angle = FlxMath.lerp(0, 90, (Conductor.songPosition % (60000 / 136) / (60000 / 136) - 0.5) / 0.2);
				}
				else if (Conductor.songPosition % (60000 / 136) / (60000 / 136) > 0.7)
				{
					dastrum.angle = 90;
				}
				else
				{
					dastrum.angle = 0;
				}
			}
		}
		else if (Conductor.songPosition >= 14117.647058823528 && Conductor.songPosition < 14999.999999999998)
		{
			// FlxG.drawFramerate = 60;
			dastrum.angle = 0;
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.oxlist[dastrum.ID];
			var non:Array<Array<Float>> = triangles(x, y, dastrum.width * 0.7, dastrum.height * 0.7,
				PlayMoving.ease((Conductor.songPosition - 14117.647058823528) / 882.352941176));
			dastrum.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 14999.999999999998 && Conductor.songPosition < 21066.17647058823)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.oxlist[dastrum.ID];
			var non:Array<Array<Float>> = triangles(x, y, dastrum.width * 0.7, dastrum.height * 0.7, 1);
			dastrum.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 21176.47058823529 && Conductor.songPosition < 21264.7058824)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.oxlist[dastrum.ID];
			var non:Array<Array<Float>> = triangles(x, y, dastrum.width * 0.7, dastrum.height * 0.7,
				PlayMoving.ease((21264.7058824 - Conductor.songPosition) / 88.2352941176));
			dastrum.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 21264.7058824 && Conductor.songPosition < 28235)
		{
			dastrum.rendermode = 0;
			dastrum.scale.x = 0.7;
			dastrum.scale.y = 0.7;
			if (dastrum.animation.curAnim.name != 'confirm')
				dastrum.updateHitbox();
			dastrum.y = FlxG.save.data.downscroll ? 550 : 50;
			dastrum.x = dastrum.player == 0 ? PlayMoving.oxlist[dastrum.ID] : PlayMoving.poxlist[dastrum.ID];
		}
		else if (Conductor.songPosition >= 28235.294117647052 && Conductor.songPosition < 35294.11764705882)
		{
			if (dastrum.player == 0)
			{
				dastrum.x = PlayMoving.xlist[dastrum.ID]
					- (FlxMath.fastCos((Conductor.songPosition - 28235.294117647052) / 441.176470588 * Math.PI) - 1) * 127;
			}
		}
		else if (Conductor.songPosition >= 35294.11764705882 && Conductor.songPosition < 49411.76470588237)
		{
			if ((Conductor.songPosition / 441.176470588) % 16 < 8)
			{
				if ((Conductor.songPosition / (441.176470588 / 2)) % 8 >= 1 && (Conductor.songPosition / (441.176470588 / 2)) % 8 < 4)
				{
					if ((Conductor.songPosition / (441.176470588 / 4)) % 2 < 1)
						dastrum.x = dastrum.player == 0 ? PlayMoving.oxlist[3 - dastrum.ID] : PlayMoving.poxlist[3 - dastrum.ID];
					else
						dastrum.x = dastrum.player == 0 ? PlayMoving.oxlist[dastrum.ID] : PlayMoving.poxlist[dastrum.ID];
					if (dastrum.player == 0)
						PlayMoving.xlist[dastrum.ID] = dastrum.x;
					else
						PlayMoving.pxlist[dastrum.ID] = dastrum.x;
				}
			}
			if (Conductor.songPosition >= 42352.941176470595 && dastrum.player == 0)
			{
				if ((Conductor.songPosition / (441.176470588 / 4)) % 2 < 1)
					dastrum.x = PlayMoving.oxlist[3 - dastrum.ID];
				else
					dastrum.x = PlayMoving.oxlist[dastrum.ID];
				PlayMoving.xlist[dastrum.ID] = dastrum.x;
			}
		}
		else if (Conductor.songPosition > 49411.76470588237 && Conductor.songPosition < 49511.76470588237)
		{
			PlayMoving.xlist = PlayMoving.oxlist.copy();
			PlayMoving.pxlist = PlayMoving.poxlist.copy();
		}
		else if (Conductor.songPosition >= 63529.411764705925)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x:Float = PlayMoving.oxlist[dastrum.ID];
			if (dastrum.player == 1)
				x = PlayMoving.poxlist[dastrum.ID];
			if (Conductor.songPosition >= 91764.70588235292 + 220.588235294 * dastrum.ID)
				y = FlxG.save.data.downscroll ? 550 : 50;
			else if (Conductor.songPosition >= 77647.05882352943 + 220.588235294 * dastrum.ID)
			{
				y -= FlxMath.fastSin((Conductor.songPosition - 220.588235294 * dastrum.ID) / 441.176470588 * Math.PI) * 20;
			}
			PlayMoving.ylist[dastrum.ID] = y;
			var w = dastrum.width * 0.7;
			var h = dastrum.height * 0.7;
			if (dastrum.animation.curAnim.name == 'confirm')
			{
				x -= (238 - 157) / 2 * 0.7;
				y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var a:Float = 1;
			if (Conductor.songPosition > 91764.70588235292)
				a = 1 + FlxMath.fastSin(Conductor.songPosition / 1764.70588235 * Math.PI) * 0.5;
			if (Conductor.songPosition < 63639.70588235298)
				a = PlayMoving.ease((Conductor.songPosition - 63529.411764705925) / 110.294117647);
			if (Conductor.songPosition > 92647.0588235294)
			{
				my = 360;
				mz = 400;
			}
			else if (Conductor.songPosition > 91764.70588235292)
			{
				my = 720 - (Conductor.songPosition - 91764.70588235292) / 882.352941176 * 360;
				mz = FlxMath.lerp(200 / 0.7, 400, (Conductor.songPosition - 91764.70588235292) / 882.352941176);
			}
			dastrum.z = mz;
			var non:Array<Array<Float>> = triangles(x, y, w, h, a, mz, my);
			dastrum.render(non[0], non[1]);
		}
	}

	public static function pspos(dastrum:NoteStrum)
	{
		if (Conductor.songPosition >= 0 && Conductor.songPosition < 60000 / 136 * 14)
		{
			if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.2)
			{
				dastrum.x = FlxMath.lerp(PlayMoving.poxlist[olist[dastrum.ID]], PlayMoving.poxlist[nlist[dastrum.ID]],
					(Conductor.songPosition % (60000 / 136) / (60000 / 136)) / 0.2);
			}
			else
			{
				dastrum.x = PlayMoving.poxlist[nlist[dastrum.ID]];
			}
		}
		else if (Conductor.songPosition > 60000 / 136 * 15 && Conductor.songPosition < 60000 / 136 * 16)
		{
			dastrum.x = FlxMath.lerp(PlayMoving.poxlist[nlist[dastrum.ID]], 858, (Conductor.songPosition - 60000 / 136 * 15) / (60000 / 136));
		}
		else if (Conductor.songPosition >= 14117.647058823528 && Conductor.songPosition < 14999.999999999998)
		{
			var slist:Array<Float> = [-90, 0, 180, 90];
			dastrum.angle = slist[dastrum.ID] * (14999.999999999998 - Conductor.songPosition) / 882.352941176;
			dastrum.alpha = 1;
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = 858 - (858 - PlayMoving.poxlist[dastrum.ID]) * ((Conductor.songPosition - 14117.647058823528) / 882.352941176);
			var w = dastrum.width * 0.7;
			var h = dastrum.height * 0.7;
			if (dastrum.animation.curAnim.name == 'confirm')
			{
				x -= (238 - 157) / 2 * 0.7;
				y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var non:Array<Array<Float>> = triangles(x, y, w, h, PlayMoving.ease((Conductor.songPosition - 14117.647058823528) / 882.352941176));
			dastrum.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 14999.999999999998 && Conductor.songPosition < 21066.17647058823)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.poxlist[dastrum.ID];
			var w = dastrum.width * 0.7;
			var h = dastrum.height * 0.7;
			if (dastrum.animation.curAnim.name == 'confirm')
			{
				x -= (238 - 157) / 2 * 0.7;
				y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var non:Array<Array<Float>> = triangles(x, y, w, h, 1);
			dastrum.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 21176.47058823529 && Conductor.songPosition < 21264.7058824)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.poxlist[dastrum.ID];
			var w = dastrum.width * 0.7;
			var h = dastrum.height * 0.7;
			if (dastrum.animation.curAnim.name == 'confirm')
			{
				// x -= (238 - 157) / 2 * 0.7;
				// y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var non:Array<Array<Float>> = triangles(x, y, w, h, PlayMoving.ease((21264.7058824 - Conductor.songPosition) / 88.2352941176));
			dastrum.render(non[0], non[1]);
		}
	}

	public static function shape(daNote:Note, camHUD:FlxCamera):Bool
	{
		return false;
	}

	public static function show(daNote:Note):Bool
	{
		if (daNote.strumTime >= 14117 && daNote.strumTime < 21397)
		{
			if (daNote.verticles == null)
				return true;
			if (FlxG.save.data.downscroll)
				return daNote.verticles[5] < daNote.verticles[1] - daNote.verticles[5] || daNote.verticles[0] >= daNote.verticles[2];
			else
				return daNote.verticles[1] > FlxG.height;
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
		if ((daNote.strumTime >= 14117 && daNote.strumTime < 21397) || (daNote.strumTime >= 63529))
		{
			if (daNote.verticles == null)
				return false;
			if (FlxG.save.data.downscroll)
				return daNote.verticles[1] > FlxG.height;
			else
				return daNote.verticles[5] < daNote.verticles[1] - daNote.verticles[5] || daNote.verticles[0] >= daNote.verticles[2];
		}
		else if (daNote.strumTime >= 49411 && daNote.strumTime < 63528)
			return daNote.tooLate;
		else
		{
			if (FlxG.save.data.downscroll)
				return daNote.y > FlxG.height;
			else
				return daNote.y < -daNote.height;
		}
	}

	public static function triangles(x:Float, y:Float, width:Float, height:Float, a:Float, z:Float = 200 / 0.7, midy:Float = 720):Array<Array<Float>>
	{
		return NoteObject.triangles(x, y, z, width, height, a * -15, 0, 0, 640, midy);
		// [0, 0, t0, 1, 0, t1, 0, 1, t2, 1, 1, t3]
	}
}

class R_newton extends RenderPath
{
	override function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // wave [startTime, endTime, x, y, w, h]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var x0:Float = par[2] - (FlxMath.fastCos((stime - 28235.294117647052) / 441.176470588 * Math.PI) - 1) * 127;
				var x1:Float = par[2] - (FlxMath.fastCos((etime - 28235.294117647052) / 441.176470588 * Math.PI) - 1) * 127;

				return [
					[
						x0,
						par[3] + head * par[5],
						x0 + par[4],
						par[3] + head * par[5],
						x1,
						par[3] + tail * par[5],
						x1 + par[4],
						par[3] + tail * par[5]
					],
					uvt
				];
			case 1: // spin [startTime, endTime, x, w]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var x0:Float = FlxMath.fastSin(stime / 882.352941176 * Math.PI) * -(200 - par[3] / 2) + par[2];
				var x1:Float = FlxMath.fastSin(stime / 882.352941176 * Math.PI) * -(200 + par[3] / 2) + par[2];
				var x2:Float = FlxMath.fastSin(etime / 882.352941176 * Math.PI) * -(200 - par[3] / 2) + par[2];
				var x3:Float = FlxMath.fastSin(etime / 882.352941176 * Math.PI) * -(200 + par[3] / 2) + par[2];
				var y0:Float = FlxMath.fastCos(stime / 882.352941176 * Math.PI) * (200 - par[3] / 2) + 360;
				var y1:Float = FlxMath.fastCos(stime / 882.352941176 * Math.PI) * (200 + par[3] / 2) + 360;
				var y2:Float = FlxMath.fastCos(etime / 882.352941176 * Math.PI) * (200 - par[3] / 2) + 360;
				var y3:Float = FlxMath.fastCos(etime / 882.352941176 * Math.PI) * (200 + par[3] / 2) + 360;
				return [[x0, y0, x1, y1, x2, y2, x3, y3], uvt];
			case 2: // bounce [startTime, endTime, x, y, w, h, a]
				var stime:Float = FlxMath.lerp(par[0], par[1], head);
				var etime:Float = FlxMath.lerp(par[0], par[1], tail);

				var proc:Float = (Math.abs(stime - Conductor.songPosition) % 441.176470588);
				var z0:Float = par[8] + (proc) * (proc - 441.176470588) / 500;

				proc = Math.abs(etime - Conductor.songPosition) % 441.176470588;
				var z1:Float = par[8] + (proc) * (proc - 441.176470588) / 500;

				var arr:Array<Array<Float>> = modcharts.M_newton.triangles(par[2], par[3] + par[5] * head, par[4], par[5], par[6], z0, par[7]);
				var arr2:Array<Array<Float>> = modcharts.M_newton.triangles(par[2], par[3], par[4], par[5] * tail, par[6], z1, par[7]);

				if ((arr[0][0] == 0 && arr[0][1] == 0 && arr[0][2] == 0 && arr[0][3] == 0 && arr[0][4] == 0 && arr[0][5] == 0 && arr[0][6] == 0
					&& arr[0][7] == 0)
					|| (arr2[0][0] == 0 && arr2[0][1] == 0 && arr2[0][2] == 0 && arr2[0][3] == 0 && arr2[0][4] == 0 && arr2[0][5] == 0 && arr2[0][6] == 0
						&& arr2[0][7] == 0))
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [
					[
						 arr[0][0],  arr[0][1],
						 arr[0][2],  arr[0][3],
						arr2[0][4], arr2[0][5],
						arr2[0][6], arr2[0][7]
					],
					[
						0, head,  arr[1][2],
						1, head,  arr[1][5],
						0, tail, arr2[1][8],
						1, tail, arr2[1][11]
					]
				];
		}
		return null;
	}
}
