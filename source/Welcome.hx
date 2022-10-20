package;

import flash.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.api.FlxGameJolt;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class Welcome extends FlxSpriteGroup
{
	var block:FlxSprite;
	var icon:FlxSprite;
	var tit:FlxText;
	var text:FlxText;
	var b2:FlxSprite;

	var time:Float = 0;

	var mode:Int = 0;
	var pars:Array<Dynamic>;

	var order:Int;

	public static var tropic:Map<Int, Array<Dynamic>> = [
		163724 => ["Let's Get Started!", 0xffCD7F32, "kastimagina"],
		163725 => ["Battle Cats?", 0xffCD7F32, "kalisa"],
		163726 => ["!*&#^&@&@", 0xffCD7F32, "unknown"],
		163771 => ["Galaxy Trip", 0xffC0C0C0, "kastimagina"],
		163772 => ["Game Master", 0xffC0C0C0, "kastimagina"],
		163777 => ["It's Fun!", 0xffFFD700, "kastimagina"],
		163773 => ["Planet of Battle Cats", 0xffC0C0C0, "kalisa"],
		163774 => ["冥界のXXカリファ", 0xffC0C0C0, "kalisa"],
		163778 => ["Cyber Academy", 0xffFFD700, "kalisa"],
		163775 => ["F = ma", 0xffC0C0C0, "unknown"],
		163776 => ["Song of Fate", 0xffC0C0C0, "unknown"],
		163779 => ["Hopes of Peace", 0xffFFD700, "unknown"],
		163727 => ["It's too easy", 0xffC0C0C0, "mathena"]
	];

	public function new(mode:Int = 0, par:Array<Dynamic> = null)
	{
		super();

		this.mode = mode;
		this.pars = par;

		block = new FlxSprite(FlxG.width - 400, -90).makeGraphic(400, 90, 0xff000000);
		block.alpha = 0.7;
		block.scrollFactor.set();
		add(block);

		b2 = new FlxSprite(FlxG.width - 390, -80).makeGraphic(70, 70, 0xffcdfe02);
		b2.scrollFactor.set();
		add(b2);

		tit = new FlxText(FlxG.width - 310, -80, 300, "Welcome", 30);
		if (FlxG.save.data.lang == 1)
			tit.text = "歡迎";
		tit.font = "Taipei Sans TC Beta Bold";
		tit.color = 0xffcdfe02;
		tit.alignment = "center";
		tit.antialiasing = true;
		add(tit);

		text = new FlxText(FlxG.width - 310, -45, 300, FlxG.save.data.userName, 30);
		text.font = "Taipei Sans TC Beta Bold";
		text.color = 0xFFffffff;
		text.alignment = "center";
		text.antialiasing = true;
		add(text);

		icon = new FlxSprite(FlxG.width - 385, -75);
		icon.antialiasing = true;
		icon.loadGraphic(Paths.image('gamejolt'));
		add(icon);
		if (mode == 0)
		{
			FlxGameJolt.fetchUser(0, FlxG.save.data.userName, [], function(k:Dynamic)
			{
				icon.loadGraphic(k.get("avatar_url"));
			});
		}

		if (mode == 1)
		{
			time = 5;
			order = -1;
			text.text = "Trophy Get!";
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!FlxGameJolt.initialized)
			return;
		switch (mode)
		{
			case 0:
				if (block.y < 0 && time < 3)
				{
					block.y += 5;
					b2.y += 5;
					tit.y += 5;
					text.y += 5;
					icon.y += 5;
				}
				else if (time < 3)
				{
					time += elapsed;
					block.y = 0;
					b2.y = 10;
					tit.y = 10;
					text.y = 45;
					icon.y = 15;
				}
				else
				{
					block.y -= 5;
					b2.y -= 5;
					tit.y -= 5;
					text.y -= 5;
					icon.y -= 5;
					if (block.y < -85)
						kill();
				}
			case 1:
				if (block.y < 0 && time < 3)
				{
					block.y += 5;
					b2.y += 5;
					tit.y += 5;
					text.y += 5;
					icon.y += 5;
				}
				else if (time < 3)
				{
					time += elapsed;
					block.y = 0;
					b2.y = 10;
					tit.y = 10;
					text.y = 45 + (30 - text.size) / 2;
					icon.y = 15;
				}
				else
				{
					block.y -= 5;
					b2.y -= 5;
					tit.y -= 5;
					text.y -= 5;
					icon.y -= 5;
					if (block.y < -85)
					{
						order += 1;
						time = 0;
						if (order == pars.length)
						{
							kill();
						}
						else
						{
							trophy(pars[order]);
						}
					}
				}
		}
	}

	private function trophy(daID:Int)
	{
		var bbb:Array<Dynamic> = tropic.get(daID);
		if (FlxG.save.data.lang == 1)
			tit.text = "獲得獎盃!";
		else
			tit.text = "Trophy Get!";
		text.text = bbb[0];
		text.size = 30;
		if (bbb[0].length > 18)
			text.size = 15;

		b2.makeGraphic(70, 70, bbb[1]);

		icon.loadGraphic(Paths.image('trophy/' + bbb[2]));
		icon.setGraphicSize(60, 60);
		icon.updateHitbox();
		icon.antialiasing = true;

		block.y = -90;
		b2.y = -80;
		tit.y = -80;
		text.y = -45 + (30 - text.size) / 2;
		icon.y = -75;
	}
}
