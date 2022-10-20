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

class M_kastimagina
{
	public static var shinelist:Array<Float> = [
		 45082.87292817678,  46408.83977900551,  47734.80662983424,  49060.77348066297,  49723.75690607733, 50386.740331491696, 51712.707182320424,
		 53038.67403314915,  54364.64088397788, 55027.624309392246,  55690.60773480661,  57016.57458563534,  58342.54143646407, 59668.508287292796,
		 60331.49171270716,  60662.98342541434, 60994.475138121525,  62320.44198895025,  63646.40883977898,  64972.37569060771,  65635.35911602208,
		 65966.85082872926, 135248.61878453035, 136574.58563535908,  137900.5524861878, 139226.51933701654,  139889.5027624309, 140552.48618784526,
		  141878.453038674, 143204.41988950272, 144530.38674033145, 145193.37016574582, 145856.35359116018,  147182.3204419889, 148508.28729281764,
		149834.25414364637, 150497.23756906073,  151160.2209944751, 152486.18784530382, 153812.15469613255, 155138.12154696128, 155801.10497237564
	];

	public static function pos(daNote:Note, strumLine:FlxSprite)
	{
		if ((daNote.strumTime > 2652 && daNote.strumTime < 12929) || (daNote.strumTime > 156465 && daNote.strumTime < 166741))
		{
			if (daNote.mustPress)
				daNote.x = PlayMoving.pxlist[daNote.noteData];
			else
				daNote.x = PlayMoving.xlist[daNote.noteData];
			daNote.y = PlayMoving.ylist[daNote.noteData];
			if (Conductor.songPosition > daNote.strumTime)
				daNote.alpha = 0;
		}
		else if ((daNote.strumTime > 23867 && daNote.strumTime < 34393))
		{
			if (daNote.noteData % 2 == 0)
				daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if ((daNote.strumTime > 34475 && daNote.strumTime < 45000))
		{
			if (daNote.noteData % 2 == 1)
				daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime > 103425 && daNote.strumTime < 135166 && Conductor.songPosition < 124640.8839779005)
		{
			if (daNote.noteData == 2 || daNote.noteData == 1)
				daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime > 13259 && daNote.strumTime < 23785)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			if (daNote.strumTime - Conductor.songPosition < 100)
				daNote.alpha = 0;
			else if (daNote.strumTime - Conductor.songPosition < 500)
				daNote.alpha = (daNote.strumTime - Conductor.songPosition - 100) / 400;
		}
		else if ((daNote.strumTime > 45082 && daNote.strumTime < 66216) || (daNote.strumTime > 135248 && daNote.strumTime < 156465))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (Conductor.songPosition >= i)
					index += 1;
			}
			if (index % 2 == 1)
				daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime > 66298 && daNote.strumTime < 82045)
		{
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y
					+ ((66298.34254143645 + FlxMath.roundDecimal((Conductor.songPosition - 66298.34254143645) / 165.745856354, 0) * 165.745856354)
						- daNote.strumTime) * (0.3 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y
					- ((66298.34254143645 + FlxMath.roundDecimal((Conductor.songPosition - 66298.34254143645) / 165.745856354, 0) * 165.745856354)
						- daNote.strumTime) * (0.3 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime > 82209 && daNote.strumTime < 103338)
		{
			if (Std.int((daNote.strumTime - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) % 2 == 0)
				daNote.y = -75
					+ 775 * (((daNote.strumTime - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			else
				daNote.y = 700
					- 775 * (((daNote.strumTime - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			if (Std.int((daNote.strumTime - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) == Std.int((Conductor.songPosition
				- 82209.94475138119) / (83535.91160220992 - 82209.94475138119)))
				daNote.alpha = 1;
			else
				daNote.alpha = 0.7;
		}
		else if (daNote.strumTime >= 124640 && daNote.strumTime < 135166 && Conductor.songPosition >= 124640.8839779005)
		{
			if (daNote.mustPress)
				daNote.x = PlayMoving.pxlist[daNote.noteData];
			else
				daNote.x = PlayMoving.xlist[daNote.noteData];
			if (FlxG.save.data.downscroll)
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(0.75 * PlayState.SONG.speed, 2)));
			else
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(0.75 * PlayState.SONG.speed, 2)));
		}
		else if (daNote.strumTime >= 167071)
		{
			if (FlxG.save.data.downscroll)
			{
				if (daNote.noteData == 1)
				{
					if (daNote.animation.curAnim.name.endsWith('hold'))
						daNote.animation.play('greenhold');
					else if (daNote.animation.curAnim.name.endsWith('end'))
						daNote.animation.play('greenholdend');
					else
						daNote.animation.play('greenScroll');
					daNote.noteData = 2;
				}
			}
			if (daNote.mustPress)
				daNote.x = 858;
			else
				daNote.x = 218;
			if (FlxG.save.data.downscroll)
				daNote.y = (188 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				daNote.y = (412 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			if (daNote.isSustainNote)
				daNote.x += daNote.width;
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
		if ((Conductor.songPosition >= 2651.9337016574586 && Conductor.songPosition < 13259.668508287292)
			|| (Conductor.songPosition >= 156464.08839779 && Conductor.songPosition < 166740.33149171266))
		{
			PlayMoving.xlist = [106, 218, 218, 330];
			PlayMoving.pxlist = [746, 858, 858, 970];
			PlayMoving.ylist = [300, 412, 188, 300];
			if (dastrum.x > 640)
			{
				dastrum.x = PlayMoving.pxlist[dastrum.ID];
				dastrum.y = PlayMoving.ylist[dastrum.ID];
			}
			else
			{
				dastrum.x = PlayMoving.xlist[dastrum.ID];
				dastrum.y = PlayMoving.ylist[dastrum.ID];
			}
		}
		else if (Conductor.songPosition >= 13259.668508287292 && Conductor.songPosition < 23784.530386740327)
		{
			PlayMoving.xlist = [50, 162, 274, 386];
			PlayMoving.pxlist = [690, 802, 914, 1026];
			if (FlxG.save.data.downscroll)
				PlayMoving.ylist = [550, 550, 550, 550];
			else
				PlayMoving.ylist = [50, 50, 50, 50];
			if (dastrum.x > 640)
			{
				dastrum.x = PlayMoving.pxlist[dastrum.ID];
				dastrum.y = PlayMoving.ylist[dastrum.ID];
			}
			else
			{
				dastrum.x = PlayMoving.xlist[dastrum.ID];
				dastrum.y = PlayMoving.ylist[dastrum.ID];
			}
		}
		else if ((Conductor.songPosition > 45082 && Conductor.songPosition < 55525)
			|| (Conductor.songPosition > 55690.60773480661 && Conductor.songPosition < 66215.46961325964)
			|| (Conductor.songPosition > 135248 && Conductor.songPosition < 156382))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (Conductor.songPosition >= i)
					index += 1;
			}
			PlayMoving.xlist = [50, 162, 274, 386];
			PlayMoving.pxlist = [690, 802, 914, 1026];
			if (dastrum.x > 640)
				dastrum.x = PlayMoving.pxlist[dastrum.ID];
			else
				dastrum.x = PlayMoving.xlist[dastrum.ID];
			if (index % 2 == 1)
				dastrum.y = 50;
			else
				dastrum.y = 550;
		}
		else if ((Conductor.songPosition >= 23867.403314917123 && Conductor.songPosition < 44999.999999999985)
			|| (Conductor.songPosition >= 103425.41436464085 && Conductor.songPosition < 124558.01104972372))
		{
			dastrum.y = 300;
		}
		else if (Conductor.songPosition >= 66298.34254143645 && Conductor.songPosition < 71436.46408839777)
		{
			PlayMoving.xlist = [50, 162, 274, 386];
			PlayMoving.pxlist = [690, 802, 914, 1026];
			if (dastrum.x > 640)
				dastrum.x = PlayMoving.pxlist[dastrum.ID];
			else
				dastrum.x = PlayMoving.xlist[dastrum.ID];
			if (FlxG.save.data.downscroll)
				dastrum.y = 550;
			else
				dastrum.y = 50;
		}
		else if (Conductor.songPosition >= 82209.94475138119 && Conductor.songPosition < 103337.0165745856)
		{
			if (Std.int((Conductor.songPosition - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) % 2 == 0)
				dastrum.y = -75
					+
					775 * (((Conductor.songPosition - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			else
				dastrum.y = 700
					- 775 * (((Conductor.songPosition - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			strumLine.y = dastrum.y;
		}
		else if (Conductor.songPosition >= 124640.8839779005 && Conductor.songPosition < 135165.74585635355)
		{
			if (dastrum.x > 640)
			{
				PlayMoving.pxlist[dastrum.ID] = FlxMath.fastSin((((Conductor.songPosition - 124640.8839779005) / 1325.96685083
					+ (-0.5 + dastrum.ID / 3)) * 3.1415926535)) * 168
					+ 858;
				dastrum.x = PlayMoving.pxlist[dastrum.ID];
			}
			else
			{
				PlayMoving.xlist[dastrum.ID] = FlxMath.fastSin((((Conductor.songPosition - 124640.8839779005) / 1325.96685083
					+ (-0.5 + dastrum.ID / 3)) * 3.1415926535)) * 168
					+ 218;
				dastrum.x = PlayMoving.xlist[dastrum.ID];
			}
			if (FlxG.save.data.downscroll)
				dastrum.y = 550;
			else
				dastrum.y = 50;
			strumLine.y = dastrum.y;
		}
	}

	inline static public function show(daNote:Note):Bool
	{
		if ((daNote.strumTime > 2652 && daNote.strumTime < 12929) || (daNote.strumTime > 156465 && daNote.strumTime < 166741))
		{
			return daNote.strumTime - Conductor.songPosition > (2983.425414364641 - 2651.9337016574586);
		}
		else if (daNote.strumTime > 13259 && daNote.strumTime < 23785)
		{
			return (daNote.y > FlxG.height) || Conductor.songPosition < 13259.668508287292;
		}
		else if (daNote.strumTime > 23867 && daNote.strumTime < 45000)
		{
			return (daNote.y < -daNote.height) || (daNote.y > FlxG.height) || Conductor.songPosition < 23867.403314917123;
		}
		else if ((daNote.strumTime > 45082 && daNote.strumTime < 66216) || (daNote.strumTime > 135248 && daNote.strumTime < 145856))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (daNote.strumTime - 331 >= i)
					index += 1;
			}
			if (daNote.strumTime > 135248)
				return Conductor.songPosition < shinelist[index - 1] || Conductor.songPosition < 135248;
			else
				return Conductor.songPosition < shinelist[index - 1] || Conductor.songPosition < 45082;
		}
		else if (daNote.strumTime > 145856 && daNote.strumTime < 156465)
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (daNote.strumTime >= i)
					index += 1;
			}
			return (daNote.y < -daNote.height) || (daNote.y > FlxG.height);
		}
		else if (daNote.strumTime > 66298 && daNote.strumTime < 82045)
		{
			return (daNote.y > FlxG.height) || Conductor.songPosition < 66298.34254143645;
		}
		else if (daNote.strumTime > 82209 && daNote.strumTime < 103338)
		{
			return (daNote.strumTime - Conductor.songPosition) > (83204.41988950274 - 82209.94475138119)
				|| Conductor.songPosition < 82209.94475138119;
		}
		else if (daNote.strumTime > 103425 && daNote.strumTime < 135166 && Conductor.songPosition < 124640.8839779005)
		{
			return (daNote.y < -daNote.height) || (daNote.y > FlxG.height) || Conductor.songPosition < 103425.41436464085;
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
		if ((daNote.strumTime > 0 && daNote.strumTime < 12929) || (daNote.strumTime > 156464 && daNote.strumTime < 166741))
		{
			return daNote.tooLate;
		}
		else if ((daNote.strumTime > 23867 && daNote.strumTime < 45000)
			|| (daNote.strumTime > 103425 && daNote.strumTime < 135166 && Conductor.songPosition < 124640.8839779005))
		{
			return ((daNote.y < -daNote.height) || (daNote.y > FlxG.height)) && daNote.tooLate;
		}
		else if ((daNote.strumTime > 45082 && daNote.strumTime < 66216) || (daNote.strumTime > 135248 && daNote.strumTime < 156465))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (Conductor.songPosition >= i)
					index += 1;
			}
			if (index % 2 == 1)
				return daNote.y < -daNote.height;
			else
				return daNote.y > FlxG.height;
		}
		else if (daNote.strumTime > 82209 && daNote.strumTime < 103338)
		{
			return Conductor.songPosition - daNote.strumTime > (1000 / 6);
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return daNote.y > FlxG.height;
			else
				return daNote.y < -daNote.height;
		}
	}

	inline static public function stry(daNote:Note, strumLine:FlxSprite)
	{
		if (FlxG.save.data.downscroll)
			return 188;
		else
			return 412;
	}
}
