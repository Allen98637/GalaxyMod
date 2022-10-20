package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['galaxy', 'game', 'kastimagina'],
		['cona', 'underworld'],
		['newton', 'destiny', 'peace']
	];
	var curDifficulty:Int = 1;

	public static var weekPassed:Array<Array<Bool>> = [
		[false, false, false],
		[false, false, false],
		[false, false, false],
		[false, false, false]
	];

	var weekCharacters:Array<String> = ["gf", "kastimagina", "kalisa", "unknown"];

	var weekNames:Array<String> = ["", "Kastimagina Ya", "Kalisa", "???"];

	var intros:Array<String> = [
		"Tutorial is here, as always",
		"Kastimagina is a 14-year-old Taiwanese genious engineer and language speaker, she took Boyfriend and Girlfriend to a space trip suddenly, what is her purpose?",
		"All of the nice boys who confess their love to her soon find themselves \"graduated\" to the next world. Massive damage against Angels. (Area Attack)\nWhy is she here tho?",
		"She's an alien which is not in our knowledge, we just meet her in accident. Will we meet again?"
	];

	var txtWeekTitle:FlxText;
	var txtDesc:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var chara:FlxSprite;
	var bg:FlxSprite;
	var bgs:FlxSprite;
	var weekUP:FlxSprite;
	var weekDOWN:FlxSprite;

	var time:Float = 0;

	override function load()
	{
		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		var tasks:Int = 5 + weekCharacters.length;
		var task = 0;

		leftArrow = new FlxSprite(750, 550);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		task += 1;
		LoadingState.progress = Std.int(task / tasks * 100);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		task += 1;
		LoadingState.progress = Std.int(task / tasks * 100);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		task += 1;
		LoadingState.progress = Std.int(task / tasks * 100);

		weekUP = new FlxSprite(0, 60);
		weekUP.frames = ui_tex;
		weekUP.animation.addByPrefix('idle', 'weekUP');
		task += 1;
		LoadingState.progress = Std.int(task / tasks * 100);

		weekDOWN = new FlxSprite(0, 580);
		weekDOWN.frames = ui_tex;
		weekDOWN.animation.addByPrefix('idle', 'weekDOWN');
		task += 1;
		LoadingState.progress = Std.int(task / tasks * 100);

		for (i in 0...weekCharacters.length)
		{
			FlxG.sound.load(Paths.music('cht/' + weekCharacters[0]), 0);
			task += 1;
			LoadingState.progress = Std.int(task / tasks * 100);
		}

		super.load();
	}

	override function create()
	{
		#if desktop
		weekData[2] = ['cona', 'underworld', 'cyber'];
		#end
		if (FlxG.save.data.lang == 1)
		{
			weekNames = ["", "亞吉娜", "冥界卡莉法", "???"];
			intros = [
				"像平常一樣的教學",
				"亞吉娜是個來自臺灣, 14歲的天才工程師以及語言溝通者, 有一天她突然將 Boyfriend 和 Girlfriend 帶到了一個太空旅行, 她究竟有甚麼目的?",
				"畢業典禮後, 讓跑來找自己告白的男孩們都從人間畢業的傳奇少女 給予天使敵人超大傷害(範圍攻擊)\n但她為啥在這?\n",
				"她是個超出我們知識範圍的外星人，我們在意外中遇到了她，我們還會再見面嗎?"
			];
		}
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxG.sound.playMusic(Paths.music('cht/' + weekCharacters[0]), 0);
		FlxG.sound.music.fadeIn(0.2, 0, 0.7);

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('tab'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.scale.x = 0;
		bg.scale.y = 0;
		add(bg);
		FlxTween.tween(bg, {"scale.x": 1, "scale.y": 1}, 0.2, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween)
			{
				started = true;
				weekDOWN.alpha = 1;
				leftArrow.alpha = 1;
				rightArrow.alpha = 1;
				sprDifficulty.alpha = 1;
				scoreText.alpha = 1;
				txtWeekTitle.alpha = 1;
				txtTracklist.alpha = 1;
				chara.alpha = 1;
				txtDesc.alpha = 1;
			}
		});
		bgs = new FlxSprite(0, 0).loadGraphic(Paths.image('tab_s'));
		bgs.scrollFactor.x = 0;
		bgs.scrollFactor.y = 0.18;
		bgs.setGraphicSize(Std.int(bgs.width));
		bgs.updateHitbox();
		bgs.screenCenter();
		bgs.antialiasing = true;
		bgs.alpha = 0;
		add(bgs);

		scoreText = new FlxText(0, 150, 0, "SCORE\n49324858\n", 36);
		scoreText.setFormat(Paths.font("naming.ttf"), 32, 0xFFff00ff);
		scoreText.alignment = CENTER;
		scoreText.screenCenter(X);
		scoreText.alpha = 0;
		scoreText.x -= 0.045 * FlxG.width;

		txtWeekTitle = new FlxText(FlxG.width * 0.5, 80, 0, "", 32);
		txtWeekTitle.setFormat(Paths.font("naming.ttf"), 60, FlxColor.LIME, RIGHT);
		txtWeekTitle.alpha = 0;
		txtWeekTitle.bold = true;

		txtDesc = new FlxText(FlxG.width * 0.55, 150, FlxG.width * 0.35, "", 32);
		txtDesc.alpha = 0;
		txtDesc.alignment = CENTER;
		txtDesc.setFormat(Paths.font("naming.ttf"), 35);

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("naming.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		trace("Line 96");

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow.alpha = 0;
		difficultySelectors.add(leftArrow);

		sprDifficulty.alpha = 0;
		sprDifficulty.animation.play('normal');
		sprDifficulty.offset.x = 70;

		difficultySelectors.add(sprDifficulty);

		rightArrow.animation.play('idle');
		rightArrow.alpha = 0;
		difficultySelectors.add(rightArrow);

		weekUP.animation.play('idle');
		weekUP.screenCenter(X);
		weekUP.antialiasing = true;
		weekUP.alpha = 0;
		add(weekUP);

		weekDOWN.animation.play('idle');
		weekDOWN.screenCenter(X);
		weekDOWN.antialiasing = true;
		weekDOWN.alpha = 0;
		add(weekDOWN);

		txtTracklist = new FlxText(0, 400, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		txtTracklist.screenCenter(X);
		txtTracklist.x -= 0.03 * FlxG.width;
		txtTracklist.alpha = 0;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		add(txtDesc);

		chara = new FlxSprite(60, FlxG.height / 2 - 300).loadGraphic(Paths.image('characters/' + weekCharacters[curWeek]));
		chara.scrollFactor.set();
		chara.antialiasing = true;
		chara.scale.x = 0.8;
		chara.scale.y = 0.8;
		chara.alpha = 0;
		add(chara);

		updateText(0);

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		difficultySelectors.visible = true;

		if (!movedBack && started)
		{
			var others:Bool = false;
			if (!selectedWeek)
			{
				if (controls.UP_UI || FlxG.mouse.wheel > 0)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_UI || FlxG.mouse.wheel < 0)
				{
					changeWeek(1);
				}

				if (controls.RIGHT_UI_H)
					rightArrow.animation.play('press');
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT_UI_H)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (FlxG.mouse.screenX > rightArrow.x
					&& FlxG.mouse.screenX < rightArrow.x + rightArrow.width
					&& FlxG.mouse.screenY > rightArrow.y
					&& FlxG.mouse.screenY < rightArrow.y + rightArrow.height
					&& MusicBeatState.mouseA)
				{
					rightArrow.animation.play('press');
					others = true;
					if (FlxG.mouse.justPressed)
						changeDifficulty(1);
				}

				if (FlxG.mouse.screenX > leftArrow.x
					&& FlxG.mouse.screenX < leftArrow.x + leftArrow.width
					&& FlxG.mouse.screenY > leftArrow.y
					&& FlxG.mouse.screenY < leftArrow.y + leftArrow.height
					&& MusicBeatState.mouseA)
				{
					leftArrow.animation.play('press');
					others = true;
					if (FlxG.mouse.justPressed)
						changeDifficulty(-1);
				}

				if (controls.RIGHT_UI)
					changeDifficulty(1);
				if (controls.LEFT_UI)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT || (!others && FlxG.mouse.justPressed))
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek && started)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			weekUP.kill();
			weekDOWN.kill();
			leftArrow.kill();
			rightArrow.kill();
			sprDifficulty.kill();
			grpLocks.kill();
			scoreText.kill();
			txtWeekTitle.kill();
			txtTracklist.kill();
			chara.kill();
			txtDesc.kill();
			FlxTween.tween(bg, {"scale.x": 0, "scale.y": 0}, 0.2, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween)
				{
					MainMenuState.storied = true;
					LoadingState.loadAndSwitchState(new MainMenuState(), true, 1);
				}
			});
		}

		if (started)
		{
			time += elapsed;
			chara.y = FlxG.height / 2 - 300 + FlxMath.fastSin(time * 1.5) * 5;
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;
	var started:Bool = false;

	function selectWeek()
	{
		if (true)
		{
			weekUP.kill();
			weekDOWN.kill();
			FlxFlicker.flicker(bgs, 0, 0.04, false, false);
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			bgs.alpha = 1;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
		FlxFlicker.flicker(scoreText, 0.4, 0.2 / 5);
		updateText();
	}

	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		started = false;
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;

		if (curWeek == 0)
		{
			weekUP.alpha = 0;
			weekDOWN.alpha = 1;
		}
		else if (curWeek == weekData.length - 1)
		{
			weekUP.alpha = 1;
			weekDOWN.alpha = 0;
		}
		else
		{
			weekUP.alpha = 1;
			weekDOWN.alpha = 1;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		FlxFlicker.flicker(txtWeekTitle, 0.4, 0.2 / 3);
		FlxFlicker.flicker(txtDesc, 0.4, 0.2 / 7);
		FlxFlicker.flicker(scoreText, 0.4, 0.2 / 5);
		FlxFlicker.flicker(txtTracklist, 0.4, 0.2 / 4);
		if (change > 0)
		{
			FlxTween.tween(chara, {y: FlxG.height / 2 - 350, alpha: 0}, 0.2, {
				onComplete: function(twn:FlxTween)
				{
					chara.loadGraphic(Paths.image('characters/' + weekCharacters[curWeek]));
					chara.y = FlxG.height / 2 - 250;
					FlxTween.tween(chara, {y: FlxG.height / 2 - 300, alpha: 1}, 0.2, {
						onComplete: function(twn:FlxTween)
						{
							started = true;
							time = 0;
						}
					});
				}
			});
		}
		else
		{
			FlxTween.tween(chara, {y: FlxG.height / 2 - 250, alpha: 0}, 0.2, {
				onComplete: function(twn:FlxTween)
				{
					chara.loadGraphic(Paths.image('characters/' + weekCharacters[curWeek]));
					chara.y = FlxG.height / 2 - 350;
					FlxTween.tween(chara, {y: FlxG.height / 2 - 300, alpha: 1}, 0.2, {
						onComplete: function(twn:FlxTween)
						{
							started = true;
							time = 0;
						}
					});
				}
			});
		}
		updateText();
		FlxG.sound.music.fadeOut(0.2, 0);
		FlxG.sound.music.fadeIn(0.2, 0, 0.7);
		FlxG.sound.playMusic(Paths.music('cht/' + weekCharacters[curWeek]), 0);
	}

	function updateText(wait:Float = 0.2)
	{
		new FlxTimer().start(wait, function(tmr:FlxTimer)
		{
			if (FlxG.save.data.lang == 1)
				txtTracklist.text = "曲目\n";
			else
				txtTracklist.text = "Tracks\n";

			var stringThing:Array<String> = weekData[curWeek];

			for (i in stringThing)
			{
				txtTracklist.text += "\n" + i;
			}

			txtTracklist.text += "\n";
			txtTracklist.text = txtTracklist.text.toUpperCase();

			txtTracklist.screenCenter(X);
			txtTracklist.x -= 0.03 * FlxG.width;

			#if !switch
			intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
			#end

			if (FlxG.save.data.lang == 1)
			{
				scoreText.text = "週高分\n" + intendedScore + "\n";
				scoreText.screenCenter(X);
				scoreText.x -= 0.03 * FlxG.width;
			}
			else
			{
				scoreText.text = "WEEK SCORE\n" + intendedScore + "\n";
			}

			txtWeekTitle.text = weekNames[curWeek].toUpperCase();
			txtWeekTitle.x = FlxG.width * 0.725 - (txtWeekTitle.width / 2);
			txtDesc.text = intros[curWeek];
		});
	}
}
