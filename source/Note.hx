package;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import modcharts.RenderPath;
import openfl.Vector;

using StringTools;

#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

class Note extends NoteObject
{
	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var synced:Bool = false;
	public var played:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var isLastSustain:Bool = false;
	public var sustainOrder:Float;

	public var noteScore:Float = 1;

	public var rendermode:Int = 0;

	public var verticles:DrawData<Float>;
	public var uvtData:DrawData<Float>;
	public var renderer:RenderPath;

	var inited:Bool = false;
	var renruned:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public static var noteWidth:Array<Float> = [0, 0, 0, 0];
	public static var noteHeight:Array<Float> = [0, 0, 0, 0];

	public var type:String = "null";
	public var offsetWhenDraw = true;

	private static var alphas:Map<String, Map<String, Map<Int, Array<Float>>>> = new Map();
	private static var indexes:Map<String, Map<String, Map<Int, Array<Int>>>> = new Map();
	private static var glist:Array<FlxGraphic> = [];

	public var clones:Array<Note> = [];
	public var isClone:Bool = false;

	public static function refresh()
	{
		for (i in glist)
			i.destroy();
		alphas = new Map();
		indexes = new Map();
		glist = [];
	}

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sync:Bool = false, ?sustainNote:Bool = false, ?endNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		isEnd = endNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		this.synced = sync;

		var daStage:String = PlayState.curStage;

		useFramePixels = true;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				frames = Paths.getSparrowAtlas('NOTE_assets');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('greensync', 'sgreen0');
				animation.addByPrefix('redsync', 'sred0');
				animation.addByPrefix('bluesync', 'sblue0');
				animation.addByPrefix('purplesync', 'spurple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				animation.addByPrefix('purplerelease', 'purple release');
				animation.addByPrefix('greenrelease', 'green release');
				animation.addByPrefix('redrelease', 'red release');
				animation.addByPrefix('bluerelease', 'blue release');

				animation.addByPrefix('purplesyncrelease', 'spurple release');
				animation.addByPrefix('greensyncrelease', 'sgreen release');
				animation.addByPrefix('redsyncrelease', 'sred release');
				animation.addByPrefix('bluesyncrelease', 'sblue release');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				noteWidth[noteData] = width;
				noteHeight[noteData] = height;
				antialiasing = true;
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		if (sync)
		{
			switch (noteData)
			{
				case 2:
					animation.play('greensync');
				case 3:
					animation.play('redsync');
				case 1:
					animation.play('bluesync');
				case 0:
					animation.play('purplesync');
			}
		}

		if (isSustainNote && prevNote != null)
		{
			isLastSustain = true;
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.isLastSustain = false;
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
			else
				isLastSustain = false;
		}

		if (isEnd)
		{
			if (sync)
			{
				switch (noteData)
				{
					case 2:
						animation.play('greensyncrelease');
					case 3:
						animation.play('redsyncrelease');
					case 1:
						animation.play('bluesyncrelease');
					case 0:
						animation.play('purplesyncrelease');
				}
			}
			else
			{
				switch (noteData)
				{
					case 2:
						animation.play('greenrelease');
					case 3:
						animation.play('redrelease');
					case 1:
						animation.play('bluerelease');
					case 0:
						animation.play('purplerelease');
				}
			}

			if (prevNote.isSustainNote)
			{
				prevNote.isLastSustain = true;
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	public function pathrender()
	{
		offset.set();
		rendermode = 2;
		x = 0;
		y = 0;
	}

	public function render(over:Array<Float>, ouvt:Array<Float> = null)
	{
		offset.set();
		renruned = true;
		rendermode = 1;
		x = 0;
		y = 0;
		var auvt:Array<Float> = [0, 0, 1, 0, 0, 1, 1, 1];
		if (ouvt != null)
			auvt = ouvt.copy();
		verticles = new Vector(8, true, over);
		uvtData = new Vector(auvt.length, false, auvt);
	}

	override function draw()
	{
		switch (rendermode)
		{
			case 2:
				if (renderer == null || alpha <= 0 || !visible || !active)
					return;
				scale.set(1, 1);
				updateHitbox();
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
				if (verticles == null || uvtData == null || alpha <= 0 || !visible || !active)
					return;
				scale.set(1, 1);
				updateHitbox();
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
				if (isEnd && offsetWhenDraw)
				{
					if (FlxG.save.data.downscroll)
						offset.set(18 * scale.x, 36 * scale.y);
					else
						offset.set(18 * scale.x, 18 * scale.y);
				}
				super.draw();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!isClone)
		{
			if (mustPress)
			{
				// The * 0.5 is so that it's easier to hit them too late, instead of too early
				if ((!isSustainNote
					&& strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					|| (isSustainNote
						&& strumTime > Conductor.songPosition - Conductor.safeZoneOffset
						&& strumTime <= Conductor.songPosition))
					canBeHit = true;
				else
					canBeHit = false;

				if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
					tooLate = true;
				if (isLastSustain)
				{
					if (strumTime <= Conductor.songPosition && prevNote.wasGoodHit)
						wasGoodHit = true;
				}
			}
			else
			{
				canBeHit = false;

				if (strumTime <= Conductor.songPosition)
					wasGoodHit = true;
			}

			if (tooLate)
			{
				if (alpha > 0.3)
					alpha = 0.3;
			}
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
			if (!alphas.get(type).exists(animation.curAnim.name))
			{
				alphas.get(type).set(animation.curAnim.name, new Map());
				indexes.get(type).set(animation.curAnim.name, new Map());
			}
			if (!alphas.get(type).get(animation.curAnim.name).exists(animation.curAnim.curFrame))
			{
				alphas.get(type).get(animation.curAnim.name).set(animation.curAnim.curFrame, []);
				indexes.get(type).get(animation.curAnim.name).set(animation.curAnim.curFrame, []);
			}
			if (!alphas.get(type)
				.get(animation.curAnim.name)
				.get(animation.curAnim.curFrame)
				.contains(alpha))
			{
				var pix:FlxGraphic = FlxGraphic.fromFrame(frame, true);
				var nalp:Array<Float> = alphas.get(type).get(animation.curAnim.name).get(animation.curAnim.curFrame);
				var nindex:Array<Int> = indexes.get(type).get(animation.curAnim.name).get(animation.curAnim.curFrame);
				pix.bitmap.colorTransform(pix.bitmap.rect, colorTransform);
				glist.push(pix);
				nalp.push(alpha);
				nindex.push(glist.length - 1);
				alphas.get(type).get(animation.curAnim.name).set(animation.curAnim.curFrame, nalp);
				indexes.get(type).get(animation.curAnim.name).set(animation.curAnim.curFrame, nindex);
			}
			var dex = alphas.get(type)
				.get(animation.curAnim.name)
				.get(animation.curAnim.curFrame)
				.indexOf(alpha);
			gpix = glist[
				indexes.get(type).get(animation.curAnim.name).get(animation.curAnim.curFrame)[dex]
			];
			oalp = alpha;
			oanim = animation.curAnim.name;
		}
		return gpix;
	}
}
