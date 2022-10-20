package;

import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import modcharts.RenderPath;
import openfl.Vector;

using StringTools;

#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

class NoteObject extends FlxSprite
{
	public var z:Float = 200 / 0.7;
	public var wx:Float;
	public var wy:Float;
	public var strumTime:Float = FlxMath.MAX_VALUE_FLOAT;
	public var isEnd:Bool = false;
	public var spec:Int = 0;

	public var gpix:FlxGraphic = null;
	public var oalp:Float = 1;
	public var oanim:String = "";

	public var pars:Array<Dynamic> = [];

	public static function toScreen(x:Float, y:Float, z:Float):Array<Float>
	{
		/* x = ori + swagWidth / 2, y = 360, scale = 2
			eye(640,360,0), flat: z = 200
			game:z = 200 / 0.7
			x: (-640  / 0.7 + 640) ~ (640  / 0.7 + 640)
			y: (-360  / 0.7 + 360) ~ (360  / 0.7 + 360)
		 */
		var nx:Float = 640 + ((x - 640) / (z)) * 200;
		var ny:Float = 360 + ((y - 360) / (z)) * 200;
		return [nx, ny];
	}

	public static function toWorld(x:Float, y:Float, z:Float = 200 / 7):Array<Float>
	{
		var nx:Float = ((x - 640) / 0.7 + 640);
		var ny:Float = ((y - 360) / 0.7 + 360);
		return [nx, ny, z];
	}

	public static function triangles(x:Float, y:Float, z:Float, width:Float, height:Float, ax:Float, ay:Float, az:Float, midx:Float = 640, midy:Float = 360,
			midz:Float = 200 / 0.7, screen:Bool = true):Array<Array<Float>>
	{
		if (worldSpin(x, y + height, z, ax, ay, az, midx, midy, midz)[1][0] <= 0)
		{
			return [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 1, 1, 1]];
		}
		var p0:Array<Float> = worldSpin(x, y, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t0:Float = 200 / worldSpin(x, y, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		var p1:Array<Float> = worldSpin(x + width, y, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t1:Float = 200 / worldSpin(x + width, y, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		var p2:Array<Float> = worldSpin(x, y + height, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t2:Float = 200 / worldSpin(x, y + height, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		var p3:Array<Float> = worldSpin(x + width, y + height, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t3:Float = 200 / worldSpin(x + width, y + height, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		return [
			[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]],
			[0, 0, t0, 1, 0, t1, 0, 1, t2, 1, 1, t3]
		];
		// [0, 0, t0, 1, 0, t1, 0, 1, t2, 1, 1, t3]
	}

	public static function worldSpin(x:Float, y:Float, z:Float, ax:Float, ay:Float, az:Float, midx:Float = 640, midy:Float = 360, midz:Float = 200 / 0.7,
			screen:Bool = true)
	{
		var xx:Float = x;
		var yy:Float = y;
		if (screen)
		{
			xx = NoteObject.toWorld(x, y, z)[0];
			yy = NoteObject.toWorld(x, y, z)[1];
		}

		var angx:Array<Float> = [FlxMath.fastCos(ax / 180 * Math.PI), FlxMath.fastSin(ax / 180 * Math.PI)];
		var angy:Array<Float> = [FlxMath.fastCos(ay / 180 * Math.PI), FlxMath.fastSin(ay / 180 * Math.PI)];
		var angz:Array<Float> = [FlxMath.fastCos(az / 180 * Math.PI), FlxMath.fastSin(az / 180 * Math.PI)];

		var gapx:Float = xx - midx;
		var gapy:Float = midy - yy;
		var gapz:Float = midz - z;

		var nx:Float = midx
			+ angy[0] * angz[0] * gapx + (-angz[1] * angx[0] + angx[1] * angy[1] * angz[0]) * gapy + (angx[1] * angz[1] + angx[0] * angy[1] * angz[0]) * gapz;
		var ny:Float = midy
			- angy[0] * angz[1] * gapx - (angx[0] * angz[0] + angx[1] * angy[1] * angz[1]) * gapy - (-angx[1] * angz[0] + angx[0] * angy[1] * angz[1]) * gapz;
		var nz:Float = midz + angy[1] * gapx - angx[1] * angy[0] * gapy - angx[0] * angy[0] * gapz;

		return [NoteObject.toScreen(nx, ny, nz), [nz, nx, ny]];
	}

	public static function multiWorldSpin(x:Float, y:Float, z:Float, ax:Array<Float>, ay:Array<Float>, az:Array<Float>, midx:Array<Float>, midy:Array<Float>,
			midz:Array<Float>, screen:Bool = true)
	{
		var daSpin:Array<Float> = worldSpin(x, y, z, ax[0], ay[0], az[0], midx[0], midy[0], midz[0], screen)[1];
		for (i in 1...ax.length)
		{
			daSpin = worldSpin(daSpin[1], daSpin[2], daSpin[0], ax[i], ay[i], az[i], midx[i], midy[i], midz[i], false)[1];
		}
		return [NoteObject.toScreen(daSpin[1], daSpin[2], daSpin[0]), [daSpin[0]]];
	}

	public static function multiTriangles(x:Float, y:Float, z:Float, width:Float, height:Float, ax:Array<Float>, ay:Array<Float>, az:Array<Float>,
			midx:Array<Float>, midy:Array<Float>, midz:Array<Float>, screen:Bool = true):Array<Array<Float>>
	{
		if (multiWorldSpin(x, y + height, z, ax, ay, az, midx, midy, midz)[1][0] <= 0)
		{
			return [[0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 1, 1, 1]];
		}
		var p0:Array<Float> = multiWorldSpin(x, y, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t0:Float = 200 / multiWorldSpin(x, y, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		var p1:Array<Float> = multiWorldSpin(x + width, y, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t1:Float = 200 / multiWorldSpin(x + width, y, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		var p2:Array<Float> = multiWorldSpin(x, y + height, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t2:Float = 200 / multiWorldSpin(x, y + height, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		var p3:Array<Float> = multiWorldSpin(x + width, y + height, z, ax, ay, az, midx, midy, midz, screen)[0];
		var t3:Float = 200 / multiWorldSpin(x + width, y + height, z, ax, ay, az, midx, midy, midz, screen)[1][0];
		return [
			[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]],
			[0, 0, t0, 1, 0, t1, 0, 1, t2, 1, 1, t3]
		];
		// [0, 0, t0, 1, 0, t1, 0, 1, t2, 1, 1, t3]
	}

	public function scaleW()
	{
		scale.set(1, 1);
		updateHitbox();
		var lt:Array<Float> = toScreen(wx - width / 2, wy - height / 2, z);
		var rb:Array<Float> = toScreen(wx + width / 2, wy + height / 2, z);
		setGraphicSize(Std.int(rb[0] - lt[0]), Std.int(rb[1] - lt[1]));
		if (Std.int(rb[0] - lt[0]) < 1 || Std.int(rb[1] - lt[1]) < 1 || z < 0)
		{
			scale.set(0, 0);
		}
		updateHitbox();
		x = lt[0];
		y = lt[1];
	}
}
