package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var welcome:Welcome;

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		stars = new FlxTypedGroup<NoteObject>();

		Highscore.load();

		// FlxG.save.data.weekPassed = null;
		if (FlxG.save.data.weekPassed != null)
		{
			if (StoryMenuState.weekPassed.length > FlxG.save.data.weekPassed.length)
			{
				for (i in 0...StoryMenuState.weekPassed.length)
				{
					if (FlxG.save.data.weekPassed.length <= i)
						FlxG.save.data.weekPassed.push(StoryMenuState.weekPassed[i]);
				}
			}
			StoryMenuState.weekPassed = FlxG.save.data.weekPassed;
		}
		else
		{
			FlxG.save.data.weekPassed = StoryMenuState.weekPassed;
		}

		FlxGameJolt.init(APIStuff.gameID, APIStuff.privateKey, FlxG.save.data.userName != null, FlxG.save.data.userName, FlxG.save.data.userToken,
			function(what:Bool)
			{
				if (what)
					welcome = new Welcome();
			});

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		#if desktop
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
		PlayerSettings.player1.controls.loadKeyBinds();
	}

	var logoBl:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var stars:FlxTypedGroup<NoteObject>;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(140);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		var tz:Float = 1000;
		while (tz > 0)
		{
			for (i in 0...new FlxRandom().int(10, 20))
			{
				var nstar:NoteObject = new NoteObject();
				nstar.makeGraphic(5, 5, 0xFFffffff);
				nstar.wx = new FlxRandom().float(0, 1280);
				nstar.wy = new FlxRandom().float(0, 720);
				nstar.z = tz;
				stars.add(nstar);
			}
			tz -= 51;
		}
		add(stars);

		logoBl = new FlxSprite(150, 0);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.screenCenter();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		add(logoBl);

		titleText = new FlxSprite(150, FlxG.height * 0.8);
		if (FlxG.save.data.lang == 1)
		{
			titleText.frames = Paths.getSparrowAtlas('titleEnterCh');
			titleText.x = 300;
		}
		else
			titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;

		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.56).loadGraphic(Paths.image('Allen'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.6));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		if (welcome != null)
			add(welcome);

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		stars.forEachAlive(function(star:NoteObject)
		{
			star.z -= 1;
			star.x = NoteObject.toScreen(star.wx, star.wy, star.z)[0];
			star.y = NoteObject.toScreen(star.wx, star.wy, star.z)[1];
			if (star.z <= 0)
			{
				star.kill();
			}
		});

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro && !ConfirmSubState.inconfirm)
		{
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Check if version is outdated

				var version:String = "v" + Application.current.meta.get('version');

				FlxG.switchState(new OutdatedSubState());
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);
		danceLeft = !danceLeft;

		FlxG.log.add(curBeat);

		for (i in 0...new FlxRandom().int(10, 20))
		{
			var nstar:NoteObject = new NoteObject();
			nstar.makeGraphic(5, 5, 0xFFffffff);
			nstar.wx = new FlxRandom().float(0, 1280);
			nstar.wy = new FlxRandom().float(0, 720);
			nstar.z = 1000;
			stars.add(nstar);
		}

		switch (curBeat)
		{
			case 1:
				createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
			// credTextShit.visible = true;
			case 8:
				addMoreText('original game');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 14:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 16:
				createCoolText(['Galaxy Engine', 'by']);
			case 24:
				addMoreText('Allen');
				ngSpr.visible = true;
			// credTextShit.text += '\nNewgrounds';
			case 31:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 32:
				deleteCoolText();
				createCoolText(['code']);
			case 34:
				addMoreText('Allen');
			// credTextShit.text += '\nNewgrounds';
			case 36:
				deleteCoolText();
				createCoolText(['music']);
			case 38:
				addMoreText('Allen');
			// credTextShit.text += '\nNewgrounds';
			case 40:
				deleteCoolText();
				createCoolText(['art']);
			case 42:
				addMoreText('neonfovii');
				addMoreText('cana lee');
				addMoreText('A tang');
				addMoreText('magolor');
				addMoreText('sintaro');
			// credTextShit.text += '\nNewgrounds';
			case 44:
				deleteCoolText();
				createCoolText(['story']);
			case 46:
				addMoreText('Allen');
			case 48:
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 52:
				addMoreText(curWacky[1]);
			// credTextShit.screenCenter();
			case 56:
				deleteCoolText();
				createCoolText(['Friday']);
			// credTextShit.visible = true;
			case 58:
				addMoreText('Night');
			// credTextShit.text += '\nNight';
			case 60:
				addMoreText('Funkin'); // credTextShit.text += '\nFunkin';
			case 62:
				addMoreText('in the galaxy');

			case 64:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
