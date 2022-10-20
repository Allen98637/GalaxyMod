package modcharts;

import Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import haxe.Exception;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class RenderPath
{
	public var mode:Int;
	public var par:Array<Float>;
	public var isSplash:Bool = false;

	public var bili:Float = 1;

	public function new(mode:Int, pars:Array<Float>, isSplash:Bool = false)
	{
		this.mode = mode;
		par = pars;
		this.isSplash = isSplash;
	}

	public function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // circle [num, all, x, y, r]
				var sorder:Float = (par[0] + head) / par[1];
				var eorder:Float = (par[0] + tail) / par[1];

				var ang1 = sorder * (2 * Math.PI);
				var ang2 = eorder * (2 * Math.PI);

				var x1 = par[2] - FlxMath.fastSin(ang1) * par[4];
				var y1 = par[3] + FlxMath.fastCos(ang1) * par[4];
				var x2 = par[2] - FlxMath.fastSin(ang2) * par[4];
				var y2 = par[3] + FlxMath.fastCos(ang2) * par[4];

				return [[par[2], par[3], x1, y1, par[2], par[3], x2, y2], uvt];
			case 1: // angle [sdist, edist, x, y, width, ang, maxdis]
				var sdist:Float = FlxMath.lerp(par[0], par[1], head);
				var edist:Float = FlxMath.lerp(par[0], par[1], tail);

				var tael:Float = tail;
				if (par[6] > 0 && sdist > par[6])
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				if (par[6] > 0 && edist > par[6])
				{
					tael = head + (par[6] - sdist) / (edist - sdist) * (tail - head);
					edist = par[6];
				}

				var ang:Float = par[5] / 180 * Math.PI;

				var x1:Float = par[2] - FlxMath.fastCos(ang) * par[4] / 2 - FlxMath.fastSin(ang) * sdist;
				var y1:Float = par[3] - FlxMath.fastSin(ang) * par[4] / 2 + FlxMath.fastCos(ang) * sdist;
				var x2:Float = par[2] + FlxMath.fastCos(ang) * par[4] / 2 - FlxMath.fastSin(ang) * sdist;
				var y2:Float = par[3] + FlxMath.fastSin(ang) * par[4] / 2 + FlxMath.fastCos(ang) * sdist;
				var x3:Float = par[2] - FlxMath.fastCos(ang) * par[4] / 2 - FlxMath.fastSin(ang) * edist;
				var y3:Float = par[3] - FlxMath.fastSin(ang) * par[4] / 2 + FlxMath.fastCos(ang) * edist;
				var x4:Float = par[2] + FlxMath.fastCos(ang) * par[4] / 2 - FlxMath.fastSin(ang) * edist;
				var y4:Float = par[3] + FlxMath.fastSin(ang) * par[4] / 2 + FlxMath.fastCos(ang) * edist;

				uvt = [0, head, 1, head, 0, tael, 1, tael];
				return [[x1, y1, x2, y2, x3, y3, x4, y4], uvt];
		}
		return null;
	}
}
