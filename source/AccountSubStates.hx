package;

import Controls.Control;
import Options;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

using StringTools;

class LogInScreen extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var name:FlxText;
	var nameBox:FlxInputText;
	var token:FlxText;
	var tokenBox:FlxInputText;
	var option:AccountOption;
	var show:FlxSprite;
	var showtext:FlxText;
	var incorrect:FlxText;

	var showt:Bool = true;

	public function new(option:AccountOption)
	{
		this.option = option;
		super();

		OptionsMenu.instance.acceptInput = false;

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('loadbg'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		add(bg);

		name = new FlxText(100, 100, 0, "Account Name", 60);
		name.font = "VCR OSD Mono";
		name.color = 0xFFffffff;
		add(name);

		nameBox = new FlxInputText(600, 100, 600, "", 60, FlxColor.BLACK, 0xff878787);
		nameBox.font = "VCR OSD Mono";
		add(nameBox);

		token = new FlxText(100, 400, 0, "Account Token", 60);
		token.font = "VCR OSD Mono";
		token.color = 0xFFffffff;
		add(token);

		tokenBox = new FlxInputText(600, 400, 600, "", 60, FlxColor.BLACK, 0xff878787);
		tokenBox.font = "VCR OSD Mono";
		tokenBox.passwordMode = true;
		add(tokenBox);

		incorrect = new FlxText(300, 500, 0, "Press Enter to log in, escape to cancel", 30);
		incorrect.font = "VCR OSD Mono";
		incorrect.color = 0xFFffffff;
		add(incorrect);

		show = new FlxSprite(435, 602);
		show.frames = Paths.getSparrowAtlas('checkbox');
		show.animation.addByPrefix('none', 'checkbox0', 24, false);
		show.animation.addByPrefix('check', 'checkbox anim0', 24, false);
		show.animation.addByPrefix('uncheck', 'checkbox anim reverse', 24, false);
		show.animation.addByPrefix('finish', 'checkbox finish', 24, false);
		show.animation.play("none");
		show.antialiasing = true;
		show.setGraphicSize(0, 70);
		show.updateHitbox();
		add(show);

		showtext = new FlxText(520, 610, 0, "Show Token", 70);
		showtext.font = "VCR OSD Mono";
		showtext.color = 0xFFffffff;
		add(showtext);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.mouse.screenX > 450 && FlxG.mouse.screenX < 510 && FlxG.mouse.screenY > 610 && FlxG.mouse.screenY < 670 && MusicBeatState.mouseA
			&& FlxG.mouse.justPressed)
		{
			showt = !showt;
			show.animation.play(!showt ? "check" : "uncheck");
			tokenBox.passwordMode = showt;
			tokenBox.text = tokenBox.text;
		}

		if (show.animation.curAnim != null && show.animation.curAnim.finished)
		{
			switch (show.animation.curAnim.name)
			{
				case "check":
					show.animation.play("finish");
				case "uncheck":
					show.animation.play("none");
			}
		}
		switch (show.animation.curAnim.name)
		{
			case "check":
				show.offset.set(25, 18);
			case "uncheck":
				show.offset.set(18, 21);
			case "finish":
				show.offset.set(2, 9);
			case "none":
				show.offset.set(0, 2);
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxGameJolt.verbose = true;
			FlxGameJolt.authUser(nameBox.text, tokenBox.text, function(good:Bool)
			{
				trace(nameBox.text + " " + tokenBox.text);
				trace(FlxGameJolt.initialized);
				if (good)
				{
					FlxG.save.data.userName = nameBox.text;
					FlxG.save.data.userToken = tokenBox.text;
					trace(FlxG.save.data.userName + " " + FlxG.save.data.userToken);
					OptionsMenu.instance.acceptInput = true;
					option.log();
					close();
				}
				else
				{
					incorrect.text = "Log in failed, please check your account or token again.";
					incorrect.color = 0xffff0000;
					incorrect.x = 150;
					tokenBox.text = "";
				}
			});
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			OptionsMenu.instance.acceptInput = true;
			close();
		}

		super.update(elapsed);
	}
}

class DataScreen extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var upload:Alphabet;
	var upicon:Array<HealthIcon> = [];
	var uptext:FlxText;
	var download:Alphabet;
	var downicon:Array<HealthIcon> = [];
	var downtext:FlxText;

	var iconnames:Array<String> = ["gf", "kastimagina", "kalisa", "unknown"];

	var up:Bool = true;

	public var prog:Int = 0;

	var bar:FlxBar;

	var dataGet:Bool = false;
	var startGet:Bool = false;
	var processFinished:Bool = false;

	var weekPassed:Array<Array<Bool>> = [];
	var songScores:Map<String, Int> = new Map();
	var songAccs:Map<String, Float> = new Map();
	var songCombos:Map<String, Int> = new Map();

	var max:Int = 4;
	var now:Int = 0;

	public function new()
	{
		super();

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('loadbg'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		add(bg);

		upload = new Alphabet(50, 160, "upload to cloud", true);
		add(upload);

		download = new Alphabet(50, 460, "download from cloud", true);
		add(download);

		var bruh = 0;
		for (i in iconnames)
		{
			var newup = new HealthIcon(i);
			newup.x = 30 + bruh * 150;
			newup.y = 250;
			newup.color = StoryMenuState.weekPassed[bruh].contains(true) ? 0xffffff : 0x878787;
			upicon.push(newup);
			add(newup);

			var newdown = new HealthIcon(i);
			newdown.x = 30 + bruh * 150;
			newdown.y = 550;
			newdown.color = 0x878787;
			downicon.push(newdown);
			add(newdown);

			bruh += 1;
		}

		uptext = new FlxText(30 + iconnames.length * 150, 300, 0, "Total Score: 0", 40);
		uptext.font = "Pixel Arial 11 Bold";
		var tot:Int = 0;
		for (i in Highscore.songScores.keys())
		{
			if (!i.startsWith("week"))
				tot += Highscore.songScores.get(i);
		}
		uptext.text = "Total Score: " + tot;
		add(uptext);

		downtext = new FlxText(30 + iconnames.length * 150, 600, 0, "Total Score: 0", 40);
		downtext.font = "Pixel Arial 11 Bold";
		add(downtext);

		bar = new FlxBar(0, FlxG.height - 20, FlxBarFillDirection.HORIZONTAL_INSIDE_OUT, FlxG.width, 10, this, "prog", 0, 100);
		bar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.fromRGB(255, 22, 210));
		add(bar);
	}

	override function update(elapsed:Float)
	{
		upload.alpha = up ? 1 : 0.6;
		download.alpha = up ? 0.6 : 1;
		download.color = dataGet ? 0xffffff : 0x878787;
		upload.color = dataGet ? 0xffffff : 0x878787;

		bar.visible = !processFinished;
		prog = Std.int(100 * now / max);

		if (!startGet)
		{
			getCloud();
			startGet = true;
		}

		if (controls.UP_UI || controls.DOWN_UI || FlxG.mouse.wheel != 0)
		{
			up = !up;
			FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
		}

		if (controls.BACK && processFinished)
		{
			OptionsMenu.instance.acceptInput = true;
			close();
		}

		if (controls.ACCEPT && processFinished && dataGet)
		{
			if (up)
			{
				max = 8;
				now = 0;
				processFinished = false;
				var text:String = "Are you sure to upload your data? (The old data will be replaced)";
				if (FlxG.save.data.lang == 1)
					text = "你確定上傳資料嗎? (舊資料將會被取代)";
				openSubState(new ConfirmSubState(text, updata, false, function()
				{
					processFinished = true;
				}));
			}
			else
			{
				var text:String = "Are you sure to download your data? (The old data will be replaced)";
				if (FlxG.save.data.lang == 1)
					text = "你確定下載資料嗎? (舊資料將會被取代)";
				openSubState(new ConfirmSubState(text, downdata));
			}
		}

		super.update(elapsed);
	}

	private function updata()
	{
		#if PRELOAD_ALL
		sys.thread.Thread.create(() ->
		{
			dataGet = false;
			var task:Bool = true;

			var wp:String = "";
			task = true;
			for (i in StoryMenuState.weekPassed)
			{
				for (j in i)
				{
					wp += j ? "1" : "0";
					wp += ",";
				}
				wp = wp.substr(0, wp.length - 1);
				wp += ";";
			}
			wp = wp.substr(0, wp.length - 1);
			FlxGameJolt.setData("weekPassed", wp, true, function(e:Dynamic)
			{
				task = false;
				now += 1;
			});

			var sc:String = "";
			while (task)
				Sys.sleep(0.1);
			task = true;
			for (i in Highscore.songScores.keys())
			{
				sc += i + ":" + Highscore.songScores.get(i) + ",";
			}
			sc = sc.substr(0, sc.length - 1);
			FlxGameJolt.setData("songScores", sc, true, function(e:Dynamic)
			{
				task = false;
				now += 1;
			});

			var sa:String = "";
			while (task)
				Sys.sleep(0.1);
			task = true;
			for (i in Highscore.songAccs.keys())
			{
				sa += i + ":" + Highscore.songAccs.get(i) + ",";
			}
			sa = sa.substr(0, sa.length - 1);
			FlxGameJolt.setData("songAccs", sa, true, function(e:Dynamic)
			{
				task = false;
				now += 1;
			});

			var sco:String = "";
			while (task)
				Sys.sleep(0.1);
			task = true;
			for (i in Highscore.songCombos.keys())
			{
				sco += i + ":" + Highscore.songCombos.get(i) + ",";
			}
			sco = sco.substr(0, sco.length - 1);
			FlxGameJolt.setData("songCombos", sco, true, function(e:Dynamic)
			{
				task = false;
				now += 1;
			});

			while (task)
				Sys.sleep(0.1);
			getCloud();
		});
		#end
	}

	private function downdata()
	{
		FlxG.save.data.weekPassed = weekPassed;
		FlxG.save.data.songScores = songScores;
		FlxG.save.data.songAccs = songAccs;
		FlxG.save.data.songCombos = songCombos;
		FlxG.save.flush();
		Highscore.load();
		StoryMenuState.weekPassed = FlxG.save.data.weekPassed;
		var bruh = 0;
		for (i in upicon)
		{
			i.color = StoryMenuState.weekPassed[bruh].contains(true) ? 0xffffff : 0x878787;
			bruh += 1;
		}

		var tot:Int = 0;
		for (i in Highscore.songScores.keys())
		{
			if (!i.startsWith("week"))
				tot += Highscore.songScores.get(i);
		}
		uptext.text = "Total Score: " + tot;
	}

	private function getCloud()
	{
		#if PRELOAD_ALL
		sys.thread.Thread.create(() ->
		{
			dataGet = false;
			var task:Bool = true;

			task = true;
			FlxGameJolt.fetchData("weekPassed", true, function(a:Dynamic)
			{
				weekPassed = [];
				if (a.exists("data"))
				{
					var b:String = a.get("data");
					for (i in b.split(";"))
					{
						weekPassed.push([]);
						for (j in i.split(","))
							weekPassed[weekPassed.length - 1].push(j == "1");
					}
					if (StoryMenuState.weekPassed.length > weekPassed.length)
					{
						for (i in 0...StoryMenuState.weekPassed.length)
						{
							if (weekPassed.length <= i)
								weekPassed.push(StoryMenuState.weekPassed[i]);
						}
					}
				}
				else
				{
					for (i in StoryMenuState.weekPassed)
					{
						weekPassed.push([]);
						for (j in i)
							weekPassed[weekPassed.length - 1].push(false);
					}
				}
				trace(weekPassed);
				task = false;
				now += 1;
			});

			while (task)
				Sys.sleep(0.1);
			task = true;
			FlxGameJolt.fetchData("songScores", true, function(s:Dynamic)
			{
				songScores = new Map();
				if (s.exists("data"))
				{
					var b:String = s.get("data");
					for (i in b.split(","))
					{
						songScores.set(i.split(":")[0], Std.parseInt(i.split(":")[1]));
					}
				}
				trace(songScores);
				task = false;
				now += 1;
			});

			while (task)
				Sys.sleep(0.1);
			task = true;
			FlxGameJolt.fetchData("songAccs", true, function(s:Dynamic)
			{
				songAccs = new Map();
				if (s.exists("data"))
				{
					var b:String = s.get("data");
					for (i in b.split(","))
					{
						songAccs.set(i.split(":")[0], Std.parseFloat(i.split(":")[1]));
					}
				}
				trace(songAccs);
				task = false;
				now += 1;
			});

			while (task)
				Sys.sleep(0.1);
			task = true;
			FlxGameJolt.fetchData("songCombos", true, function(s:Dynamic)
			{
				songCombos = new Map();
				if (s.exists("data"))
				{
					var b:String = s.get("data");
					for (i in b.split(","))
					{
						songCombos.set(i.split(":")[0], Std.parseInt(i.split(":")[1]));
					}
				}
				trace(songCombos);
				task = false;
				now += 1;
			});

			while (task)
				Sys.sleep(0.1);

			var bruh = 0;
			for (i in downicon)
			{
				i.color = weekPassed[bruh].contains(true) ? 0xffffff : 0x878787;
				bruh += 1;
			}
			var tot:Int = 0;
			for (i in songScores.keys())
			{
				if (!i.startsWith("week"))
					tot += songScores.get(i);
			}
			downtext.text = "Total Score: " + tot;

			dataGet = true;
			processFinished = true;
		});
		#end
	}
}
