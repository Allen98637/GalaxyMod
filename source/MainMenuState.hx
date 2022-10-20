package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Lib;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var storied:Bool = false;
	public static var optioned:Bool = false;

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var bg:FlxSprite;
	var versionShit:FlxText;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', "options", 'donate'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var objectlist:Array<Array<Dynamic>> = [
		[58, 207, 189, 332, "DJ"],
		[297, 154, 360, 233, "warn"],
		[1039, 361, 1168, 417, "switch"],
		[7, 383, 250, 543, "steer"],
		[1, 34, 155, 257, "allen doll"]
	];
	var textBox:FlxSprite;
	var textTime:Float = 0;
	var stars:FlxTypedGroup<NoteObject>;
	var black:FlxSprite;

	var nostar:Float = 0;

	var trops:Welcome;

	override function load()
	{
		if (FlxGameJolt.initialized)
		{
			trops = new Welcome(1, Main.syncTrophy());
		}
		if (FlxG.save.data.autoUpload && FlxGameJolt.initialized)
			Main.syncData();
		LoadingState.progress += 25;

		stars = new FlxTypedGroup<NoteObject>();
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
		LoadingState.progress += 25;

		bg = new FlxSprite(0, 0);
		bg.frames = Paths.getSparrowAtlas('menuBG');
		bg.animation.addByPrefix('animation', 'animation', 24);
		bg.animation.play("animation");
		LoadingState.progress += 25;

		menuItems = new FlxTypedGroup<FlxSprite>();

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		if (FlxG.save.data.lang == 1)
			tex = Paths.getSparrowAtlas('menuCH');

		var ylist:Array<Int> = [247, 309, 376, 453];
		var xlist:Array<Int> = [461, 483, 503, 513];
		if (FlxG.save.data.lang == 1)
		{
			xlist = [503, 501, 493, 490];
			ylist = [235, 297, 364, 441];
		}
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(xlist[i], ylist[i]);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			if (storied)
				menuItem.alpha = 0;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}
		LoadingState.progress += 25;

		super.load();
	}

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing || (storied && !optioned))
		{
			var ss:Float = 0.7;
			if (storied)
			{
				FlxG.sound.music.fadeIn(4, 0, 0.7);
				ss = 0;
			}
			FlxG.sound.playMusic(Paths.music('freakyMenu'), ss);
		}

		Conductor.changeBPM(140);
		persistentUpdate = persistentDraw = true;

		/*if (bg == null)
			load(); */

		add(stars);

		black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		if (!storied)
			black.alpha = 0;
		add(black);

		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		if (storied)
		{
			bg.alpha = 0;
			bg.scale.x = 3;
			bg.scale.y = 3;
			FlxTween.tween(bg, {alpha: 1}, 0.2, {
				ease: FlxEase.quadOut,
				onComplete: function(twn:FlxTween)
				{
					black.alpha = 0;
					FlxTween.tween(bg, {"scale.x": 1, "scale.y": 1}, 1.2, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							storied = false;
						}
					});
				}
			});
		}

		add(menuItems);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (storied)
			versionShit.alpha = 0;
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		textBox = new FlxSprite(0, 0);
		textBox.scrollFactor.set();
		textBox.alpha = 0;
		textBox.ID = 0;
		add(textBox);

		/*FlxGameJolt.fetchTrophy(163771, function(a:Dynamic)
			{
				trace(a.get("achieved"));
			});
			var k = new Welcome(1, [163724]);
			add(k);
			trace("k placed"); */
		if (trops != null)
			add(trops);

		changeItem();

		optioned = false;

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		/*allen 1 34 155 257
			steer 7 383 250 543
			switch 1039 361 1168 417
			alarm 297 154 360 233
			DJ 58 207 189 332 */
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		var enter:Bool = false;

		stars.forEachAlive(function(star:NoteObject)
		{
			star.z -= 0.5;
			star.x = NoteObject.toScreen(star.wx, star.wy, star.z)[0];
			star.y = NoteObject.toScreen(star.wx, star.wy, star.z)[1];
			if (star.z <= 0)
			{
				star.kill();
			}
		});

		if (!selectedSomethin && !storied)
		{
			if (FlxG.mouse.justPressed)
			{
				var did:Bool = false;
				for (i in objectlist)
				{
					if (FlxG.mouse.screenX > i[0] && FlxG.mouse.screenX < i[2] && FlxG.mouse.screenY > i[1] && FlxG.mouse.screenY < i[3]
						&& MusicBeatState.mouseA && !ConfirmSubState.inconfirm)
					{
						textBox.scale.x = 0;
						textBox.scale.y = 0;
						textBox.updateHitbox();
						textBox.x = FlxG.mouse.screenX + 10;
						textBox.y = FlxG.mouse.screenY + 10;
						if (textBox.x + 360 > 1280)
						{
							textBox.x = FlxG.mouse.screenX - 10;
							textBox.ID = 1;
						}
						else
							textBox.ID = 0;
						textBox.alpha = 1;
						if (FlxG.save.data.lang == 1)
							textBox.loadGraphic(Paths.image("menuobject/" + i[4] + "CH"));
						else
							textBox.loadGraphic(Paths.image("menuobject/" + i[4]));
						textTime = 0;
						did = true;
						break;
					}
				}
				if (!did)
					textTime = 10;
			}

			textTime += elapsed;
			if (textBox.scale.x < 1)
			{
				if (textBox.ID == 1 && textBox.scale.x != 0)
					textBox.x += textBox.width;
				textBox.scale.x += 0.05;
				textBox.scale.y += 0.05;
				textBox.updateHitbox();
				if (textBox.ID == 1)
					textBox.x -= textBox.width;
			}
			else if (textTime >= 10)
			{
				textBox.alpha -= 0.05;
			}

			versionShit.alpha = 1;
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.alpha += elapsed * 3;
				if (FlxG.mouse.screenX > spr.x
					&& FlxG.mouse.screenX < spr.x + spr.width
					&& FlxG.mouse.screenY > spr.y
					&& FlxG.mouse.screenY < spr.y + spr.height
					&& MusicBeatState.mouseA
					&& !ConfirmSubState.inconfirm)
				{
					if (curSelected != spr.ID)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(spr.ID, true);
					}
					if (FlxG.mouse.justPressed)
						enter = true;
				}
			});
			if ((controls.UP_UI || FlxG.mouse.wheel > 0) && !ConfirmSubState.inconfirm)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if ((controls.DOWN_UI || FlxG.mouse.wheel < 0) && !ConfirmSubState.inconfirm)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK && !ConfirmSubState.inconfirm)
			{
				var text:String = "Are you sure to quit the game?";
				if (FlxG.save.data.lang == 1)
					text = "你確定要離開遊戲嗎?";
				super.openSubState(new ConfirmSubState(text, function()
				{
					Lib.application.window.close();
				}));
			}

			if ((controls.ACCEPT || enter) && !ConfirmSubState.inconfirm)
			{
				selectedSomethin = true;
				versionShit.kill();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				textBox.alpha = 0;

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							FlxTransitionableState.skipNextTransOut = true;
							spr.kill();
							FlxTween.tween(bg, {"scale.x": 3, "scale.y": 3}, 1.2, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									black.alpha = 1;
									FlxTween.tween(bg, {alpha: 0}, 0.2, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
											switch (daChoice)
											{
												case 'story mode':
													FlxTransitionableState.skipNextTransIn = true;
													LoadingState.loadAndSwitchState(new StoryMenuState(), false, 1);
													trace("Story Menu Selected");
												case 'freeplay':
													LoadingState.loadAndSwitchState(new FreeplayState());
													trace("Freeplay Menu Selected");
												case 'options':
													LoadingState.loadAndSwitchState(new OptionsMenu());
												case 'donate':
													LoadingState.loadAndSwitchState(new CreditState());
											}
										}
									});
								}
							});
						});
					}
				});
			}
		}

		nostar += elapsed;
		if (nostar >= 120 / 140)
		{
			for (i in 0...new FlxRandom().int(10, 20))
			{
				var nstar:NoteObject = new NoteObject();
				nstar.makeGraphic(5, 5, 0xFFffffff);
				nstar.wx = new FlxRandom().float(0, 1280);
				nstar.wy = new FlxRandom().float(0, 720);
				nstar.z = 1000;
				stars.add(nstar);
			}
			nostar = 0;
		}
		super.update(elapsed);
	}

	function changeItem(huh:Int = 0, direct:Bool = false)
	{
		if (direct)
			curSelected = huh;
		else
			curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}
