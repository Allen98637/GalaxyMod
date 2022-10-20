package;

import flash.geom.ColorTransform;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.tile.FlxDrawTrianglesItem;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import modcharts.RenderPath;
import openfl.Vector;

using StringTools;

class NoteStrum extends NoteObject
{
	public var verticles:DrawData<Float>;
	public var uvtData:DrawData<Float>;
	public var player:Int;

	public var mustBeKilled:Bool = false;

	var inited:Bool = false;

	var renruned:Bool = false;

	public var rendermode:Int = 0;

	public var type = "null";

	private static var alphas:Map<String, Map<Int, Map<String, Map<Int, Array<Float>>>>> = new Map();
	private static var indexes:Map<String, Map<Int, Map<String, Map<Int, Array<Int>>>>> = new Map();
	private static var glist:Array<FlxGraphic> = [];

	public var renderer:RenderPath;

	public static function refresh()
	{
		for (i in glist)
			i.destroy();
		alphas = new Map();
		indexes = new Map();
		glist = [];
	}

	public function new(x:Float, y:Float, player:Int, num:Int, ?type:String = "null", ?spec:Int = 0)
	{
		super(x, y);
		this.player = player;
		this.type = type;
		this.spec = spec;
		if (type == "kali")
		{
			frames = Paths.getSparrowAtlas('cor/cyber');
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');
			antialiasing = true;
			setGraphicSize(Std.int(width * 0.7));
			switch (Math.abs(num))
			{
				case 0:
					this.x += Note.swagWidth * 0;
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					this.x += Note.swagWidth * 1;
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					this.x += Note.swagWidth * 2;
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					this.x += Note.swagWidth * 3;
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
			}
		}
		else
		{
			switch (PlayState.curStage)
			{
				case 'school' | 'schoolEvil':
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					animation.add('green', [6]);
					animation.add('red', [7]);
					animation.add('blue', [5]);
					animation.add('purplel', [4]);

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
					antialiasing = false;

					switch (Math.abs(num))
					{
						case 0:
							this.x += Note.swagWidth * 0;
							animation.add('static', [0]);
							animation.add('pressed', [4, 8], 12, false);
							animation.add('confirm', [12, 16], 24, false);
						case 1:
							this.x += Note.swagWidth * 1;
							animation.add('static', [1]);
							animation.add('pressed', [5, 9], 12, false);
							animation.add('confirm', [13, 17], 24, false);
						case 2:
							this.x += Note.swagWidth * 2;
							animation.add('static', [2]);
							animation.add('pressed', [6, 10], 12, false);
							animation.add('confirm', [14, 18], 12, false);
						case 3:
							this.x += Note.swagWidth * 3;
							animation.add('static', [3]);
							animation.add('pressed', [7, 11], 12, false);
							animation.add('confirm', [15, 19], 24, false);
					}

				default:
					frames = Paths.getSparrowAtlas('NOTE_assets');
					animation.addByPrefix('green', 'arrowUP');
					animation.addByPrefix('blue', 'arrowDOWN');
					animation.addByPrefix('purple', 'arrowLEFT');
					animation.addByPrefix('red', 'arrowRIGHT');

					antialiasing = true;
					setGraphicSize(Std.int(width * 0.7));

					switch (Math.abs(num))
					{
						case 0:
							this.x += Note.swagWidth * 0;
							animation.addByPrefix('static', 'arrowLEFT');
							animation.addByPrefix('pressed', 'left press', 24, false);
							animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							this.x += Note.swagWidth * 1;
							animation.addByPrefix('static', 'arrowDOWN');
							animation.addByPrefix('pressed', 'down press', 24, false);
							animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							this.x += Note.swagWidth * 2;
							animation.addByPrefix('static', 'arrowUP');
							animation.addByPrefix('pressed', 'up press', 24, false);
							animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							this.x += Note.swagWidth * 3;
							animation.addByPrefix('static', 'arrowRIGHT');
							animation.addByPrefix('pressed', 'right press', 24, false);
							animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}
		}

		updateHitbox();
		scrollFactor.set();

		ID = num;
	}

	public function render(over:Array<Float>, ?ouvt:Array<Float> = null)
	{
		renruned = true;
		if (!inited)
		{
			scale.set(1, 1);
			if (animation.curAnim.name == 'static')
			{
				updateHitbox();
				inited = true;
			}
		}
		rendermode = 1;
		offset.set();
		x = 0;
		y = 0;
		/*if (animation.curAnim.name == 'confirm')
			{
				var cent:Array<Float> = [
					(over[0] + over[2] + over[4] + over[6]) / 4,
					(over[1] + over[3] + over[5] + over[7]) / 4
				];
				for (i in 0...8)
				{
					if (i % 2 == 0)
						over[i] = cent[0] + (over[i] - cent[0]) * (238 / 157);
					else
						over[i] = cent[1] + (over[i] - cent[1]) * (235 / 154);
				}
		}*/
		var auvt:Array<Float> = [0, 0, 1, 0, 0, 1, 1, 1];
		if (ouvt != null)
			auvt = ouvt.copy();
		verticles = new Vector(8, true, over);
		uvtData = new Vector(auvt.length, true, auvt);
	}

	public function pathrender()
	{
		if (!inited)
		{
			scale.set(1, 1);
			if (animation.curAnim.name == 'static')
			{
				updateHitbox();
				inited = true;
			}
		}
		offset.set();
		rendermode = 2;
		x = 0;
		y = 0;
	}

	override function draw()
	{
		switch (rendermode)
		{
			case 2:
				if (renderer == null || alpha <= 0 || !visible || !active)
					return;
				var inc:Vector<Int> = new Vector(6, true, [0, 1, 2, 1, 3, 2]);
				var gdata:FlxGraphic = mapData();
				var rem:Float = 1 - renderer.bili;
				while (rem + 0.1 < 1)
				{
					for (camera in cameras)
					{
						if (!camera.visible || !camera.exists)
						{
							continue;
						}
						var start:Float = rem;
						var end:Float = rem + 0.1;
						var lists:Array<Array<Float>> = renderer.start(start, end);
						var v:Vector<Float> = new Vector(8, true, lists[0]);
						var u:Vector<Float> = new Vector(lists[1].length, true, lists[1]);
						if (end > 1)
							end = 1;
						getScreenPosition(_point, camera).subtractPoint(offset);
						camera.drawTriangles(gdata, v, inc, u, null, _point, blend, false, antialiasing);
						rem = end;
					}
				}
			case 1:
				if (verticles == null || uvtData == null || alpha <= 0)
					return;
				var inc:Vector<Int> = new Vector(6, true, [0, 1, 2, 1, 3, 2]);
				var gdata:FlxGraphic = mapData();
				for (camera in cameras)
				{
					if (!camera.visible || !camera.exists)
					{
						continue;
					}
					getScreenPosition(_point, camera).subtractPoint(offset);
					camera.drawTriangles(gdata, verticles, inc, uvtData, null, _point, blend, false, antialiasing);
				}
			default:
				inited = false;
				super.draw();
		}
	}

	function mapData():FlxGraphic
	{
		if (gpix == null || alpha != oalp || !animation.curAnim.finished || oanim != animation.curAnim.name)
		{
			if (!alphas.exists(type))
			{
				alphas.set(type, new Map());
				indexes.set(type, new Map());
			}
			if (!alphas.get(type).exists(ID))
			{
				alphas.get(type).set(ID, new Map());
				indexes.get(type).set(ID, new Map());
			}
			if (!alphas.get(type).get(ID).exists(animation.curAnim.name))
			{
				alphas.get(type).get(ID).set(animation.curAnim.name, new Map());
				indexes.get(type).get(ID).set(animation.curAnim.name, new Map());
			}
			if (!alphas.get(type)
				.get(ID)
				.get(animation.curAnim.name)
				.exists(animation.curAnim.curFrame))
			{
				alphas.get(type)
					.get(ID)
					.get(animation.curAnim.name)
					.set(animation.curAnim.curFrame, []);
				indexes.get(type)
					.get(ID)
					.get(animation.curAnim.name)
					.set(animation.curAnim.curFrame, []);
			}
			if (!alphas.get(type)
				.get(ID)
				.get(animation.curAnim.name)
				.get(animation.curAnim.curFrame)
				.contains(alpha))
			{
				var pix:FlxGraphic = FlxGraphic.fromFrame(frame, true);
				var nalp:Array<Float> = alphas.get(type).get(ID).get(animation.curAnim.name).get(animation.curAnim.curFrame);
				var nindex:Array<Int> = indexes.get(type).get(ID).get(animation.curAnim.name).get(animation.curAnim.curFrame);
				pix.bitmap.colorTransform(pix.bitmap.rect, colorTransform);
				glist.push(pix);
				nalp.push(alpha);
				nindex.push(glist.length - 1);
				alphas.get(type)
					.get(ID)
					.get(animation.curAnim.name)
					.set(animation.curAnim.curFrame, nalp);
				indexes.get(type)
					.get(ID)
					.get(animation.curAnim.name)
					.set(animation.curAnim.curFrame, nindex);
			}
			var dex = alphas.get(type)
				.get(ID)
				.get(animation.curAnim.name)
				.get(animation.curAnim.curFrame)
				.indexOf(alpha);
			gpix = glist[
				indexes.get(type)
					.get(ID)
					.get(animation.curAnim.name)
					.get(animation.curAnim.curFrame)[dex]];
			oalp = alpha;
			oanim = animation.curAnim.name;
		}
		return gpix;
	}
}
