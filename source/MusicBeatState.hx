package;

import Conductor.BPMChangeEvent;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	public static var mouseX:Float = 0;
	public static var mouseY:Float = 0;
	public static var mouseS:Float = 0;
	public static var mouseA:Bool = true;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		checkmouse(elapsed, this);

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}

	var loadedCompletely:Bool = false;

	public function load()
	{
		loadedCompletely = true;

		trace("loaded Completely");
	}

	override function remove(Object:FlxBasic, Splice:Bool = false):FlxBasic
	{
		LoadingState.allOfThem.remove(Object);
		return super.remove(Object, Splice);
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Std.isOfType(Object, FlxUI))
			return null;
		LoadingState.allOfThem.push(Object);

		return super.add(Object);
	}

	public static function checkmouse(elapsed:Float, state:FlxState)
	{
		mouseS += elapsed;
		if (Math.abs(mouseX - FlxG.mouse.screenX) > 20 || Math.abs(mouseY - FlxG.mouse.screenY) > 20 || FlxG.mouse.justPressed)
		{
			mouseS = 0;
			mouseX = FlxG.mouse.screenX;
			mouseY = FlxG.mouse.screenY;
		}
		if (mouseS > 2)
		{
			FlxG.mouse.visible = false;
			mouseA = false;
		}
		else
		{
			mouseA = true;
			switch (FlxG.save.data.mouse)
			{
				case 1:
					FlxG.mouse.visible = true;
					FlxG.mouse.useSystemCursor = true;
				case 2:
					FlxG.mouse.visible = false;
					mouseA = false;
				default:
					FlxG.mouse.visible = true;
					FlxG.mouse.useSystemCursor = false;
			}
		}
	}
}
