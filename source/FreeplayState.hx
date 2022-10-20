package; #if desktop import Discord.DiscordClient; #end import flash.text.TextField;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	public var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var otherText:FlxText;
	var lerpScore:Int = 0;
	var lerpAcc:Float = 0;
	var lerpCombo:Int = 0;
	var intendedScore:Int = 0;
	var intendedAcc:Float = 0;
	var intendedCombo:Int = 0;
	var scoreBG:FlxSprite;

	var bg:FlxSprite;
	var intendedColor:Int = 0xFFffffff;
	var colorTween:FlxTween;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var grpChildren:FlxTypedGroup<FlxBasic>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var colors:Array<Int> = [0xFF9271fd, 0xFF1adbdf, 0xFFffd101, 0xFFc262e3];

	var gods:Array<String> = ["Kastimagina", "Cyber", "Peace"];
	var godweeks:Array<Int> = [1, 2, 3];

	override function load()
	{
		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 0, 'gf', 'Kawai Sprite'));
		}
		addWeek(['Galaxy', 'Game'], 1, ['kastimagina'], ["Allen98637"]);
		if (StoryMenuState.weekPassed[1].contains(true) || isDebug)
		{
			addSong("Kastimagina", 1, 'kastimagina', "Allen98637");
			#if (desktop || web)
			addSong('Familanna', 1, 'kastimagina', "Allen98637");
			#end
		}
		addWeek(['Cona', 'Underworld'], 2, ['kalisa'], ["Allen98637"]);
		if (StoryMenuState.weekPassed[2].contains(true) || isDebug)
		{
			#if desktop
			addSong('Cyber', 2, 'kalisa', "Allen98637");
			#end
		}
		addWeek(['Newton', 'Destiny'], 3, ['unknown'], ["Allen98637"]);
		if (StoryMenuState.weekPassed[3].contains(true) || isDebug)
		{
			#if (desktop || web)
			addSong('Peace', 3, 'unknown', "Allen98637");
			#end
		}
		var tasks:Int = songs.length;
		var task:Int = 0;

		for (i in 0...songs.length)
		{
			FlxG.sound.load(Paths.inst(songs[i].songName), 0);
			task += 1;
			LoadingState.progress = Std.int(task / tasks * 100);
		}
		super.load();
	}

	override function create()
	{
		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.color = 0xffffff;

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		grpChildren = new FlxTypedGroup<FlxBasic>();
		add(grpChildren);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var child:Alphabet = new Alphabet(0, (70 * i) + 55, "-" + songs[i].songAuthor, false, false, false, 0.6, 0.6);
			child.isMenuItem = true;
			child.targetY = i;
			if (songText.sumwidth > child.sumwidth)
				child.textOffset = (songText.sumwidth - child.sumwidth) / 3.5;
			songText.children.push(child);
			grpChildren.add(child);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		if (FlxG.save.data.lang == 1)
			scoreText.setFormat(Paths.font("taipei.ttf"), 32, FlxColor.WHITE, RIGHT);
		else
			scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 115, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT);

		otherText = new FlxText(diffText.x, diffText.y + 28, 0, "", 20);
		otherText.font = scoreText.font;

		add(diffText);

		add(scoreText);
		add(otherText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songAuthor:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, songAuthor));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?songAuthors:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];
		if (songAuthors == null)
			songAuthors = ['Kawai Sprite'];

		var num:Int = 0;
		var num2:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], songAuthors[num2]);

			if (songCharacters.length != 1)
				num++;
			if (songAuthors.length != 1)
				num2++;
		}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		lerpAcc = Math.round(FlxMath.lerp(lerpAcc, intendedAcc, 0.4) * 100) / 100;
		lerpCombo = Math.floor(FlxMath.lerp(lerpCombo, Math.abs(intendedCombo), 0.4));

		var tarc:FlxColor = 0xFF000000;
		if (intendedAcc == 100)
			tarc = 0xFFfed700;
		else if (intendedAcc >= 95)
			tarc = 0xFFeaeaea;
		else if (intendedAcc >= 90)
			tarc = 0xFFff00dd;
		else if (intendedAcc >= 80)
			tarc = 0xFFff0000;
		else if (intendedAcc >= 70)
			tarc = 0xFF00ff00;
		else if (intendedAcc > 0)
			tarc = 0xFF878787;

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpAcc - intendedAcc) <= 2)
			lerpAcc = intendedAcc;
		if (Math.abs(lerpCombo - Math.abs(intendedCombo)) <= 5)
			lerpCombo = Math.floor(Math.abs(intendedCombo));

		if (FlxG.save.data.lang == 1)
			scoreText.text = "個人紀錄:" + lerpScore;
		else
			scoreText.text = "PERSONAL BEST:" + lerpScore;
		var fc:String = "";
		if (intendedCombo < 0)
			fc = "(FC)";
		if (FlxG.save.data.lang == 1)
			otherText.text = "準確度:" + lerpAcc + "%\n連擊:" + lerpCombo + fc + "\n";
		else
			otherText.text = "Accuracy:" + lerpAcc + "%\nCombo:" + lerpCombo + fc + "\n";
		scoreBG.makeGraphic(Std.int(FlxG.width * 0.35), 115, tarc);

		var upP = controls.UP_UI;
		var downP = controls.DOWN_UI;
		var accepted = controls.ACCEPT;

		if (FlxG.mouse.screenX > scoreBG.x
			&& FlxG.mouse.screenX < scoreBG.x + scoreBG.width
			&& FlxG.mouse.screenY > scoreBG.y
			&& FlxG.mouse.screenY < scoreBG.y + scoreBG.height)
		{
			var tarc:FlxColor = 0xFF646464;
			if (intendedAcc == 100)
				tarc = 0xFFffff64;
			else if (intendedAcc >= 95)
				tarc = 0xFFffffff;
			else if (intendedAcc >= 90)
				tarc = 0xFFff64ff;
			else if (intendedAcc >= 80)
				tarc = 0xFFff6464;
			else if (intendedAcc >= 70)
				tarc = 0xFF64ff64;
			else if (intendedAcc > 0)
				tarc = 0xFFebebeb;
			scoreBG.makeGraphic(Std.int(FlxG.width * 0.35), 115, tarc);
			if (FlxG.mouse.justPressed)
				changeDiff(1);
		}

		var bruh:Int = 0;
		var brighter:Int = -1;
		for (item in grpSongs.members)
		{
			if (FlxG.mouse.screenX > item.x
				&& FlxG.mouse.screenX < item.x + item.width
				&& FlxG.mouse.screenY > item.y
				&& FlxG.mouse.screenY < item.y + item.height
				&& MusicBeatState.mouseA)
			{
				brighter = bruh;
				if (FlxG.mouse.justPressed)
				{
					if (curSelected == bruh)
						accepted = true;
					else
						changeSelection(bruh - curSelected);
				}
			}
			bruh += 1;
		}
		for (i in 0...iconArray.length)
		{
			if (FlxG.mouse.screenX > iconArray[i].x
				&& FlxG.mouse.screenX < iconArray[i].x + iconArray[i].width
				&& FlxG.mouse.screenY > iconArray[i].y
				&& FlxG.mouse.screenY < iconArray[i].y + iconArray[i].height
				&& MusicBeatState.mouseA)
			{
				brighter = i;
				if (FlxG.mouse.justPressed)
				{
					if (curSelected == bruh)
						accepted = true;
					else
						changeSelection(i - curSelected);
				}
			}
		}
		var bruh = 0;
		for (item in grpSongs.members)
		{
			if (item.alpha != 1 && bruh == brighter)
			{
				item.alpha = 0.8;
				item.children[0].alpha = 0.8;
			}
			else if (item.alpha != 1)
			{
				item.alpha = 0.6;
				item.children[0].alpha = 0.6;
			}
			bruh += 1;
		}
		for (i in 0...iconArray.length)
		{
			if (iconArray[i].alpha != 1 && i == brighter)
				iconArray[i].alpha = 0.8;
			else if (iconArray[i].alpha != 1)
				iconArray[i].alpha = 0.6;
		}

		if (upP || FlxG.mouse.wheel > 0)
		{
			changeSelection(-1);
		}
		if (downP || FlxG.mouse.wheel < 0)
		{
			changeSelection(1);
		}

		if (controls.LEFT_UI)
			changeDiff(-1);
		if (controls.RIGHT_UI)
			changeDiff(1);

		if (controls.BACK)
		{
			MainMenuState.storied = true;
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			LoadingState.loadAndSwitchState(new MainMenuState(), false, 1);
		}

		if (accepted && (songs[curSelected].songName != "Familanna" || curDifficulty == 0))
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			if (colorTween != null)
			{
				colorTween.cancel();
			}

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);

			LoadingState.loadAndSwitchState(new PlayState(), true);
		}
	}

	function changeDiff(change:Int = 0)
	{
		if (gods.contains(songs[curSelected].songName))
		{
			var diffs:Array<Int> = [];
			var daDiff:Int = 0;
			for (i in StoryMenuState.weekPassed[godweeks[gods.indexOf(songs[curSelected].songName)]])
			{
				if (i)
					diffs.push(daDiff);
				daDiff++;
			}
			var dex:Int = diffs.indexOf(curDifficulty);
			dex += change;
			dex += diffs.length;
			dex %= diffs.length;
			curDifficulty = diffs[dex];
		}
		else
		{
			curDifficulty += change;

			if (curDifficulty < 0)
				curDifficulty = 2;
			/*if (songs[curSelected].songName == "Familanna")
				{
					if (curDifficulty > 3)
						curDifficulty = 0;
				}
				else
				{ */
			if (curDifficulty > 2)
				curDifficulty = 0;
		}
		// }

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedAcc = Highscore.getAcc(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getCombo(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
			case 3:
				diffText.text = "TRUE";
		}
		changeBoard();
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;
		if (curDifficulty > 2)
		{
			curDifficulty = 1;
			diffText.text = 'NORMAL';
		}
		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		if (gods.contains(songs[curSelected].songName))
		{
			var diffs:Array<Int> = [];
			var daDiff:Int = 0;
			for (i in StoryMenuState.weekPassed[godweeks[gods.indexOf(songs[curSelected].songName)]])
			{
				if (i)
					diffs.push(daDiff);
				daDiff++;
			}
			if (!diffs.contains(curDifficulty))
			{
				var difftexts:Array<String> = ["EASY", "NORMAL", "HARD"];
				curDifficulty = diffs[0];
				diffText.text = difftexts[diffs[0]];
			}
		}

		if (colors[songs[curSelected].week] != intendedColor)
		{
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			intendedColor = colors[songs[curSelected].week];
			colorTween = FlxTween.color(bg, 1, bg.color + 0xFF000000, intendedColor, {
				onComplete: function(twn:FlxTween)
				{
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedAcc = Highscore.getAcc(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getCombo(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			item.children[0].targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			item.children[0].alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				item.children[0].alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		changeBoard();
	}

	function changeBoard()
	{
		/*FlxGameJolt.fetchScore(score + "(" + acc + "%)", Math.floor(score * 100 + acc), APIStuff.boards.get(song)[diff], false, "", "", function(a:Dynamic)
			{
				task = false;
				trace(APIStuff.boards.get(song)[diff]);
				trace(a);
		});*/
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songAuthor:String = "";

	public function new(song:String, week:Int, songCharacter:String, author:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songAuthor = author;
	}
}
