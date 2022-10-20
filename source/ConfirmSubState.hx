package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class ConfirmSubState extends MusicBeatSubstate
{
	public static var inconfirm:Bool = false;

	public var yesThing:Void->Void;
	public var noThing:Void->Void;

	var black:FlxSprite;
	var bg:FlxSprite;
	var text:FlxText;
	var yes:FlxSprite;
	var no:FlxSprite;

	var selected:Bool;

	var finished:Bool = false;
	var killing:Bool = false;

	public function new(text:String, yesThing:Void->Void, selected:Bool = false, noThing:Void->Void = null)
	{
		super();
		this.yesThing = yesThing;
		this.noThing = noThing;
		this.selected = selected;

		if (this.noThing == null)
		{
			this.noThing = function() {};
		}

		black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		black.alpha = 0;
		black.scrollFactor.set();
		add(black);

		var adder:String = "";
		switch (FlxG.save.data.lang)
		{
			case 1:
				adder = "Ch";
		}

		yes = new FlxSprite(FlxG.width / 2 - 100, FlxG.height / 2 - 100).loadGraphic(Paths.image('areyousure/Yes' + adder));
		yes.alpha = 0;
		yes.scrollFactor.set();
		add(yes);

		no = new FlxSprite(FlxG.width / 2 - 100, FlxG.height / 2 - 100).loadGraphic(Paths.image('areyousure/No' + adder));
		no.alpha = 0;
		no.scrollFactor.set();
		add(no);

		bg = new FlxSprite(FlxG.width / 2 - 250, FlxG.height / 2 - 250).loadGraphic(Paths.image('areyousure/bg'));
		bg.scale.set(0, 0);
		bg.scrollFactor.set();
		add(bg);

		this.text = new FlxText(FlxG.width / 2 - 225, FlxG.height / 2, 450, text);
		this.text.setFormat("Taipei Sans TC Beta Bold", 48, 0xFF4e0080, FlxTextAlign.CENTER);
		this.text.updateHitbox();
		this.text.y = (FlxG.height - this.text.height) / 2;
		this.text.alpha = 0;
		this.text.scrollFactor.set();
		add(this.text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (killing)
		{
			if (yes.x > FlxG.width / 2 + 50)
			{
				yes.x = FlxMath.lerp(yes.x, FlxG.width / 2 - 100, 0.4);
				no.x = FlxMath.lerp(no.x, FlxG.width / 2 - 100, 0.4);
			}
			else if (bg.scale.x > 0)
			{
				yes.alpha = 0;
				no.alpha = 0;
				text.alpha = 0;
				var s:Float = bg.scale.x;
				s -= 0.1;
				if (s < 0)
					s = 0;
				bg.scale.set(s, s);
			}
			else if (black.alpha > 0)
			{
				black.alpha -= 0.05;
			}
			else
			{
				inconfirm = false;
				close();
			}
		}
		else if (finished)
		{
			yes.alpha = 1;
			no.alpha = 1;
			text.alpha = 1;
			yes.x = FlxMath.lerp(yes.x, FlxG.width * 0.8 - 100, 0.4);
			no.x = FlxMath.lerp(no.x, FlxG.width / 5 - 100, 0.4);

			if (selected)
			{
				yes.color = 0xCCCCCC;
				no.color = 0x999999;
				if (controls.ACCEPT)
				{
					yesThing();
					killing = true;
					return;
				}
			}
			else
			{
				yes.color = 0x999999;
				no.color = 0xCCCCCC;
				if (controls.ACCEPT)
				{
					noThing();
					killing = true;
					return;
				}
			}

			if (FlxG.mouse.screenX > yes.x
				&& FlxG.mouse.screenX < yes.x + yes.width
				&& FlxG.mouse.screenY > yes.y
				&& FlxG.mouse.screenY < yes.y + yes.height
				&& MusicBeatState.mouseA)
			{
				yes.color = 0xFFFFFF;
				if (FlxG.mouse.justPressed)
				{
					yesThing();
					killing = true;
					return;
				}
			}

			if (FlxG.mouse.screenX > no.x
				&& FlxG.mouse.screenX < no.x + no.width
				&& FlxG.mouse.screenY > no.y
				&& FlxG.mouse.screenY < no.y + no.height
				&& MusicBeatState.mouseA)
			{
				no.color = 0xFFFFFF;
				if (FlxG.mouse.justPressed)
				{
					killing = true;
					return;
				}
			}

			if (controls.LEFT_UI || controls.RIGHT_UI)
			{
				selected = !selected;
			}

			if (controls.BACK)
				killing = true;
		}
		else
		{
			inconfirm = true;
			if (black.alpha < 0.8)
			{
				black.alpha += 0.05;
				if (black.alpha > 0.8)
					black.alpha = 0.8;
			}
			else if (bg.scale.x < 1)
			{
				var s:Float = bg.scale.x;
				s += 0.1;
				if (s > 1)
					s = 1;
				bg.scale.set(s, s);
			}
			else
			{
				finished = true;
			}
		}
	}
}
