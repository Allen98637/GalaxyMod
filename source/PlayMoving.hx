package;

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

class PlayMoving
{
	public static var sy:Float = 50;
	public static var xlist:Array<Float> = [50, 162, 274, 386];
	public static var oxlist(default, null):Array<Float> = [50, 162, 274, 386];
	public static var pxlist:Array<Float> = [690, 802, 914, 1026];
	public static var poxlist(default, null):Array<Float> = [690, 802, 914, 1026];
	public static var nlist:Array<Float> = [50, 162, 274, 386];
	public static var pnlist:Array<Float> = [690, 802, 914, 1026];
	public static var ylist:Array<Float> = [50, 50, 50, 50];
	public static var pylist:Array<Float> = [50, 50, 50, 50];
	public static var ns:String = "";
	public static var stage:Array<Int> = [0, 0];

	public static function reset()
	{
		if (FlxG.save.data.downscroll)
		{
			sy = 550;
			ylist = [550, 550, 550, 550];
			pylist = [550, 550, 550, 550];
		}
		else
		{
			sy = 50;
			ylist = [50, 50, 50, 50];
			pylist = [50, 50, 50, 50];
		}
		xlist = [50, 162, 274, 386];
		pxlist = [690, 802, 914, 1026];
		nlist = [50, 162, 274, 386];
		pnlist = [690, 802, 914, 1026];
		ns = "";
		stage = [Std.int(Capabilities.screenResolutionX), Std.int(Capabilities.screenResolutionY)];

		Note.refresh();
		NoteStrum.refresh();
		NoteSplash.refresh();

		modcharts.M_game.reset();
		modcharts.M_familanna.reset();
		modcharts.M_newton.reset();
		modcharts.M_destiny.reset();
		modcharts.M_peace.reset();
	}

	// trace(Lib.current.stage.stageWidth);

	public static function pos(daNote:Note, strumLine:FlxSprite)
	{
		if (PlayState.SONG.song.toLowerCase() == "galaxy" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_galaxy.pos(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_game.pos(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_kastimagina.pos(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_cona.pos(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_underworld.pos(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_cyber.pos(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			modcharts.M_familanna.pos(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "newton" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_newton.pos(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_destiny.pos(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_peace.pos(daNote);
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
		if (PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_game.spos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_kastimagina.spos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_cona.spos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_underworld.spos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_cyber.spos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			modcharts.M_familanna.spos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "newton" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_newton.spos(dastrum);
		}
		else if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_destiny.spos(dastrum);
		}
		else if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_peace.spos(dastrum);
		}
	}

	public static function pspos(dastrum:NoteStrum, strumLine:FlxSprite)
	{
		if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_underworld.pspos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			modcharts.M_familanna.pspos(dastrum, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "newton" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_newton.pspos(dastrum);
		}
	}

	public static function ongood(daNote:Note):Void
	{
		if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			modcharts.M_familanna.ongood(daNote);
		}
		if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_destiny.ongood(daNote);
		}
		if (PlayState.SONG.song.toLowerCase() == "peace")
		{
			modcharts.M_peace.ongood(daNote);
		}
	}

	public static function shape(daNote:Note, strumLine:FlxSprite, camHUD:FlxCamera):Void
	{
		if (PlayState.SONG.song.toLowerCase() == "newton" && PlayState.storyDifficulty != 0)
		{
			if (modcharts.M_newton.shape(daNote, camHUD))
				return;
		}
		if (daNote.isSustainNote && daNote.rendermode == 0)
		{
			if (ups(daNote, strumLine) == 1)
			{
				if (daNote.animation.curAnim.name.endsWith('end'))
					daNote.y += daNote.height;
			}
			daNote.clipRect = null;
		}
		// i am so fucking sorry for this if condition
		if (daNote.isSustainNote
			&& ((ups(daNote, strumLine) == 1
				&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= stry(daNote, strumLine) + Note.swagWidth / 2)
				|| (ups(daNote, strumLine) == 2 && daNote.y + daNote.offset.y <= stry(daNote, strumLine) + Note.swagWidth / 2)
				|| (ups(daNote, strumLine) == 0 && daNote.x + daNote.offset.x <= stry(daNote, strumLine) + Note.swagWidth / 2)
				|| (ups(daNote, strumLine) == 3
					&& daNote.x - daNote.offset.x * daNote.scale.y + daNote.height >= stry(daNote, strumLine) + Note.swagWidth / 2))
			&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
		{
			var swagRect = new FlxRect(0, stry(daNote, strumLine) + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
			switch (ups(daNote, strumLine))
			{
				case 0:
					swagRect.y = stry(daNote, strumLine) + Note.swagWidth / 2 - daNote.x;
					swagRect.x /= daNote.scale.y;
					swagRect.height -= swagRect.y;
				case 1:
					swagRect.height = (stry(daNote, strumLine) + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
					swagRect.y = daNote.frameHeight - swagRect.height;
				case 2:
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;
				case 3:
					swagRect.height = (stry(daNote, strumLine) + Note.swagWidth / 2 - daNote.x) / daNote.scale.y;
					swagRect.y = daNote.frameWidth - swagRect.height;
			}
			daNote.clipRect = swagRect;
		}
	}

	inline static public function show(daNote:Note):Bool
	{
		if (Conductor.songPosition > daNote.strumTime)
			return false;
		if (PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_game.show(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_kastimagina.show(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_underworld.show(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_cyber.show(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			return modcharts.M_familanna.show(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "newton" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_newton.show(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_destiny.show(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_peace.show(daNote);
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
		if (!daNote.tooLate || !daNote.mustPress)
			return false;
		if (PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_game.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_kastimagina.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_cona.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_underworld.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_cyber.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			return modcharts.M_familanna.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "newton" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_newton.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_destiny.kill(daNote);
		}
		else if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_peace.kill(daNote);
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
		if (PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_game.ups(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_cona.ups(daNote, strumLine);
		}
		else if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_underworld.ups(daNote, strumLine);
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
		if (PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_game.stry(daNote, strumLine);
		}
		if (PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_kastimagina.stry(daNote, strumLine);
		}
		if (PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_cona.stry(daNote, strumLine);
		}
		if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			return modcharts.M_underworld.stry(daNote, strumLine);
		}
		else
		{
			return strumLine.y;
		}
	}

	public static function clone(daNote:Note)
	{
		if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_peace.clone(daNote);
		}
	}

	public static function special(state:PlayState)
	{
		if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_destiny.special(state);
		}
		if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_peace.special(state);
		}
	}

	public static function beatHit(state:PlayState, curBeat:Int)
	{
		if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			modcharts.M_destiny.beatHit(state, curBeat);
		}
		if (PlayState.SONG.song.toLowerCase() == "peace")
		{
			modcharts.M_peace.beatHit(curBeat);
		}
	}

	public static function ease(num:Float, mode:Int = 2):Float // 0:in 1:out 2:in and out
	{
		if (num > 1)
			return 1;
		if (num < 0)
			return 0;
		if (mode == 0)
			return (FlxMath.fastCos(num * Math.PI / 2) * -1 + 1);
		else if (mode == 1)
			return (FlxMath.fastSin(num * Math.PI / 2) + 1);
		return (FlxMath.fastCos(num * Math.PI) * -1 + 1) / 2;
	}
}
