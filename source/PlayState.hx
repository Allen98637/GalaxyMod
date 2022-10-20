package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxStrip;
import flixel.FlxSubState;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import haxe.io.Path;
import lime.app.Future;
import lime.app.Promise;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets as LimeAssets;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.utils.Assets;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var skipStory:Bool = false;
	public static var practice:Bool = false;

	public static var playstate:PlayState;

	public static var sicks:Int = 0;
	public static var goods:Int = 0;
	public static var bads:Int = 0;
	public static var shits:Int = 0;
	public static var misses:Int = 0;
	public static var wrongs:Int = 0;
	public static var maxc:Int = 0;
	public static var keym:Int = 0;
	public static var inp:Int = 0;

	public static var correctChart:Bool = false;

	public static var notetype:String = "null";

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	public var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<NoteStrum>;
	private var playerStrums:FlxTypedGroup<NoteStrum>;

	private var noteAndStrum:FlxTypedGroup<NoteObject>;

	public var camZooming:Bool = false;

	private var curSong:String = "";
	private var songPlaying:Bool = true;

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camDia:FlxCamera;
	public var camAnime:FlxCamera;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;

	private var hits:Float = 0.00;
	private var total:Float = 0;
	private var acc:Float = 0.00;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var whitefg:FlxSprite;
	var shine:Array<Float>;
	var shinetime:Int;
	var blbg:FlxSprite;
	var hexes:FlxTypedGroup<FlxSprite>;
	var kasti1:FlxSprite;
	var kasti2:FlxSprite;
	var sky0:FlxSprite;
	var ground0:FlxSprite;
	var city0:FlxSprite;
	var fg0:FlxSprite;
	var ufo:FlxSprite;
	var ufoy:Float;
	var reme:ResultScreen;
	var anime:FlxSprite;
	var anime2:FlxSprite;
	var screen:Int;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var planets:FlxTypedGroup<FlxSprite>;
	var earth:FlxSprite;
	var strumtext:Array<FlxText> = [];
	var strumtextlist:Array<Array<String>> = [
		["D", "F", "J", "K"],
		[
			"A\n/\nL\nE\nF\nT\n",
			"S\n/\nD\nO\nW\nN\n",
			"W\n/\nU\nP\n",
			"D\n/\nR\nI\nG\nH\nT\n"
		],
		["V", "F", "J", "N"],
		["L\nE\nF\nT\n", "D\nO\nW\nN\n", "J", "K"]
	];
	var missimg:Array<FlxSprite> = [];
	var missnow:Int = 0;
	var tarmiss:Int = 0;

	var talking:Bool = true;
	var songScore:Float = 0;
	var scoreTxt:FlxText;

	var progressBar:FlxSprite;
	var specialoutro:String = "";

	public static var campaignScore:Int = 0;

	public static var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	var misssounds:Array<FlxSoundAsset> = [null, null, null];

	override public function create()
	{
		playstate = this;
		if (SONG.song.toLowerCase() == "senpai" || SONG.song.toLowerCase() == "roses" || SONG.song.toLowerCase() == "thorns")
			daPixelZoom = 6;
		else
			daPixelZoom = 1;

		if (SONG.song.toLowerCase() == "cyber" && storyDifficulty != 0)
		{
			FlxG.fullscreen = false;
			PlayWindow.reset();
		}
		PlayWindow.nreset();
		PlayMoving.reset();

		if (isStoryMode) // in case
			practice = false;

		sicks = 0;
		goods = 0;
		bads = 0;
		shits = 0;
		wrongs = 0;
		misses = 0;
		acc = 0.00;
		hits = 0;
		total = 0;
		maxc = 0;
		keym = 0;
		inp = 0;
		missnow = 0;
		tarmiss = 0;
		screen = 0;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera(0, 0, 1280, 720);
		camHUD.bgColor.alpha = 0;
		camAnime = new FlxCamera();
		camAnime.bgColor.alpha = 0;
		camDia = new FlxCamera();
		camDia.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camAnime);
		FlxG.cameras.add(camDia);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'galaxy':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('galaxy/galaxyDialogueCh'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('galaxy/galaxyDialogue'));
			case 'game':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('game/gameDialogueCh'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('game/gameDialogue'));
			case 'kastimagina':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('kastimagina/kastimaginaDialogueCh'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('kastimagina/kastimaginaDialogue'));
			case 'cona':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('cona/conaDialogue1Ch'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('cona/conaDialogue1'));
			case 'underworld':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('underworld/underworldDialogueCh'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('underworld/underworldDialogue'));
			case 'cyber':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('cyber/cyberDialogueCh'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('cyber/cyberDialogue'));
			case 'familanna':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('familanna/familanna-preCH'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('familanna/familanna-pre'));
			case 'newton':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('newton/newton-preCH'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('newton/newton-pre'));
			case 'destiny':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('destiny/destiny-preCH'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('destiny/destiny-pre'));
			case 'peace':
				if (FlxG.save.data.lang == 1)
					dialogue = CoolUtil.coolTextFile(Paths.txt('peace/peace-preCH'));
				else
					dialogue = CoolUtil.coolTextFile(Paths.txt('peace/peace-pre'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "Hidden";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			if (storyWeek == 1)
				detailsText = "Story Mode: Spaceship";
			else if (storyWeek == 2)
				detailsText = "Story Mode: Corona";
			else if (storyWeek == 3)
				detailsText = "Story Mode: Somewhere";
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		defaultCamZoom = 1.05;
		switch (SONG.song.toLowerCase())
		{
			case 'galaxy' | "game" | "kastimagina" | "familanna":
				{
					var bg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('ship/space'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);
					planets = new FlxTypedGroup<FlxSprite>();
					add(planets);
					for (i in 1...4)
					{
						var light:FlxSprite = new FlxSprite(-600, -360).loadGraphic(Paths.image('ship/star' + i));
						light.scrollFactor.set(0.1, 0.1);
						light.visible = i == 1;
						light.antialiasing = true;
						planets.add(light);
					}
					earth = new FlxSprite(-650, -360);
					if (SONG.song.toLowerCase() == "familanna")
						earth.frames = Paths.getSparrowAtlas('ship/planets');
					else
						earth.frames = Paths.getSparrowAtlas('ship/earth');
					earth.animation.addByPrefix('bump', "earth bump", 24, false);
					earth.antialiasing = true;
					earth.scrollFactor.set(0.2, 0.2);
					earth.updateHitbox();
					add(earth);
					var wall:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('ship/wall'));
					wall.scrollFactor.set(0.9, 0.9);
					add(wall);
					var fg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('ship/front'));
					fg.scrollFactor.set(1, 1);
					add(fg);
				}
			case 'cona' | 'underworld' | 'cyber':
				{
					defaultCamZoom = 0.85;
					if (SONG.song.toLowerCase() == "cyber")
					{
						var sky:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/sky'));
						sky.scrollFactor.set(0.1, 0.1);
						add(sky);
						var city:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/city'));
						city.scrollFactor.set(0.3, 0.3);
						add(city);
						ufo = new FlxSprite(1200, 300).loadGraphic(Paths.image('cor/ufo'));
						ufo.scrollFactor.set(0.5, 0.5);
						ufo.antialiasing = true;
						add(ufo);
						var ground:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/rock'));
						ground.scrollFactor.set(0.9, 0.9);
						add(ground);
						var fg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/ground'));
						fg.scrollFactor.set(1, 1);
						add(fg);
					}
					else
					{
						var sky:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/sky0'));
						sky.scrollFactor.set(0.1, 0.1);
						add(sky);
						sky0 = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/sky'));
						sky0.scrollFactor.set(0.1, 0.1);
						sky0.alpha = 0;
						add(sky0);
						var city:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/city0'));
						city.scrollFactor.set(0.3, 0.3);
						add(city);
						city0 = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/city'));
						city0.scrollFactor.set(0.3, 0.3);
						city0.alpha = 0;
						add(city0);
						ufo = new FlxSprite(1200, 300).loadGraphic(Paths.image('cor/ufo'));
						ufo.scrollFactor.set(0.5, 0.5);
						ufo.antialiasing = true;
						add(ufo);
						var ground:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/rock0'));
						ground.scrollFactor.set(0.9, 0.9);
						add(ground);
						ground0 = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/rock'));
						ground0.scrollFactor.set(0.9, 0.9);
						ground0.alpha = 0;
						add(ground0);
						var fg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/ground0'));
						fg.scrollFactor.set(1, 1);
						add(fg);
						fg0 = new FlxSprite(-600, -300).loadGraphic(Paths.image('cor/ground'));
						fg0.scrollFactor.set(1, 1);
						fg0.alpha = 0;
						add(fg0);
					}
					if (SONG.song.toLowerCase() == "underworld")
					{
						blbg = new FlxSprite(-600, -300).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
						blbg.scrollFactor.set(1, 1);
						blbg.alpha = 0;
						add(blbg);
						hexes = new FlxTypedGroup<FlxSprite>();
						add(hexes);
					}
				}
			case "newton" | "destiny" | "peace":
				{
					defaultCamZoom = 0.7;
					var bg1:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('somewhere/bg1'));
					bg1.scrollFactor.set(0, 0);
					add(bg1);
					var bg2:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('somewhere/bg2'));
					bg2.scrollFactor.set(0.02, 0.02);
					add(bg2);
					var bg3:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('somewhere/bg3'));
					bg3.scrollFactor.set(0.04, 0.04);
					add(bg3);
					var bg4:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('somewhere/bg4'));
					bg4.scrollFactor.set(0.06, 0.06);
					add(bg4);
					var bg5:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('somewhere/bg5'));
					bg5.scrollFactor.set(0.08, 0.08);
					add(bg5);
					var bg6:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('somewhere/bg6'));
					bg6.scrollFactor.set(0.10, 0.10);
					add(bg6);
					var bg7:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('somewhere/bg7'));
					bg7.scrollFactor.set(0.12, 0.12);
					add(bg7);
				}
			default:
				{
					defaultCamZoom = 0.9;
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
				}
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'kastimagina':
				dad.y += 350;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'kalisa':
				dad.x -= 170;
				dad.y += 200;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'mathena':
				camPos.x += 600;
				dad.y += 270;
				dad.scale.x = 0.95;
				dad.scale.y = 0.95;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'unknown':
				dad.x -= 300;
				dad.y += 32;
				gf.x += 300;
				gf.y += 100;
				boyfriend.x += 50;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend.animation.play("singUPmiss");
		boyfriend.animation.play("singDOWNmiss");
		boyfriend.animation.play("singLEFTmiss");
		boyfriend.animation.play("singRIGHTmiss");
		boyfriend.animation.play("idle");

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'cona':
				boyfriend.x += 300;
		}

		add(gf);

		add(dad);
		add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.screenThing = dialoguebg;
		doof.unfinish = cutscene;
		switch (SONG.song.toLowerCase())
		{
			case "kastimagina":
				doof.outro = false;
				doof.finishThing = bossVideo;
			case "peace":
				doof.outro = false;
				doof.finishThing = bossVideo;
		}

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (FlxG.save.data.downscroll)
			strumLine.y = 550;

		strumLineNotes = new FlxTypedGroup<NoteStrum>();

		playerStrums = new FlxTypedGroup<NoteStrum>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * ((60 / openfl.Lib.current.stage.frameRate) * (60 / openfl.Lib.current.stage.frameRate)));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		progressBar = new FlxSprite(0, 0).makeGraphic(1280, 5, 0xCCffffff);
		progressBar.scale.x = 0;
		progressBar.updateHitbox();
		add(progressBar);

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);
		if (FlxG.save.data.downscroll)
			healthBarBG.y = FlxG.height * 0.1;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		scoreTxt.scrollFactor.set();
		scoreTxt.color = 0xFFffffff;
		scoreTxt.borderStyle = OUTLINE;
		scoreTxt.borderColor = 0xFF000000;
		add(scoreTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		noteAndStrum.cameras = [camHUD];
		progressBar.cameras = [camAnime];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camDia];
		if (SONG.song.toLowerCase() == "familanna")
		{
			for (i in 0...4)
			{
				strumtext.push(new FlxText(730 + 112 * i, 170, 0, strumtextlist[0][i], 26));
				strumtext[i].font = 'Pixel Arial 11 Bold';
				strumtext[i].color = 0xFFffffff;
				strumtext[i].cameras = [camHUD];
				strumtext[i].alpha = 0;
				strumtext[i].borderStyle = OUTLINE;
				strumtext[i].borderColor = 0xFF000000;
				strumtext[i].borderSize = 1;
				add(strumtext[i]);
			}
			missimg.push(new FlxSprite(515, 225).loadGraphic(Paths.image('misses')));
			missimg.push(new FlxSprite(665, 370).loadGraphic(Paths.image('num0')));
			missimg.push(new FlxSprite(522, 279).loadGraphic(Paths.image('num0')));
			for (i in 0...3)
			{
				missimg[i].alpha = 0;
				missimg[i].cameras = [camHUD];
				missimg[i].antialiasing = true;
				add(missimg[i]);
			}
			whitefg = new FlxSprite(0, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFffffff);
			whitefg.scrollFactor.set();
			whitefg.alpha = 0;
			add(whitefg);
			whitefg.cameras = [camDia];
			shine = [
				31475.409836065555,
				73442.62295081967,
				83934.42622950824,
				199344.26229508256,
				204590.16393442685,
				209836.06557377113,
				220327.8688524597
			];
			shinetime = 0;
		}
		if (SONG.song.toLowerCase() == "kastimagina" && storyDifficulty != 0)
		{
			whitefg = new FlxSprite(0, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFffffff);
			whitefg.scrollFactor.set();
			whitefg.alpha = 0;
			add(whitefg);
			whitefg.cameras = [camDia];
			shine = [
				2651.9337016574586,  2983.425414364641, 3314.9171270718234, 3646.4088397790056, 3977.9005524861877,   4309.39226519337,  4640.883977900552,
				 4972.375690607734,  5303.867403314917,  5635.359116022099,  5966.850828729282,  6298.342541436465,  6629.834254143647,  6961.325966850829,
				 7292.817679558011,  7624.309392265193,  7955.801104972376,   8287.29281767956,  8618.784530386742,  8950.276243093924,  9281.767955801106,
				 9613.259668508288,   9944.75138121547, 10276.243093922652, 10607.734806629835, 10939.226519337017, 11270.718232044199, 11602.209944751381,
				11933.701657458563, 12265.193370165745, 12596.685082872928,  12928.17679558011, 13259.668508287292, 23867.403314917123,  45082.87292817678,
				 46408.83977900551,  47734.80662983424,  49060.77348066297,  49723.75690607733, 50386.740331491696, 51712.707182320424,  53038.67403314915,
				 54364.64088397788, 55027.624309392246,  55690.60773480661,  57016.57458563534,  58342.54143646407, 59668.508287292796,  60331.49171270716,
				 60662.98342541434, 60994.475138121525,  62320.44198895025,  63646.40883977898,  64972.37569060771,  65635.35911602208,  65966.85082872926,
				 66298.34254143645,  82209.94475138119, 103425.41436464085,  124640.8839779005, 135248.61878453035, 136574.58563535908,  137900.5524861878,
				139226.51933701654,  139889.5027624309, 140552.48618784526,   141878.453038674, 143204.41988950272, 144530.38674033145, 145193.37016574582,
				145856.35359116018,  147182.3204419889, 148508.28729281764, 149834.25414364637, 150497.23756906073,  151160.2209944751, 152486.18784530382,
				153812.15469613255, 155138.12154696128, 155801.10497237564,    156464.08839779,  156795.5801104972, 157127.07182320437, 157458.56353591155,
				157790.05524861874, 158121.54696132592,  158453.0386740331, 158784.53038674028, 159116.02209944747, 159447.51381215465, 159779.00552486183,
				  160110.497237569,  160441.9889502762, 160773.48066298338, 161104.97237569056, 161436.46408839774, 161767.95580110492,  162099.4475138121,
				 162430.9392265193, 162762.43093922647, 163093.92265193365, 163425.41436464083, 163756.90607734802,  164088.3977900552, 164419.88950276238,
				164751.38121546956, 165082.87292817674, 165414.36464088393,  165745.8563535911,  166077.3480662983, 166408.83977900547, 166740.33149171266
			];
			shinetime = 0;
		}
		if (SONG.song.toLowerCase() == "cyber" && storyDifficulty != 0)
		{
			if (storyDifficulty == 1)
				kasti1 = new FlxSprite(-240, 400).loadGraphic(Paths.image('cor/war'));
			else
				kasti1 = new FlxSprite(-240, 400).loadGraphic(Paths.image('cor/war1'));
			kasti1.scrollFactor.set();
			kasti1.antialiasing = true;
			add(kasti1);
			kasti1.cameras = [camHUD];
			if (storyDifficulty == 1)
				kasti2 = new FlxSprite(-240, 400).loadGraphic(Paths.image('cor/war0'));
			else
				kasti2 = new FlxSprite(-240, 400).loadGraphic(Paths.image('cor/war2'));
			kasti2.scrollFactor.set();
			kasti2.antialiasing = true;
			add(kasti2);
			kasti2.cameras = [camHUD];
		}

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			if (skipStory)
			{
				startCountdown();
			}
			else
			{
				switch (curSong.toLowerCase())
				{
					case "winter-horrorland":
						var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
						add(blackScreen);
						blackScreen.scrollFactor.set();
						camHUD.visible = false;

						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							remove(blackScreen);
							FlxG.sound.play(Paths.sound('Lights_Turn_On'));
							camFollow.y = -2050;
							camFollow.x += 200;
							FlxG.camera.focusOn(camFollow.getPosition());
							FlxG.camera.zoom = 1.5;

							new FlxTimer().start(0.8, function(tmr:FlxTimer)
							{
								camHUD.visible = true;
								remove(blackScreen);
								FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
									ease: FlxEase.quadInOut,
									onComplete: function(twn:FlxTween)
									{
										startCountdown();
									}
								});
							});
						});
					case 'galaxy':
						schoolIntro(doof);
					case 'game':
						schoolIntro(doof);
					case 'kastimagina':
						schoolIntro(doof);
					case 'cona':
						schoolIntro(doof);
					case 'underworld':
						schoolIntro(doof);
					case 'cyber':
						schoolIntro(doof);
					case 'newton':
						schoolIntro(doof);
					case 'destiny':
						schoolIntro(doof);
					case 'peace':
						schoolIntro(doof);
					default:
						startCountdown();
				}
				skipStory = true;
			}
		}
		else
		{
			if (skipStory)
			{
				startCountdown();
			}
			else
			{
				switch (curSong.toLowerCase())
				{
					case 'familanna':
						schoolIntro(doof);
					default:
						startCountdown();
				}
				skipStory = true;
			}
		}

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox, numbbb:Int = 0):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == "galaxy"
			|| SONG.song.toLowerCase() == "game"
			|| SONG.song.toLowerCase() == "kastimagina"
			|| SONG.song.toLowerCase() == "cona"
			|| SONG.song.toLowerCase() == "underworld"
			|| SONG.song.toLowerCase() == "cyber"
			|| SONG.song.toLowerCase() == "familanna"
			|| SONG.song.toLowerCase() == "newton"
			|| SONG.song.toLowerCase() == "destiny"
			|| SONG.song.toLowerCase() == "peace")
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		switch (SONG.song.toLowerCase())
		{
			case "cona":
				if (numbbb == 0)
				{
					anime = new FlxSprite(0, 0).loadGraphic(Paths.image('cor/anime'));
					anime.antialiasing = true;
					anime.cameras = [camAnime];
					add(anime);
				}
			case "cyber":
				anime = new FlxSprite(0, 0).loadGraphic(Paths.image('cor/goodpic'));
				anime.antialiasing = true;
				anime.cameras = [camAnime];
				add(anime);
			case "familanna":
				if (numbbb == 0)
				{
					anime = new FlxSprite(0, 0).loadGraphic(Paths.image('ship/fami0'));
					anime.antialiasing = true;
					anime.cameras = [camAnime];
					add(anime);
				}
				else
				{
					anime = new FlxSprite(0, 0).loadGraphic(Paths.image('ship/fami2'));
					anime.antialiasing = true;
					anime.cameras = [camAnime];
					add(anime);
					screen = 2;
				}
			case "newton":
				anime = new FlxSprite(0, 0).loadGraphic(Paths.image('somewhere/newton0'));
				anime.antialiasing = true;
				anime.cameras = [camAnime];
				add(anime);
			case "destiny":
				anime = new FlxSprite(0, 0).loadGraphic(Paths.image('somewhere/destiny0'));
				anime.antialiasing = true;
				anime.cameras = [camAnime];
				add(anime);
			case "peace":
				if (numbbb == 0)
				{
					anime = new FlxSprite(0, 0).loadGraphic(Paths.image('somewhere/peace0'));
					anime.antialiasing = true;
					anime.cameras = [camAnime];
					add(anime);
				}
				else if (numbbb == 1)
				{
					anime = new FlxSprite(0, 0).loadGraphic(Paths.image('somewhere/peace1'));
					anime.antialiasing = true;
					anime.cameras = [camAnime];
					add(anime);
					screen = 1;
				}
				else
				{
					anime = new FlxSprite(0, 0).loadGraphic(Paths.image('somewhere/peace7'));
					anime.antialiasing = true;
					anime.cameras = [camAnime];
					add(anime);
					screen = 7;
				}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function dialoguebg():Void
	{
		switch (SONG.song.toLowerCase())
		{
			case "familanna":
				screen += 1;
				anime.loadGraphic(Paths.image('ship/fami' + screen));
			case "newton":
				screen += 1;
				anime.loadGraphic(Paths.image('somewhere/newton' + screen));
			case "destiny":
				screen += 1;
				anime.loadGraphic(Paths.image('somewhere/destiny' + screen));
			case "peace":
				screen += 1;
				anime.loadGraphic(Paths.image('somewhere/peace' + screen));
		}
	}

	function bossVideo():Void
	{
		var video:BossVideo = new BossVideo();
		video.finishCallback = startCountdown;
		video.canSkip = StoryMenuState.weekPassed[Std.int(Math.min(storyWeek, StoryMenuState.weekPassed.length - 1))][storyDifficulty];
		video.playVideo(Paths.video(SONG.song.toLowerCase() + "/" + storyDifficulty));
		FlxG.sound.playMusic(Paths.music(SONG.song.toLowerCase()), 1, false);
	}

	function cutscene():Void
	{
		switch (SONG.song.toLowerCase())
		{
			case "cona":
				remove(anime);
				var sddd:Array<String>;
				if (FlxG.save.data.lang == 1)
					sddd = CoolUtil.coolTextFile(Paths.txt('cona/conaDialogue2Ch'));
				else
					sddd = CoolUtil.coolTextFile(Paths.txt('cona/conaDialogue2'));
				var sth:DialogueBox = new DialogueBox(false, sddd, 1);
				sth.scrollFactor.set();
				sth.finishThing = startCountdown;
				sth.cameras = [camDia];
				schoolIntro(sth, 1);
			case "cyber":
				remove(anime);
				startCountdown();
		}
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		switch (SONG.song.toLowerCase())
		{
			case "familanna":
				remove(anime);
			case "newton":
				remove(anime);
			case "destiny":
				remove(anime);
			case "peace":
				remove(anime);
		}
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (swagCounter % 2 == 0)
			{
				boyfriend.playAnim('idle', true);
			}
			dad.dance(swagCounter % 2 == 0);
			gf.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)
			{
				case 0:
					if (PlayState.SONG.song.toLowerCase() == 'senpai'
						|| PlayState.SONG.song.toLowerCase() == 'roses'
						|| PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('intro3-pixel'), 0.6);
					else
						FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					if (PlayState.SONG.song.toLowerCase() == 'senpai'
						|| PlayState.SONG.song.toLowerCase() == 'roses'
						|| PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('intro2-pixel'), 0.6);
					else
						FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					if (PlayState.SONG.song.toLowerCase() == 'senpai'
						|| PlayState.SONG.song.toLowerCase() == 'roses'
						|| PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('intro1-pixel'), 0.6);
					else
						FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					if (PlayState.SONG.song.toLowerCase() == 'senpai'
						|| PlayState.SONG.song.toLowerCase() == 'roses'
						|| PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('introGo-pixel'), 0.6);
					else
						FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		if (practice)
			FlxG.sound.music.onComplete = endSong;
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'familanna':
					FlxG.sound.music.onComplete = outro;
				case 'peace':
					if (isStoryMode)
						FlxG.sound.music.onComplete = outro;
					else
						FlxG.sound.music.onComplete = endSong;
				default:
					FlxG.sound.music.onComplete = endSong;
			}
		}
		vocals.play();

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();

		noteAndStrum = new FlxTypedGroup<NoteObject>();
		add(noteAndStrum);

		var noteData:Array<SwagSection>;
		var randoms:Array<Int> = [];
		var randtime:Int = 0;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		var psynclist:Array<Float> = [];
		var synclist:Array<Float> = [];
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var order = 0;

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(Math.floor(songNotes[1]) % 4);
				var noteSpec:Int = Std.int(Math.round((songNotes[1] * 100) % 100));

				var hasEnd:Bool = false;

				var gottaHitNote:Bool = section.mustHitSection;

				if ((Math.floor(songNotes[1]) > 3 && Math.floor(songNotes[1]) < 10)
					|| (Math.floor(songNotes[1]) >= 10 && Math.floor(songNotes[1]) % 10 > 3))
				{
					gottaHitNote = !section.mustHitSection;
				}

				switch Std.int(Math.floor(songNotes[1]) / 10)
				{
					case 1:
						daNoteData = FlxG.random.int(0, 3);
						randoms.push(daNoteData);
					case 2:
						daNoteData = randoms[randtime];
						randtime += 1;
					case 3:
						daNoteData = FlxG.random.int(0, 3);
					case 4:
						daNoteData = Std.int((Math.floor(songNotes[1]) - 40) % 4);
						hasEnd = true;
				}

				var oldNote:Note;
				var sync:Bool = false;
				for (i in 0...section.sectionNotes.length)
				{
					if (i != order && daStrumTime == section.sectionNotes[i][0])
					{
						if (songNotes[1] % 10 < 4 && section.sectionNotes[i][1] % 10 < 4)
							sync = true;
						if (songNotes[1] % 10 > 3 && section.sectionNotes[i][1] % 10 > 3)
							sync = true;
					}
				}
				var masync:Array<Float> = gottaHitNote ? psynclist : synclist;
				for (i in masync)
				{
					if (Math.abs(i - daStrumTime) < 5)
					{
						sync = true;
						break;
					}
				}
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, sync);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);
				swagNote.spec = noteSpec;

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.round(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, false, true);
					sustainNote.scrollFactor.set();
					sustainNote.spec = noteSpec;
					sustainNote.sustainLength = susLength;
					sustainNote.sustainOrder = susNote;
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;
					PlayMoving.clone(sustainNote);

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}
				if (hasEnd)
				{
					var synced:Bool = false;
					var endTime:Float = daStrumTime + swagNote.sustainLength;
					for (ssection in noteData)
					{
						for (ssongNotes in ssection.sectionNotes)
						{
							var hittt:Bool = ssection.mustHitSection == gottaHitNote;
							if ((ssongNotes[1] % 10 < 4 && hittt) || (ssongNotes[1] % 10 > 3 && !hittt))
							{
								if (Math.abs(endTime - ssongNotes[0]) < 5)
								{
									synced = true;
									masync.push(endTime);
								}
								if (ssongNotes[1] > 39
									&& ssongNotes[1] < 50
									&& Math.abs(endTime - ssongNotes[0] - ssongNotes[2]) < 5
									&& ssongNotes != songNotes)
								{
									synced = true;
								}
							}
						}
					}
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					var endNote:Note = new Note(endTime, daNoteData, oldNote, synced, false, true);
					endNote.sustainLength = susLength;
					endNote.scrollFactor.set();
					endNote.spec = noteSpec;
					unspawnNotes.push(endNote);

					endNote.mustPress = gottaHitNote;
					PlayMoving.clone(endNote);

					if (endNote.mustPress)
					{
						endNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;
				PlayMoving.clone(swagNote);

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
				order += 1;
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	inline function sortNoteByShit(Order:Int, Obj1:NoteObject, Obj2:NoteObject):Int
	{
		if (FlxSort.byValues(Order, Obj1.z, Obj2.z) != 0)
			return FlxSort.byValues(Order, Obj1.z, Obj2.z);
		if (Obj1.isEnd && !Obj2.isEnd)
		{
			return Order;
		}
		if (!Obj1.isEnd && Obj2.isEnd)
		{
			return -Order;
		}
		return FlxSort.byValues(Order, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int, type:String = "null", twe:Bool = true):Void
	{
		notetype = type;
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:NoteStrum = new NoteStrum(0, strumLine.y, player, i, type);

			if (!isStoryMode && twe)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
			noteAndStrum.add(babyArrow);
		}
	}

	public function generateStaticArrow(player:Int, strumID:Int, type:String = "null", spec = 0):NoteStrum
	{
		notetype = type;
		var babyArrow:NoteStrum = new NoteStrum(0, strumLine.y, player, strumID, type, spec);

		if (player == 1)
		{
			playerStrums.add(babyArrow);
		}

		babyArrow.animation.play('static');
		babyArrow.x += 50;
		babyArrow.x += ((FlxG.width / 2) * player);

		strumLineNotes.add(babyArrow);
		noteAndStrum.add(babyArrow);
		return babyArrow;
	}

	public function addObject(obj:NoteObject)
	{
		noteAndStrum.add(obj);
	}

	public function destroyObject(obj:NoteObject)
	{
		obj.kill();
		noteAndStrum.remove(obj, true);
		obj.destroy();
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	/*override public function onFocus():Void
		{
			#if desktop
			if (health > 0 && !paused && songPlaying)
			{
				if (Conductor.songPosition > 0.0)
				{
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
				}
				else
				{
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
				}
			}
			#end

			super.onFocus();
	}*/
	override public function onFocusLost():Void
	{
		if (songPlaying && health > 0 && !paused && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			if (SONG.song.toLowerCase() == "cyber" && storyDifficulty != 0)
				PlayWindow.back(camHUD);

			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}
		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if (FlxG.sound.music.time > Conductor.songPosition + 100)
		{
			vocals.pause();
			FlxG.sound.music.pause();

			FlxG.sound.music.time = Conductor.songPosition;
			vocals.time = Conductor.songPosition;

			FlxG.sound.music.play();
			vocals.play();
		}
		else
		{
			vocals.pause();

			FlxG.sound.music.play();
			Conductor.songPosition = FlxG.sound.music.time;
			vocals.time = Conductor.songPosition;
			vocals.play();
		}
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (specialoutro)
		{
			case "peace0":
				anime2 = new FlxSprite(0, 0).loadGraphic(Paths.image('ninkmi'));
				anime2.antialiasing = true;
				anime2.cameras = [camDia];
				anime2.alpha = 0;
				add(anime2);
				specialoutro = "peace1";
			case "peace1":
				anime2.alpha += 0.05;
				if (FlxG.mouse.justPressed)
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://allen98637.github.io/games/ninkmi", "&"]);
					#else
					FlxG.openURL("https://allen98637.github.io/games/ninkmi");
					#end
				}
				if (anime2.alpha >= 1)
				{
					anime2.alpha = 1;
					specialoutro = "peace2";
				}
			case "peace2":
				if (FlxG.mouse.justPressed)
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://allen98637.github.io/games/ninkmi", "&"]);
					#else
					FlxG.openURL("https://allen98637.github.io/games/ninkmi");
					#end
				}
				if (controls.ACCEPT)
					realEnd();
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case "cona":
				updateUFO();
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}
		if (songPlaying)
		{
			switch (SONG.song.toLowerCase())
			{
				case "kastimagina":
					if (storyDifficulty != 0)
					{
						if (shinetime < shine.length && Conductor.songPosition >= shine[shinetime])
						{
							whitefg.alpha = 1;
							shinetime += 1;
						}
						updatewhite();
					}
				case "underworld":
					sky0.alpha = Conductor.songPosition / 157784.81012658245;
					city0.alpha = Conductor.songPosition / 157784.81012658245;
					ground0.alpha = Conductor.songPosition / 157784.81012658245;
					fg0.alpha = Conductor.songPosition / 157784.81012658245;
					hexes.forEachAlive(function(dahex:FlxSprite)
					{
						dahex.y -= 5;
						dahex.angle += 2;
						if (blbg.alpha == 1)
							dahex.alpha = 1;
						else
							dahex.alpha = 0;
						if (dahex.y < -300)
						{
							dahex.kill();
							hexes.remove(dahex, true);
							dahex.destroy();
						}
					});
				case "cyber":
					if (storyDifficulty != 0)
					{
						if (Conductor.songPosition > 60000)
							kasti1.alpha = 0;
						else if (Conductor.songPosition >= 56629.213483146064 && kasti1.x < 10)
							kasti1.x += 5;
						if (Conductor.songPosition > 136179.7752808992)
							kasti2.alpha = 0;
						else if (Conductor.songPosition >= 132134.8314606745 && kasti2.x < 10)
							kasti2.x += 5;
					}
				case "familanna":
					updatestrumtext();
					if (shinetime < shine.length && Conductor.songPosition >= shine[shinetime])
					{
						whitefg.alpha = 1;
						shinetime += 1;
					}
					updatewhite();
			}

			switch (SONG.player2)
			{
				case 'unknown':
					dad.y = 132 + 10 * FlxMath.fastSin(Conductor.songPosition / 1000 * Math.PI);
					boyfriend.y = 150 + 20 * FlxMath.fastSin(Conductor.songPosition / 2000 * Math.PI);
					gf.y = -170 + 15 * FlxMath.fastSin(Conductor.songPosition / 1500 * Math.PI);
			}

			if (practice)
				scoreTxt.color = 0xFF00a9e0;
			else if (acc == 100 || maxc == 0)
				scoreTxt.color = 0xFFff00ee;
			else if (misses == 0 && bads == 0 && shits == 0 && wrongs == 0)
				scoreTxt.color = 0xFFffff00;
			else
				scoreTxt.color = 0xFFffffff;
			scoreTxt.text = "Score:" + Math.round(songScore);

			if (practice && health > 1)
				health = 1;

			if (controls.PAUSE && startedCountdown && canPause)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// 1 / 1000 chance for Gitaroo Man easter egg
				if (FlxG.random.bool(0.1))
				{
					// gitaroo man easter egg
					FlxG.switchState(new GitarooPause());
				}
				else
					openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				if (SONG.song.toLowerCase() == "cyber" && storyDifficulty != 0)
					PlayWindow.back(camHUD);

				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
				#end
			}

			#if debug
			if (FlxG.keys.justPressed.SEVEN)
			{
				FlxG.switchState(new ChartingState());

				#if desktop
				DiscordClient.changePresence("Chart Editor", null, null, true);
				#end
			}
			#end

			// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
			// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

			if (!FlxG.save.data.progressbar)
			{
				progressBar.scale.x = Conductor.songPosition / FlxG.sound.music.length;
				if (Conductor.songPosition < 0)
					progressBar.scale.x = 0;
				progressBar.updateHitbox();
			}

			iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
			iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

			iconP1.updateHitbox();
			iconP2.updateHitbox();

			var iconOffset:Int = 26;

			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

			if (health > 2)
				health = 2;

			if (healthBar.percent < 20)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;

			if (healthBar.percent > 80)
				iconP2.animation.curAnim.curFrame = 1;
			else
				iconP2.animation.curAnim.curFrame = 0;

			/* if (FlxG.keys.justPressed.NINE)
				FlxG.switchState(new Charting()); */

			#if debug
			if (FlxG.keys.justPressed.EIGHT)
				FlxG.switchState(new AnimationDebug(SONG.player2));
			#end

			if (startingSong)
			{
				if (startedCountdown)
				{
					Conductor.songPosition += FlxG.elapsed * 1000;
					if (Conductor.songPosition >= 0)
						startSong();
				}
			}
			else
			{
				Conductor.songPosition += FlxG.elapsed * 1000;

				if (!paused)
				{
					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;

					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
						// Conductor.songPosition += FlxG.elapsed * 1000;
						// trace('MISSED FRAME');
					}
				}

				// Conductor.lastSongPos = FlxG.sound.music.time;
			}

			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
				}

				if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

					switch (dad.curCharacter)
					{
						case 'mom':
							camFollow.y = dad.getMidpoint().y;
						case 'senpai':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
						case 'senpai-angry':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
					}

					if (dad.curCharacter == 'mom')
						vocals.volume = 1;

					if (SONG.song.toLowerCase() == 'tutorial')
					{
						tweenCamIn();
					}
				}

				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
				{
					camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

					switch (curStage)
					{
						case 'limo':
							camFollow.x = boyfriend.getMidpoint().x - 300;
						case 'mall':
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'school':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'schoolEvil':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 200;
					}

					if (SONG.song.toLowerCase() == 'tutorial')
					{
						FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
					}
				}
			}

			if (camZooming)
			{
				FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
				camHUD.zoom = FlxMath.lerp(PlayWindow.camz, camHUD.zoom, 0.95);
			}

			FlxG.watch.addQuick("beatShit", curBeat);
			FlxG.watch.addQuick("stepShit", curStep);

			if (curSong == 'Fresh')
			{
				switch (curBeat)
				{
					case 16:
						camZooming = true;
						gfSpeed = 2;
					case 48:
						gfSpeed = 1;
					case 80:
						gfSpeed = 2;
					case 112:
						gfSpeed = 1;
					case 163:
						// FlxG.sound.music.stop();
						// FlxG.switchState(new TitleState());
				}
			}

			if (curSong == 'Bopeebo')
			{
				switch (curBeat)
				{
					case 128, 129, 130:
						vocals.volume = 0;
						// FlxG.sound.music.stop();
						// FlxG.switchState(new PlayState());
				}
			}
			// better streaming of shit

			// CHEAT = brandon's a pussy
			if (controls.CHEAT)
			{
				health += 1;
				trace("User is cheating!");
			}

			if (health <= 0)
			{
				if (SONG.song.toLowerCase() == "peace" && Conductor.songPosition >= 172800)
					health = 0.00001;
				else
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;

					vocals.stop();
					FlxG.sound.music.stop();

					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

					if (SONG.song.toLowerCase() == "cyber" && storyDifficulty != 0)
						PlayWindow.back(camHUD);

					#if desktop // Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
					#end
				}
			}

			if (unspawnNotes[0] != null)
			{
				if (unspawnNotes[0].strumTime - Conductor.songPosition < 5000)
				{
					var dunceNote:Note = unspawnNotes[0];
					notes.add(dunceNote);
					noteAndStrum.add(dunceNote);

					var index:Int = unspawnNotes.indexOf(dunceNote);
					unspawnNotes.splice(index, 1);
				}
			}

			if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (PlayMoving.show(daNote))
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}

					PlayMoving.pos(daNote, strumLine);

					PlayMoving.shape(daNote, strumLine, camHUD);

					if ((!daNote.mustPress || daNote.isLastSustain) && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";

						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

						if (!daNote.mustPress)
						{
							switch (Math.abs(daNote.noteData))
							{
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
								case 2:
									dad.playAnim('singUP' + altAnim, true);
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
							}

							dad.holdTimer = 0;
						}

						if (SONG.needsVoices)
							vocals.volume = 1;

						PlayMoving.ongood(daNote);
						daNote.kill();
						notes.remove(daNote, true);
						noteAndStrum.remove(daNote, true);
						daNote.destroy();
					}

					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

					if (daNote.tooLate && !daNote.played && daNote.mustPress && !daNote.isLastSustain)
					{
						if (!practice)
						{
							if (inp == 1)
								health -= 0.0475; // 0.0475
							else
								health -= 0.065;
						}
						misses += 1;
						missnow += 1;
						total += 1;
						acc = hits / total * 100;
						acc = Math.round(acc * 100) / 100;
						if (!practice)
							vocals.volume = 0;
						daNote.played = true;

						missanim(daNote.noteData);
					}

					if (PlayMoving.kill(daNote))
					{
						if (!daNote.played && daNote.mustPress && !daNote.isLastSustain)
						{
							if (!practice)
							{
								if (inp == 1)
									health -= 0.0475; // 0.0475
								else
									health -= 0.065;
							}
							misses += 1;
							missnow += 1;
							total += 1;
							acc = hits / total * 100;
							acc = Math.round(acc * 100) / 100;
							if (!practice)
								vocals.volume = 0;
							daNote.played = true;
							missanim(daNote.noteData);
						}
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						noteAndStrum.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
			if (!inCutscene)
				keyShit();
			var mustkill:Array<NoteStrum> = [];
			strumLineNotes.forEachAlive(function(dastrum:NoteStrum)
			{
				PlayMoving.spos(dastrum, strumLine);
				if (dastrum.mustBeKilled)
					mustkill.push(dastrum);
			});
			playerStrums.forEachAlive(function(dastrum:NoteStrum)
			{
				PlayMoving.pspos(dastrum, strumLine);
			});
			for (dastrum in mustkill)
			{
				if (dastrum.player == 1)
					playerStrums.remove(dastrum);
				strumLineNotes.remove(dastrum);
				dastrum.kill();
				noteAndStrum.remove(dastrum, true);
				dastrum.destroy();
			}
			PlayWindow.move(camHUD);
			PlayMoving.special(this);
			noteAndStrum.sort(sortNoteByShit, FlxSort.DESCENDING);
		}

		super.update(elapsed);

		#if debug
		if (FlxG.keys.justPressed.ONE)
		{
			FlxG.sound.music.onComplete();
		}
		#end
	}

	public function changeHealth(by:Float):Float
	{
		health += by;
		return health;
	}

	function outro2():Void
	{
		reme.kill();
		var sddd:Array<String> = ["error"];
		var num:Int = 2;
		var numbbb:Int = 2;
		switch (SONG.song.toLowerCase())
		{
			case 'peace':
				if (FlxG.save.data.lang == 1)
					sddd = CoolUtil.coolTextFile(Paths.txt('peace/peace-post2CH'));
				else
					sddd = CoolUtil.coolTextFile(Paths.txt('peace/peace-post2'));
		}
		var sth:DialogueBox = new DialogueBox(false, sddd, num, 1);
		sth.scrollFactor.set();
		sth.finishThing = realEnd;
		if (SONG.song.toLowerCase() == "peace")
			sth.finishThing = function()
			{
				specialoutro = SONG.song.toLowerCase() + "0";
			};
		sth.screenThing = dialoguebg;
		sth.cameras = [camDia];
		schoolIntro(sth, numbbb);
	}

	function outro():Void
	{
		canPause = false;
		vocals.volume = 0;
		camZooming = false;
		camHUD.zoom = 1;
		var sddd:Array<String> = ["error"];
		var num:Int = 1;
		var numbbb:Int = 1;
		switch (SONG.song.toLowerCase())
		{
			case 'familanna':
				if (FlxG.save.data.lang == 1)
					sddd = CoolUtil.coolTextFile(Paths.txt('familanna/familanna-postCH'));
				else
					sddd = CoolUtil.coolTextFile(Paths.txt('familanna/familanna-post'));
			case 'peace':
				if (FlxG.save.data.lang == 1)
					sddd = CoolUtil.coolTextFile(Paths.txt('peace/peace-postCH'));
				else
					sddd = CoolUtil.coolTextFile(Paths.txt('peace/peace-post'));
		}
		var sth:DialogueBox = new DialogueBox(false, sddd, num, 1);
		sth.scrollFactor.set();
		sth.finishThing = endSong;
		sth.screenThing = dialoguebg;
		sth.cameras = [camDia];
		schoolIntro(sth, numbbb);
	}

	function realEnd():Void
	{
		practice = false;
		skipStory = false;
		if (isStoryMode)
		{
			if (storyPlaylist.length <= 0)
			{
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				LoadingState.loadAndSwitchState(new StoryMenuState(), true);

				// if ()
				StoryMenuState.weekPassed[Std.int(Math.min(storyWeek, StoryMenuState.weekPassed.length - 1))][storyDifficulty] = true;
				Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

				FlxG.save.data.weekPassed = StoryMenuState.weekPassed;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';
				if (storyDifficulty == 3)
					difficulty = '-true';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				LoadingState.loadAndSwitchState(new PlayState(), true);
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.sound.music.stop();
			LoadingState.loadAndSwitchState(new FreeplayState(), true);
		}
	}

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		camZooming = false;
		camHUD.zoom = 1;
		songPlaying = false;
		if (misses == 0 && bads == 0 && shits == 0 && wrongs == 0)
			maxc *= -1;
		var oldBest:Int = Highscore.getScore(SONG.song, storyDifficulty);
		if (SONG.song.toLowerCase() == "cyber" && storyDifficulty != 0)
			PlayWindow.back(camHUD);

		if (isStoryMode)
		{
			campaignScore += Math.round(songScore);
			storyPlaylist.remove(storyPlaylist[0]);
		}
		#if desktop
		DiscordClient.changePresence("Result - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end
		getTrophies();
		reme = new ResultScreen(dad.curCharacter, Math.round(songScore), oldBest, maxc, acc, sicks, goods, bads, shits, misses, wrongs);
		reme.scrollFactor.set();
		reme.cameras = [camDia];
		reme.end = realEnd;

		if (SONG.song.toLowerCase() == "peace")
			reme.end = outro2;

		add(reme);
		#if PRELOAD_ALL
		sys.thread.Thread.create(() ->
		{
			reme.load();
			if (!practice && SONG.validScore)
			{
				Highscore.saveScore(SONG.song, Math.round(songScore), acc, maxc, storyDifficulty, reme);
			}
		});
		#else
		if (!practice && SONG.validScore)
		{
			Highscore.saveScore(SONG.song, Math.round(songScore), acc, maxc, storyDifficulty, reme);
		}
		reme.load();
		#end
	}

	var endingSong:Bool = false;

	private function getTrophies()
	{
		if (practice)
			return;

		if (FlxG.save.data.trophies == null)
			FlxG.save.data.trophies = [];

		if (isStoryMode)
		{
			if (storyPlaylist.length <= 0 && storyDifficulty == 2)
			{
				if (storyWeek != 0)
				{
					if (!FlxG.save.data.trophies.contains(APIStuff.comWeek[storyWeek]))
						FlxG.save.data.trophies.push(APIStuff.comWeek[storyWeek]);
				}
			}
		}
		if (misses == 0 && bads == 0 && shits == 0 && wrongs == 0 && APIStuff.fcs.exists(SONG.song) && storyDifficulty == 2)
		{
			if (!FlxG.save.data.trophies.contains(APIStuff.fcs.get(SONG.song)))
				FlxG.save.data.trophies.push(APIStuff.fcs.get(SONG.song));
		}
		if (APIStuff.comSong.exists(SONG.song + "-" + storyDifficulty))
		{
			if (!FlxG.save.data.trophies.contains(APIStuff.comSong.get(SONG.song + "-" + storyDifficulty)))
				FlxG.save.data.trophies.push(APIStuff.comSong.get(SONG.song + "-" + storyDifficulty));
		}

		trace(FlxG.save.data.trophies);
		return;
	}

	private function justCombo():Void
	{
		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = (FlxG.width * 0.55) + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
	}

	private function popUpScore(strumtime:Float, notedata:Int, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Float = 350;
		var heal:Float = 0.023;

		var daRating:String = "sick";

		var inc:Float = 1.0;

		if (noteDiff > 150)
		{
			daRating = 'shit';
			score = 50;
			inc = 0.1;
			missanim(notedata);
			heal = -0.04;
			shits += 1;
		}
		else if (noteDiff > 100)
		{
			daRating = 'bad';
			score = 100;
			inc = 0.4;
			missanim(notedata);
			heal = -0.02;
			bads += 1;
		}
		else if (noteDiff > 50)
		{
			daRating = 'good';
			score = 200;
			inc = 0.7;
			goods += 1;
		}
		else
		{
			sicks += 1;
			if (!FlxG.save.data.nosplash)
			{
				var splash:NoteSplash = new NoteSplash(daNote, notedata);
				splash.cameras = [camHUD];
				add(splash);
			}
		}
		if (!practice)
			health += heal;
		/*else if (noteDiff > Conductor.safeZoneOffset * 0.1)
			{
				inc = 0.7;
		}*/

		if (combo > 50)
			score *= 1.5;
		else if (combo > 40)
			score *= 1.4;
		else if (combo > 30)
			score *= 1.3;
		else if (combo > 20)
			score *= 1.2;
		else if (combo > 10)
			score *= 1.1;

		songScore += score;
		hits += inc;
		total += 1;
		acc = hits / total * 100;
		acc = Math.round(acc * 100) / 100;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;
		switch (keym)
		{
			case 1:
				up = FlxG.keys.pressed.J;
				right = FlxG.keys.pressed.K;
				down = FlxG.keys.pressed.F;
				left = FlxG.keys.pressed.D;

				upP = FlxG.keys.justPressed.J;
				rightP = FlxG.keys.justPressed.K;
				downP = FlxG.keys.justPressed.F;
				leftP = FlxG.keys.justPressed.D;

				upR = FlxG.keys.justReleased.J;
				rightR = FlxG.keys.justReleased.K;
				downR = FlxG.keys.justReleased.F;
				leftR = FlxG.keys.justReleased.D;
			case 2:
				up = FlxG.keys.anyPressed([UP, W]);
				right = FlxG.keys.anyPressed([RIGHT, D]);
				down = FlxG.keys.anyPressed([DOWN, S]);
				left = FlxG.keys.anyPressed([LEFT, A]);

				upP = FlxG.keys.anyJustPressed([UP, W]);
				rightP = FlxG.keys.anyJustPressed([RIGHT, D]);
				downP = FlxG.keys.anyJustPressed([DOWN, S]);
				leftP = FlxG.keys.anyJustPressed([LEFT, A]);

				upR = FlxG.keys.anyJustReleased([UP, W]);
				rightR = FlxG.keys.anyJustReleased([RIGHT, D]);
				downR = FlxG.keys.anyJustReleased([DOWN, S]);
				leftR = FlxG.keys.anyJustReleased([LEFT, A]);
			case 3:
				up = FlxG.keys.pressed.J;
				right = FlxG.keys.pressed.N;
				down = FlxG.keys.pressed.F;
				left = FlxG.keys.pressed.V;

				upP = FlxG.keys.justPressed.J;
				rightP = FlxG.keys.justPressed.N;
				downP = FlxG.keys.justPressed.F;
				leftP = FlxG.keys.justPressed.V;

				upR = FlxG.keys.justReleased.J;
				rightR = FlxG.keys.justReleased.N;
				downR = FlxG.keys.justReleased.F;
				leftR = FlxG.keys.justReleased.V;
			case 4:
				upP = FlxG.keys.justPressed.J;
				rightP = FlxG.keys.justPressed.K;
				downP = FlxG.keys.justPressed.DOWN;
				leftP = FlxG.keys.justPressed.LEFT;

				upP = FlxG.keys.justPressed.J;
				rightP = FlxG.keys.justPressed.K;
				downP = FlxG.keys.justPressed.DOWN;
				leftP = FlxG.keys.justPressed.LEFT;

				upR = FlxG.keys.justReleased.J;
				rightR = FlxG.keys.justReleased.K;
				downR = FlxG.keys.justReleased.DOWN;
				leftR = FlxG.keys.justReleased.LEFT;
		}

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		var possibleNotes:Array<Note> = [];
		var ignoreList:Array<Int> = [];

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
			{
				// the sorting probably doesn't need to be in here? who cares lol
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				ignoreList.push(daNote.noteData);
			}
		});
		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				var checknext:Bool = true;

				var needit:Array<Bool> = [true, true, true, true];

				if (perfectMode)
					noteCheck(true, daNote, true);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					for (coolNote in possibleNotes)
					{
						if (!coolNote.isEnd)
						{
							if (needit[coolNote.noteData])
							{
								needit[coolNote.noteData] = false;
								noteCheck(controlArray[coolNote.noteData], coolNote, false);
							}
						}
					}
					for (key in 0...4)
					{
						if (controlArray[key] && needit[key])
							noteMiss(key);
					}
				}
				else if (!daNote.isEnd) // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote, true);
				}
				else
				{
					badNoteCheck();
				}
			}
			else
			{
				badNoteCheck();
			}
		}

		if ((up || right || down || left) && !boyfriend.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote && !daNote.isLastSustain)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 0:
							if (left)
								goodNoteHit(daNote);
						case 1:
							if (down)
								goodNoteHit(daNote);
						case 2:
							if (up)
								goodNoteHit(daNote);
						case 3:
							if (right)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if ((upR || rightR || downR || leftR) && !boyfriend.stunned && generatedMusic)
		{
			if (possibleNotes.length > 0)
			{
				var needit:Array<Bool> = [true, true, true, true];

				for (coolNote in possibleNotes)
				{
					if (coolNote.isEnd)
					{
						if (needit[coolNote.noteData])
						{
							switch (coolNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 0:
									if (leftR)
										goodNoteHit(coolNote);
								case 1:
									if (downR)
										goodNoteHit(coolNote);
								case 2:
									if (upR)
										goodNoteHit(coolNote);
								case 3:
									if (rightR)
										goodNoteHit(coolNote);
							}
							needit[coolNote.noteData] = false;
						}
					}
				}
			}
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:NoteStrum)
		{
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
			{
				if (spr.rendermode == 0)
				{
					spr.centerOffsets();
					if (spr.angle == 0)
					{
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
					{
						spr.offset.x -= 13 + (FlxMath.fastCos((spr.angle + 225) / 180 * Math.PI) + 1) * 28;
						spr.offset.y -= 13 + (FlxMath.fastSin((spr.angle + 225) / 180 * Math.PI) + 1) * 28;
					}
				}
			}
			else
				spr.centerOffsets();
		});
	}

	function renewstrum():Void
	{
		playerStrums.forEach(function(spr:NoteStrum)
		{
			spr.animation.play('static');
			spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (inp == 1)
		{
			if (!practice)
				health -= 0.05; // 0.04
			songScore -= 10;
			wrongs += 1;
			missanim(direction, true);
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		switch (keym)
		{
			case 1:
				upP = FlxG.keys.justPressed.J;
				rightP = FlxG.keys.justPressed.K;
				downP = FlxG.keys.justPressed.F;
				leftP = FlxG.keys.justPressed.D;
			case 2:
				upP = FlxG.keys.anyJustPressed([UP, W]);
				rightP = FlxG.keys.anyJustPressed([RIGHT, D]);
				downP = FlxG.keys.anyJustPressed([DOWN, S]);
				leftP = FlxG.keys.anyJustPressed([LEFT, A]);
			case 3:
				upP = FlxG.keys.justPressed.J;
				rightP = FlxG.keys.justPressed.N;
				downP = FlxG.keys.justPressed.F;
				leftP = FlxG.keys.justPressed.V;
			case 4:
				upP = FlxG.keys.justPressed.J;
				rightP = FlxG.keys.justPressed.K;
				downP = FlxG.keys.justPressed.DOWN;
				leftP = FlxG.keys.justPressed.LEFT;
		}

		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
	}

	function noteCheck(keyP:Bool, note:Note, checkbad:Bool):Void
	{
		if (keyP)
			goodNoteHit(note);
		else if (checkbad)
		{
			badNoteCheck();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note.noteData, note);
				combo += 1;
			}
			else
			{
				hits += 1;
				total += 1;
				sicks += 1;
				acc = hits / total * 100;
				acc = Math.round(acc * 100) / 100;
				var score:Float = 20;
				if (combo > 50)
					score *= 1.5;
				else if (combo > 40)
					score *= 1.4;
				else if (combo > 30)
					score *= 1.3;
				else if (combo > 20)
					score *= 1.2;
				else if (combo > 10)
					score *= 1.1;
				songScore += score;
				justCombo();
				combo += 1;
				if (!practice)
					health += 0.023;
			}

			if (combo > maxc)
			{
				maxc = combo;
			}

			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:NoteStrum)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm' + PlayMoving.ns, true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			PlayMoving.ongood(note);
			note.kill();
			notes.remove(note, true);
			noteAndStrum.remove(note, true);
			note.destroy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function missanim(direction:Int, stun:Bool = false):Void
	{
		if (combo > 5 && gf.animOffsets.exists('sad'))
		{
			gf.playAnim('sad');
		}
		combo = 0;

		if (!boyfriend.stunned)
		{
			FlxG.sound.play(misssounds[FlxG.random.int(0, 2)], FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (stun)
			{
				boyfriend.stunned = true;

				// get stunned for 5 seconds
				new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
			}

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function updateUFO():Void
	{
		ufo.x -= 0.4;
		ufo.y = ufoy + 10 * FlxMath.fastSin(Conductor.songPosition / 500);
		if (ufo.x < -800)
		{
			ufo.x = 1200;
			ufoy = FlxG.random.int(0, 500);
		}
	}

	function updatestrumtext():Void
	{
		if (curBeat == 112)
		{
			for (i in strumtext)
			{
				i.alpha = 1;
				if (FlxG.save.data.downscroll)
					i.y = 540 - i.height;
			}
			keym = 1;
			renewstrum();
		}
		if (curBeat >= 132 && curBeat < 140)
		{
			for (i in strumtext)
				i.alpha -= 0.1;
		}
		if (curBeat == 176)
		{
			for (i in 0...4)
			{
				strumtext[i].text = strumtextlist[1][i];
				strumtext[i].alpha = 1;
				if (FlxG.save.data.downscroll)
					strumtext[i].y = 540 - strumtext[i].height;
			}
			keym = 2;
			renewstrum();
		}
		if (curBeat >= 196 && curBeat < 204)
		{
			for (i in strumtext)
				i.alpha -= 0.1;
		}
		if (curBeat == 224)
		{
			for (i in 0...4)
			{
				strumtext[i].text = strumtextlist[2][i];
				switch (i)
				{
					case 0:
						strumtext[i].x = 564;
						strumtext[i].y = 528;
					case 1:
						strumtext[i].x = 564;
						strumtext[i].y = 426;
					case 2:
						strumtext[i].x = 716;
						strumtext[i].y = 426;
					case 3:
						strumtext[i].x = 716;
						strumtext[i].y = 528;
				}
				strumtext[i].alpha = 1;
			}
			keym = 3;
			renewstrum();
		}
		if (curBeat >= 244 && curBeat < 252)
		{
			for (i in strumtext)
				i.alpha -= 0.1;
		}
		if (curBeat == 256)
		{
			strumtext[0].text = "default";
			strumtext[0].x = 802;
			strumtext[0].y = 170;
			if (FlxG.save.data.downscroll)
				strumtext[0].y = 540 - strumtext[0].height;
			strumtext[0].alpha = 1;
			keym = 0;
			renewstrum();
		}
		if (curBeat >= 272 && curBeat < 276)
		{
			strumtext[0].alpha -= 0.1;
		}
		if (curBeat == 368)
		{
			for (i in 0...4)
			{
				strumtext[i].text = strumtextlist[0][i];
				strumtext[i].alpha = 1;
				strumtext[i].y = 170;
				strumtext[i].x = 730 + 112 * i;
				if (FlxG.save.data.downscroll)
					strumtext[i].y = 540 - strumtext[i].height;
			}
			keym = 1;
			renewstrum();
		}
		if (curBeat >= 388 && curBeat < 396)
		{
			for (i in strumtext)
				i.alpha -= 0.1;
		}
		if (curBeat == 432)
		{
			for (i in 0...4)
			{
				strumtext[i].text = strumtextlist[1][i];
				strumtext[i].alpha = 1;
				if (FlxG.save.data.downscroll)
					strumtext[i].y = 540 - strumtext[i].height;
			}
			keym = 2;
			renewstrum();
		}
		if (curBeat >= 452 && curBeat < 460)
		{
			for (i in strumtext)
				i.alpha -= 0.1;
		}
		if (curBeat == 480)
		{
			for (i in 0...4)
			{
				strumtext[i].text = strumtextlist[3][i];
				strumtext[i].alpha = 1;
				strumtext[i].y = 170;
				if (FlxG.save.data.downscroll)
					strumtext[i].y = 540 - strumtext[i].height;
			}
			keym = 4;
			renewstrum();
		}
		if (curBeat >= 480 && curBeat < 528)
		{
			for (i in 0...4)
			{
				strumtext[i].text = strumtextlist[3][i];
				strumtext[i].y = PlayMoving.ylist[i] + 120;
				if (FlxG.save.data.downscroll)
					strumtext[i].y = PlayMoving.ylist[i] - 10 - strumtext[i].height;
			}
		}
		if (curBeat >= 520 && curBeat < 528)
		{
			for (i in strumtext)
				i.alpha -= 0.1;
		}
		if (curBeat == 544)
		{
			strumtext[0].text = "default";
			strumtext[0].x = 802;
			strumtext[0].y = 170;
			strumtext[1].text = "(OLD INPUT)";
			strumtext[1].x = 540;
			strumtext[1].y = 400;
			if (FlxG.save.data.downscroll)
				strumtext[0].y = 540 - strumtext[0].height;
			strumtext[0].alpha = 1;
			strumtext[1].alpha = 1;
			keym = 0;
			renewstrum();
			inp = 1;
		}
		if (curBeat >= 564 && curBeat < 572)
		{
			strumtext[0].alpha -= 0.1;
			strumtext[1].alpha -= 0.02;
		}
		if (curBeat == 608)
		{
			strumtext[1].text = "(GALAXY INPUT)";
			strumtext[1].x = 540;
			strumtext[1].y = 500;
			strumtext[1].alpha = 1;
			inp = 0;
			tarmiss = 1;
			missnow = 0;
			missimg[1].loadGraphic(Paths.image('num' + tarmiss));
			missimg[2].loadGraphic(Paths.image('num' + missnow));
			for (i in 0...3)
			{
				missimg[i].alpha = 1;
			}
		}
		if (curBeat >= 616 && curBeat < 624)
		{
			strumtext[1].alpha -= 0.02;
		}
		if (curBeat > 608 && curBeat < 674)
		{
			missimg[1].loadGraphic(Paths.image('num' + tarmiss));
			missimg[2].loadGraphic(Paths.image('num' + missnow));
			if (missnow > tarmiss)
			{
				health -= 0.1;
			}
		}
		if (curBeat == 625 || curBeat == 641 || curBeat == 673)
		{
			if (missnow != tarmiss)
			{
				health -= 0.1;
			}
		}
		if (curBeat == 626)
		{
			missnow = 0;
			tarmiss = 3;
		}
		if (curBeat == 642)
		{
			missnow = 0;
			tarmiss = 5;
		}
		if (curBeat >= 674 && curBeat < 682)
		{
			for (i in 0...3)
			{
				missimg[i].alpha -= 0.1;
			}
		}
	}

	function updatewhite():Void
	{
		if (whitefg.alpha > 0)
		{
			whitefg.alpha -= 0.1;
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function changestrum(type:String)
	{
		notetype = type;
		strumLineNotes = new FlxTypedGroup<NoteStrum>();
		playerStrums = new FlxTypedGroup<NoteStrum>();
		var deletelist:Array<NoteObject> = [];
		noteAndStrum.forEach(function(daNote:NoteObject)
		{
			if (daNote.strumTime == FlxMath.MAX_VALUE_FLOAT)
			{
				deletelist.push(daNote);
			}
		});
		for (daNote in deletelist)
		{
			daNote.kill();
			noteAndStrum.remove(daNote, true);
			daNote.destroy();
		}

		generateStaticArrows(0, type, false);
		generateStaticArrows(1, type, false);

		notes.forEachAlive(function(daNote:Note)
		{
			var oriani:String = daNote.animation.curAnim.name;

			if (type == "kali")
				daNote.frames = Paths.getSparrowAtlas('cor/cyber');
			else
				daNote.frames = Paths.getSparrowAtlas('NOTE_assets');
			daNote.animation.addByPrefix('greenScroll', 'green0');
			daNote.animation.addByPrefix('redScroll', 'red0');
			daNote.animation.addByPrefix('blueScroll', 'blue0');
			daNote.animation.addByPrefix('purpleScroll', 'purple0');

			daNote.animation.addByPrefix('greensync', 'sgreen0');
			daNote.animation.addByPrefix('redsync', 'sred0');
			daNote.animation.addByPrefix('bluesync', 'sblue0');
			daNote.animation.addByPrefix('purplesync', 'spurple0');

			daNote.animation.addByPrefix('purpleholdend', 'pruple end hold');
			daNote.animation.addByPrefix('greenholdend', 'green hold end');
			daNote.animation.addByPrefix('redholdend', 'red hold end');
			daNote.animation.addByPrefix('blueholdend', 'blue hold end');

			daNote.animation.addByPrefix('purplehold', 'purple hold piece');
			daNote.animation.addByPrefix('greenhold', 'green hold piece');
			daNote.animation.addByPrefix('redhold', 'red hold piece');
			daNote.animation.addByPrefix('bluehold', 'blue hold piece');

			daNote.animation.play(oriani);
			daNote.setGraphicSize(Std.int(daNote.width * 0.7));
			daNote.updateHitbox();
			if (daNote.isSustainNote)
			{
				daNote.scale.x = 0.7;
				if (daNote.animation.curAnim.name.endsWith('hold'))
					daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				else
					daNote.scale.y = 0.7;
				daNote.updateHitbox();
			}
		});
		for (daNote in unspawnNotes)
		{
			var oriani:String = daNote.animation.curAnim.name;

			if (type == "kali")
				daNote.frames = Paths.getSparrowAtlas('cor/cyber');
			else
				daNote.frames = Paths.getSparrowAtlas('NOTE_assets');
			daNote.animation.addByPrefix('greenScroll', 'green0');
			daNote.animation.addByPrefix('redScroll', 'red0');
			daNote.animation.addByPrefix('blueScroll', 'blue0');
			daNote.animation.addByPrefix('purpleScroll', 'purple0');

			daNote.animation.addByPrefix('greensync', 'sgreen0');
			daNote.animation.addByPrefix('redsync', 'sred0');
			daNote.animation.addByPrefix('bluesync', 'sblue0');
			daNote.animation.addByPrefix('purplesync', 'spurple0');

			daNote.animation.addByPrefix('purpleholdend', 'pruple end hold');
			daNote.animation.addByPrefix('greenholdend', 'green hold end');
			daNote.animation.addByPrefix('redholdend', 'red hold end');
			daNote.animation.addByPrefix('blueholdend', 'blue hold end');

			daNote.animation.addByPrefix('purplehold', 'purple hold piece');
			daNote.animation.addByPrefix('greenhold', 'green hold piece');
			daNote.animation.addByPrefix('redhold', 'red hold piece');
			daNote.animation.addByPrefix('bluehold', 'blue hold piece');

			daNote.animation.play(oriani);
			daNote.setGraphicSize(Std.int(daNote.width * 0.7));
			daNote.updateHitbox();
			if (daNote.isSustainNote)
			{
				daNote.scale.x = 0.7;
				if (daNote.animation.curAnim.name.endsWith('hold'))
					daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				else
					daNote.scale.y = 0.7;
				daNote.updateHitbox();
			}
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (!paused && (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20))
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			// if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0 && (gf.animation.curAnim.name != "sad" || gf.animation.curAnim.looped))
		{
			gf.dance();
		}
		if (!dad.animation.curAnim.name.startsWith("sing"))
		{
			dad.dance(curBeat % 2 == 0);
		}
		if (!boyfriend.animation.curAnim.name.startsWith("sing") && curBeat % 2 == 0)
		{
			boyfriend.playAnim('idle', true);
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		if (SONG.song.toLowerCase() == "underworld")
		{
			for (i in 0...FlxG.random.int(1, 8))
			{
				var newhex:FlxSprite = new FlxSprite(FlxG.random.int(-500, 3000), 1500).loadGraphic(Paths.image('cor/hexagon'));
				hexes.add(newhex);
			}
			if (curBeat == 96 || curBeat == 256)
			{
				gf.alpha = 0;
				blbg.alpha = 1;
				remove(boyfriend);
				boyfriend = new Boyfriend(1070, 450, 'bf-pur');
				add(boyfriend);
				remove(dad);
				dad = new Character(-70, 300, "kalisax");
				add(dad);
				changestrum("kali");
			}
			else if (curBeat == 160 || curBeat == 384)
			{
				gf.alpha = 1;
				blbg.alpha = 0;
				remove(boyfriend);
				boyfriend = new Boyfriend(1070, 450, 'bf');
				add(boyfriend);
				remove(dad);
				dad = new Character(-70, 300, "kalisa");
				add(dad);
				changestrum("null");
			}
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case "ship":
				earth.animation.play('bump', true);
				if (curBeat % 4 == 0)
				{
					var vi:Bool = true;
					while (vi)
					{
						planets.forEach(function(light:FlxSprite)
						{
							light.visible = FlxG.random.bool();
							if (light.visible)
								vi = false;
						});
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}

		PlayMoving.beatHit(this, curBeat);
	}

	var curLight:Int = 0;

	override function load()
	{
		Paths.setCurrentLevel("weeks");

		var daLoad = new LoadPlay();

		var loaded = LoadPlay.isSoundLoaded(LoadPlay.getSongPath())
			&& (!SONG.needsVoices || LoadPlay.isSoundLoaded(LoadPlay.getVocalPath()))
			&& LoadPlay.isLibraryLoaded("shared");

		if (!loaded)
		{
			LoadPlay.initSongsManifest().onComplete(function(lib)
			{
				daLoad.callbacks = new MultiCallback(function() {});
				var introComplete = daLoad.callbacks.add("introComplete");
				daLoad.checkLoadSong(LoadPlay.getSongPath());
				if (SONG.needsVoices)
					daLoad.checkLoadSong(LoadPlay.getVocalPath());
				daLoad.checkLibrary("shared");
				if (storyWeek > 0)
					daLoad.checkLibrary("weeks");
				else
					daLoad.checkLibrary("tutorial");
			});
		}
		LoadingState.progress = 30;
		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');
		var tasks:Float = 7;
		switch (SONG.song.toLowerCase())
		{
			case "underworld":
				tasks = 10;
		}
		var task:Float = 0;

		FlxG.sound.load(Paths.music('breakfast'));
		FlxG.sound.load(Paths.music('result'));
		task += 1;
		LoadingState.progress = Std.int(30 + 70 * (task / tasks));

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		task += 1;
		LoadingState.progress = Std.int(30 + 70 * (task / tasks));

		switch (SONG.song.toLowerCase())
		{
			case 'galaxy' | "game" | "kastimagina" | "familanna":
				curStage = 'ship';
			case 'cona' | 'underworld' | 'cyber':
				curStage = "cona";
			case "newton" | "destiny" | "peace":
				curStage = "somewhere";
			default:
				curStage = 'stage';
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'cona':
				gfVersion = 'gf-twin';
			case 'somewhere':
				gfVersion = 'gf-space';
		}

		#if PRELOAD_ALL
		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		task += 1;
		LoadingState.progress = Std.int(30 + 70 * (task / tasks));

		var n = new Note(0, 0, null, false);
		var s = new NoteSplash(n, 0);
		var x0 = new NoteStrum(0, 50, 0, 0);
		var x1 = new NoteStrum(0, 50, 0, 1);
		var x2 = new NoteStrum(0, 50, 0, 2);
		var x3 = new NoteStrum(0, 50, 0, 3);
		LoadingState.allOfThem.push(n);
		LoadingState.allOfThem.push(s);
		LoadingState.allOfThem.push(x0);
		LoadingState.allOfThem.push(x1);
		LoadingState.allOfThem.push(x2);
		LoadingState.allOfThem.push(x3);
		task += 1;
		LoadingState.progress = Std.int(30 + 70 * (task / tasks));

		for (i in 0...3)
		{
			misssounds[i] = Paths.sound('missnote' + (i + 1));
			FlxG.sound.load(misssounds[i], 0);
		}
		task += 1;
		LoadingState.progress = Std.int(30 + 70 * (task / tasks));

		switch (SONG.song.toLowerCase())
		{
			case "underworld":
				boyfriend = new Boyfriend(1070, 450, 'bf-pur');
				task += 1;
				LoadingState.progress = Std.int(30 + 70 * (task / tasks));
				dad = new Character(-70, 300, "kalisax");
				task += 1;
				LoadingState.progress = Std.int(30 + 70 * (task / tasks));
				var n2 = new Note(0, 0, null, false);
				n2.frames = Paths.getSparrowAtlas('cor/cyber');
				n2.animation.addByPrefix('greenScroll', 'green0');
				n2.animation.addByPrefix('redScroll', 'red0');
				n2.animation.addByPrefix('blueScroll', 'blue0');
				n2.animation.addByPrefix('purpleScroll', 'purple0');

				n2.animation.addByPrefix('greensync', 'sgreen0');
				n2.animation.addByPrefix('redsync', 'sred0');
				n2.animation.addByPrefix('bluesync', 'sblue0');
				n2.animation.addByPrefix('purplesync', 'spurple0');

				n2.animation.addByPrefix('purpleholdend', 'pruple end hold');
				n2.animation.addByPrefix('greenholdend', 'green hold end');
				n2.animation.addByPrefix('redholdend', 'red hold end');
				n2.animation.addByPrefix('blueholdend', 'blue hold end');

				n2.animation.addByPrefix('purplehold', 'purple hold piece');
				n2.animation.addByPrefix('greenhold', 'green hold piece');
				n2.animation.addByPrefix('redhold', 'red hold piece');
				n2.animation.addByPrefix('bluehold', 'blue hold piece');
				var x4 = new NoteStrum(0, 50, 0, 0, "kali");
				var x5 = new NoteStrum(0, 50, 0, 1, "kali");
				var x6 = new NoteStrum(0, 50, 0, 2, "kali");
				var x7 = new NoteStrum(0, 50, 0, 3, "kali");
				LoadingState.allOfThem.push(n2);
				LoadingState.allOfThem.push(x4);
				LoadingState.allOfThem.push(x5);
				LoadingState.allOfThem.push(x6);
				LoadingState.allOfThem.push(x7);
				task += 1;
				LoadingState.progress = Std.int(30 + 70 * (task / tasks));
		}

		dad = new Character(100, 100, SONG.player2);
		task += 1;
		LoadingState.progress = Std.int(30 + 70 * (task / tasks));

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		task += 1;
		LoadingState.progress = Std.int(30 + 70 * (task / tasks));
		#end

		super.load();
	}
}

class LoadPlay
{
	inline static var MIN_TIME = 1.0;

	public var callbacks:MultiCallback;
	public var targetShit:Float = 0;

	public function new() {}

	public function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function(_)
			{
				callback();
			});
		}
	}

	public function checkLibrary(library:String)
	{
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function(_)
			{
				callback();
			});
		}
	}

	public static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}

	public static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}

	// #if NO_PRELOAD_ALL
	public static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}

	public static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}

	public static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
				promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;

	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();

	public function new(callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}

	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;

				if (logId != null)
					log('fired $id, $numRemaining remaining');

				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}

	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}

	public function getFired()
		return fired.copy();

	public function getUnfired()
		return [for (id in unfired.keys()) id];
}
