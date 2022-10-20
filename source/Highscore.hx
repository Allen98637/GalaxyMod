package;

import flixel.FlxG;
import flixel.addons.api.FlxGameJolt;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songAccs:Map<String, Float> = new Map();
	public static var songCombos:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songAccs:Map<String, Float> = new Map<String, Float>();
	public static var songCombos:Map<String, Int> = new Map<String, Int>();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static function saveScore(song:String, score:Int = 0, acc:Float = 0, com:Int = 0, ?diff:Int = 0, screen:ResultScreen):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
		if (songAccs.exists(daSong))
		{
			if (songAccs.get(daSong) < acc)
				setAcc(daSong, acc);
		}
		else
			setAcc(daSong, acc);
		if (songCombos.exists(daSong))
		{
			if (Math.abs(songCombos.get(daSong)) < Math.abs(com) || com < 0)
				setCombo(daSong, com);
		}
		else
			setCombo(daSong, com);

		#if PRELOAD_ALL
		if (APIStuff.boards.exists(song) && FlxGameJolt.initialized)
		{
			var task = true;
			FlxGameJolt.addScore(score + "(" + acc + "%)", Math.floor(score * 100 + acc), APIStuff.boards.get(song)[diff], false, "", "", function(a:Dynamic)
			{
				task = false;
				trace(APIStuff.boards.get(song)[diff]);
				trace(a);
			});
			var k:Int = 0;
			while (task && k < 30)
			{
				k += 1;
				Sys.sleep(0.1);
			}
			if (FlxG.save.data.autoUpload && FlxGameJolt.initialized)
			{
				Main.syncData();
			}
		}
		#end
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{
		var weekc:String = "" + week;
		if (week == 1)
		{
			weekc = "s";
		}
		else if (week == 2)
		{
			weekc = "k";
		}
		else if (week == 3)
		{
			weekc = "m";
		}

		var daWeek:String = formatSong('week' + weekc, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setAcc(song:String, acc:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songAccs.set(song, acc);
		FlxG.save.data.songAccs = songAccs;
		FlxG.save.flush();
	}

	static function setCombo(song:String, com:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songCombos.set(song, com);
		FlxG.save.data.songCombos = songCombos;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';
		else if (diff == 3)
			daSong += '-true';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getAcc(song:String, diff:Int):Float
	{
		if (!songAccs.exists(formatSong(song, diff)))
			setAcc(formatSong(song, diff), 0);

		return songAccs.get(formatSong(song, diff));
	}

	public static function getCombo(song:String, diff:Int):Int
	{
		if (!songCombos.exists(formatSong(song, diff)))
			setCombo(formatSong(song, diff), 0);

		return songCombos.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		var weekc:String = "" + week;
		if (week == 1)
		{
			weekc = "s";
		}
		else if (week == 2)
		{
			weekc = "k";
		}
		else if (week == 3)
		{
			weekc = "m";
		}
		if (!songScores.exists(formatSong('week' + weekc, diff)))
			setScore(formatSong('week' + weekc, diff), 0);

		return songScores.get(formatSong('week' + weekc, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songAccs != null)
		{
			songAccs = FlxG.save.data.songAccs;
		}
		if (FlxG.save.data.songCombos != null)
		{
			songCombos = FlxG.save.data.songCombos;
		}
	}
}
