package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class ResultScreen extends FlxSpriteGroup
{
	var bgFade:FlxSprite;
	var numbers:FlxText;
	var song:FlxText;
	var newBest:FlxText;
	var acctxt:FlxText;
	var comtxt:FlxText;
	var sicktxt:FlxText;
	var goodtxt:FlxText;
	var badtxt:FlxText;
	var shittxt:FlxText;
	var misstxt:FlxText;
	var wrongtxt:FlxText;
	var chara:FlxSprite;
	var rating:FlxSprite;

	var lerpscore:Int = 0;
	var lerpacc:Float = 0;
	var lerpcom:Int = 0;

	var dascore:Int;
	var daacc:Float;
	var dacom:Int;
	var daBest:Int;

	var ended:Bool = false;

	var got:Welcome;

	public var end:Void->Void;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function new(character:String, score:Int, oldBest:Int, maxc:Int, acc:Float, sicks:Int, goods:Int, bads:Int, shits:Int, misses:Int, wrongs:Int)
	{
		super();

		dascore = score;
		daacc = acc;
		dacom = maxc;
		daBest = oldBest;

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF000000);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0.7;
		add(bgFade);

		numbers = new FlxText(550, 80, Std.int(FlxG.width * 0.6), "0", 120);
		numbers.font = "Jabba the Font";
		numbers.color = 0xFFffff00;
		numbers.alpha = 0;
		add(numbers);

		newBest = new FlxText(650, 195, Std.int(FlxG.width * 0.6), "0", 30);
		newBest.font = "VCR OSD Mono";
		newBest.color = 0xFFffff00;
		newBest.alpha = 0;
		add(newBest);

		chara = new FlxSprite(50, FlxG.height / 2 - 400).loadGraphic(Paths.image('characters/' + PlayState.SONG.player2));
		chara.scrollFactor.set();
		chara.alpha = 0;
		chara.antialiasing = true;
		add(chara);

		song = new FlxText(10, FlxG.height - 50, Std.int(FlxG.width * 0.6), PlayState.SONG.song + " (" + CoolUtil.difficultyString() + ")", 30);
		song.font = "Pixel Arial 11 Bold";
		song.alpha = 0;
		add(song);

		if (FlxG.save.data.lang == 1)
		{
			acctxt = new FlxText(550, 225, Std.int(FlxG.width * 0.6), "準確率:0%", 50);
			acctxt.font = "Taipei Sans TC Beta Bold";
		}
		else
		{
			acctxt = new FlxText(550, 225, Std.int(FlxG.width * 0.6), "Accuracy:0%", 50);
			acctxt.font = "Pixel Arial 11 Bold";
		}
		acctxt.alpha = 0;
		add(acctxt);

		if (FlxG.save.data.lang == 1)
		{
			comtxt = new FlxText(550, 315, Std.int(FlxG.width * 0.6), "最大連擊數:0", 40);
			comtxt.font = "Taipei Sans TC Beta Bold";
		}
		else
		{
			comtxt = new FlxText(550, 315, Std.int(FlxG.width * 0.6), "Max Combo:0", 40);
			comtxt.font = "Pixel Arial 11 Bold";
		}
		comtxt.alpha = 0;
		add(comtxt);

		rating = new FlxSprite(350, 0);
		rating.frames = Paths.getSparrowAtlas('rating');
		rating.animation.addByPrefix('FNF', 'FNF', 30, false);
		rating.animation.addByPrefix('S', 'S', 30, false);
		rating.animation.addByPrefix('A', 'A', 30, false);
		rating.animation.addByPrefix('B', 'B', 30, false);
		rating.animation.addByPrefix('C', 'C', 30, false);
		rating.animation.addByPrefix('D', 'D', 30, false);
		rating.antialiasing = true;
		rating.updateHitbox();
		rating.scrollFactor.set();
		add(rating);

		sicktxt = new FlxText(200, 650, Std.int(FlxG.width * 0.6), "Sick\n" + sicks + "\n", 30);
		sicktxt.font = "VCR OSD Mono";
		sicktxt.autoSize = false;
		sicktxt.alignment = "center";
		sicktxt.alpha = 0;
		add(sicktxt);
		goodtxt = new FlxText(350, 650, Std.int(FlxG.width * 0.6), "Good\n" + goods + "\n", 30);
		goodtxt.font = "VCR OSD Mono";
		goodtxt.alignment = "center";
		goodtxt.alpha = 0;
		add(goodtxt);
		badtxt = new FlxText(500, 650, Std.int(FlxG.width * 0.6), "Bad\n" + bads + "\n", 30);
		badtxt.font = "VCR OSD Mono";
		badtxt.alignment = "center";
		badtxt.alpha = 0;
		add(badtxt);
		shittxt = new FlxText(650, 650, Std.int(FlxG.width * 0.6), "Shit\n" + shits + "\n", 30);
		shittxt.font = "VCR OSD Mono";
		shittxt.alignment = "center";
		shittxt.alpha = 0;
		add(shittxt);
		misstxt = new FlxText(800, 650, Std.int(FlxG.width * 0.6), "Miss\n" + misses + "\n", 30);
		misstxt.font = "VCR OSD Mono";
		misstxt.alignment = "center";
		misstxt.alpha = 0;
		add(misstxt);
		if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			goodtxt.x = 320;
			badtxt.x = 440;
			shittxt.x = 560;
			misstxt.x = 680;
			wrongtxt = new FlxText(800, 650, Std.int(FlxG.width * 0.6), "Wrong\n" + wrongs + "\n", 30);
			wrongtxt.font = "VCR OSD Mono";
			wrongtxt.alignment = "center";
			wrongtxt.alpha = 0;
			add(wrongtxt);
		}
		FlxG.sound.playMusic(Paths.music('result'));
	}

	public function load()
	{
		if (FlxGameJolt.initialized)
		{
			var trop = new Welcome(1, Main.syncTrophy());
			add(trop);
		}
	}

	override function update(elapsed:Float)
	{
		lerpscore = Math.round(FlxMath.lerp(lerpscore, dascore, 0.2));
		lerpacc = Math.round(FlxMath.lerp(lerpacc, daacc, 0.2) * 100) / 100;
		lerpcom = Math.round(FlxMath.lerp(lerpcom, Math.abs(dacom), 0.2));
		if (Math.abs(lerpscore - dascore) < 5)
		{
			lerpscore = dascore;
			lerpacc = daacc;
			lerpcom = Math.floor(Math.abs(dacom));
		}
		numbers.text = "" + lerpscore;
		if (PlayState.practice)
			newBest.text = "";
		else
			newBest.text = (lerpscore > daBest ? "(NEW BEST " : "(HIGH SCORE ")
				+ daBest
				+ (lerpscore > daBest ? " +" : " ")
				+ (lerpscore - daBest)
				+ ")";
		newBest.alpha += 0.1;
		if (FlxG.save.data.lang == 1)
			acctxt.text = "準確率:" + lerpacc + "%";
		else
			acctxt.text = "Accuracy:" + lerpacc + "%";
		if (FlxG.save.data.lang == 1)
			comtxt.text = "最大連擊:" + lerpcom;
		else
			comtxt.text = "Max Combo:" + lerpcom;
		if (dacom < 0 && lerpcom == Math.abs(dacom))
		{
			comtxt.text += "(FC)";
			comtxt.color = 0xFFffff00;
		}

		numbers.alpha += 0.1;
		acctxt.alpha += 0.1;
		comtxt.alpha += 0.1;
		song.alpha += 0.1;
		chara.alpha += elapsed;
		if (chara.y < FlxG.height / 2 - 300)
			chara.y += 100 * elapsed;
		else
			chara.y = FlxG.height / 2 - 300;
		if (lerpscore == dascore)
		{
			if (rating.animation.curAnim == null)
			{
				if (daacc == 100)
					rating.animation.play("FNF");
				else if (daacc >= 95)
					rating.animation.play("S");
				else if (daacc >= 90)
					rating.animation.play("A");
				else if (daacc >= 80)
					rating.animation.play("B");
				else if (daacc >= 70)
					rating.animation.play("C");
				else
					rating.animation.play("D");
			}
			sicktxt.alpha += 0.05;
			goodtxt.alpha += 0.05;
			badtxt.alpha += 0.05;
			shittxt.alpha += 0.05;
			misstxt.alpha += 0.05;
			if (PlayState.SONG.song.toLowerCase() == "familanna")
			{
				wrongtxt.alpha += 0.05;
			}
			if ((controls.ACCEPT || controls.BACK) && !ended)
			{
				end();
				ended = true;
			}
		}

		super.update(elapsed);
	}
}
