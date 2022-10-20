package;

import Controls.Control;
import Options;
import flash.text.TextField;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.Lib;

class CreditState extends MusicBeatState
{
	var ppl:Array<String> = ["Allen98637", "A-tang", "Neonfovii", "Magolor", "Sintaro", "Cana Lee", "Rin"];
	var intros:Array<String> = [
		"Code, engine, music, character design, story, charts, mod publishing",
		"General Cutscene arts",
		"General Character arts",
		"Background arts",
		"Minor Character arts",
		"Art supprrt",
		"Title font design"
	];
	var colors:Array<Int> = [
		0xFFff7f50,
		0xFFffffff,
		0xFF18928b,
		0xFFe636e1,
		0xFFff7ef2,
		0xFFfffae7,
		0xFF00db96
	];
	var links:Array<Map<String, String>> = [
		[
			"per" => "https://allen98637.github.io/",
			"twe" => "https://twitter.com/allen98637",
			"yt" => "https://www.youtube.com/channel/UCdW7it5PvSudEVYpbU7xErw",
			"pat" => "https://www.patreon.com/allen98637",
			"sc" => "https://soundcloud.com/allen98637",
			"ng" => "https://allen98637.newgrounds.com/"
		],
		["twe" => "https://twitter.com/A_Tang_Yaaa"],
		["twe" => "https://twitter.com/Neonfovii"],
		["twe" => "https://twitter.com/MagolorStar"],
		[
			"twe" => "https://twitter.com/YuYuan9790",
			"yt" => "https://www.youtube.com/channel/UCqlj5y4mJfpzK1LaLWuUP-g"
		],
		[
			"twe" => "https://twitter.com/cana7167",
			"yt" => "https://www.youtube.com/channel/UCTofe2jTY6Q8vZJLj7E2R2A"
		],
		["twe" => "https://twitter.com/rin_tako22"]
	];
	var spe:Array<String> = ["Fade Revamped"];
	var spintro:Array<String> = ["English dialogue support"];
	var splinks:Array<Map<String, String>> = [["twe" => "https://twitter.com/FadeRevamped"]];
	var spcolors:Array<Int> = [0xFFffdf72];

	var curSelected = 0;

	var curlink = 0;

	var bg:FlxSprite;
	var intendedColor:Int = 0xFFffffff;
	var colorTween:FlxTween;

	var texts:FlxTypedGroup<Alphabet>;
	var icons:FlxTypedGroup<FlxSprite>;
	var sites:Array<FlxSprite> = [];
	var intro:FlxText;

	var linklist:Array<String> = ["per", "twe", "yt", "sc", "pat", "ng"];
	var sitelist:Array<String>;

	override function load()
	{
		LoadingState.progress = 100;
		super.load();
	}

	override function create()
	{
		bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		bg.color = 0xFFffffff;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);

		texts = new FlxTypedGroup<Alphabet>();
		add(texts);
		icons = new FlxTypedGroup<FlxSprite>();
		add(icons);

		var love:Int = 0;
		for (i in 0...ppl.length)
		{
			var guy:Alphabet = new Alphabet(50, (100 * i) + (FlxG.height * 0.48), ppl[i], false, false, true);
			guy.isOption = true;
			guy.targetY = i;
			texts.add(guy);
			var ni:FlxSprite = new FlxSprite(guy.sumwidth + 60, (100 * i) + (FlxG.height * 0.48)).loadGraphic(Paths.image('creatoricon/' + ppl[i]));
			ni.antialiasing = true;
			ni.setGraphicSize(95, 95);
			ni.updateHitbox();
			icons.add(ni);
			love += 1;
		}
		var spt:Alphabet = new Alphabet(50, (100 * love) + (FlxG.height * 0.48), "Special thanks", true, false, true);
		spt.isOption = true;
		spt.targetY = love;
		texts.add(spt);
		var none:FlxSprite = new FlxSprite(0, 0).makeGraphic(0, 0);
		icons.add(none);
		love += 1;
		for (i in 0...spe.length)
		{
			var guy:Alphabet = new Alphabet(50, (100 * love) + (FlxG.height * 0.48), spe[i], false, false, true);
			guy.isOption = true;
			guy.targetY = love;
			texts.add(guy);
			var ni:FlxSprite = new FlxSprite(guy.sumwidth + 60, (100 * love) + (FlxG.height * 0.48)).loadGraphic(Paths.image('creatoricon/' + spe[i]));
			ni.antialiasing = true;
			ni.setGraphicSize(95, 95);
			ni.updateHitbox();
			icons.add(ni);
			love += 1;
		}

		intro = new FlxText(FlxG.width * 0.75 - 250, 200, 500, "", 32);
		intro.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		add(intro);

		changeSelection(0);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			MainMenuState.optioned = true;
			MainMenuState.storied = true;
			LoadingState.loadAndSwitchState(new MainMenuState(), false, 1);
		}

		var bruh:Int = 0;
		var brighter:Int = -1;
		var enter:Bool = false;
		for (item in texts.members)
		{
			if (FlxG.mouse.screenX > item.x
				&& FlxG.mouse.screenX < item.x + item.width
				&& FlxG.mouse.screenY > item.y
				&& FlxG.mouse.screenY < item.y + item.height
				&& MusicBeatState.mouseA
				&& bruh != ppl.length)
			{
				brighter = bruh;
				if (FlxG.mouse.justPressed)
				{
					changeSelection(bruh - curSelected);
				}
			}
			bruh += 1;
		}
		bruh = 0;
		for (item in texts.members)
		{
			if (item.alpha != 1 && bruh == brighter)
			{
				item.alpha = 0.9;
				for (i in 0...item.children.length)
					item.children[i].alpha = 0.8;
			}
			else if (item.alpha != 1)
			{
				item.alpha = 0.6;
				for (i in 0...item.children.length)
					item.children[i].alpha = 0.6;
			}
			bruh += 1;
		}

		if (controls.UP_UI || FlxG.mouse.wheel > 0)
			changeSelection(-1);
		if (controls.DOWN_UI || FlxG.mouse.wheel < 0)
			changeSelection(1);

		bruh = 0;
		for (item in sites)
		{
			if (FlxG.mouse.screenX > item.x
				&& FlxG.mouse.screenX < item.x + item.width
				&& FlxG.mouse.screenY > item.y
				&& FlxG.mouse.screenY < item.y + item.height
				&& MusicBeatState.mouseA)
			{
				item.alpha = 1;
				if (FlxG.mouse.justPressed)
				{
					enterLink(bruh);
				}
			}
			else if (bruh == curlink)
			{
				item.alpha = 0.8;
			}
			else
			{
				item.alpha = 0.4;
			}
			bruh += 1;
		}

		if (controls.LEFT_UI)
		{
			FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
			curlink -= 1;
			if (curlink < 0)
			{
				curlink = sites.length - 1;
			}
		}
		if (controls.RIGHT_UI)
		{
			FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);
			curlink += 1;
			if (curlink >= sites.length)
			{
				curlink = 0;
			}
		}
		if (controls.ACCEPT)
			enterLink(curlink);

		super.update(elapsed);

		for (i in 0...texts.members.length)
		{
			icons.members[i].y = texts.members[i].y - 5;
			icons.members[i].alpha = texts.members[i].alpha;
		}
	}

	function enterLink(num:Int)
	{
		if (curSelected > ppl.length)
		{
			#if linux
			Sys.command('/usr/bin/xdg-open', [splinks[curSelected - ppl.length - 1].get(sitelist[num]), "&"]);
			#else
			FlxG.openURL(splinks[curSelected - ppl.length - 1].get(sitelist[num]));
			#end
		}
		else
		{
			#if linux
			Sys.command('/usr/bin/xdg-open', [links[curSelected].get(sitelist[num]), "&"]);
			#else
			FlxG.openURL(links[curSelected].get(sitelist[num]));
			#end
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = texts.length - 1;
		if (curSelected >= texts.length)
			curSelected = 0;

		if (curSelected == ppl.length)
			curSelected += change > 0 ? 1 : -1;

		var map:Map<String, String> = [];
		if (curSelected > ppl.length)
		{
			intro.text = spintro[curSelected - ppl.length - 1];
			map = splinks[curSelected - ppl.length - 1];
			intendedColor = spcolors[curSelected - ppl.length - 1];
		}
		else
		{
			intro.text = intros[curSelected];
			map = links[curSelected];
			intendedColor = colors[curSelected];
		}

		for (i in sites)
		{
			i.kill();
			remove(i);
			i.destroy();
		}
		sites = [];
		sitelist = [];
		curlink = 0;

		if (colorTween != null)
		{
			colorTween.cancel();
		}
		colorTween = FlxTween.color(bg, 1, bg.color + 0xFF000000, intendedColor, {
			onComplete: function(twn:FlxTween)
			{
				colorTween = null;
			}
		});

		for (i in linklist)
		{
			if (map.exists(i))
			{
				sitelist.push(i);
			}
		}
		for (i in linklist)
		{
			if (map.exists(i))
			{
				var all = Math.floor(sites.length / 4) == Math.floor(sitelist.length / 4) ? sitelist.length % 4 : 4;
				if (all == 0)
					all = 4;
				var ns:FlxSprite = new FlxSprite(FlxG.width * 0.75
					- 30
					+ 80 * (sites.length % 4 - (all - 1) / 2),
					FlxG.height / 2
					- 30
					+ 80 * Math.floor(sites.length / 4));
				ns.antialiasing = true;
				ns.loadGraphic(Paths.image('websites/' + i));
				ns.setGraphicSize(60, 60);
				ns.updateHitbox();
				add(ns);
				sites.push(ns);
			}
		}

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in texts.members)
		{
			item.targetY = bullShit - curSelected;

			item.alpha = 0.6;

			bullShit++;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0 || bullShit == ppl.length + 1)
			{
				item.alpha = 1;
				for (i in 0...item.children.length)
					item.children[i].alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
