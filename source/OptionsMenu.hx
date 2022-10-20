package;

import Controls.Control;
import Options;
import flash.text.TextField;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.api.FlxGameJolt;
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

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory> = [];

	public var acceptInput:Bool = true;

	private var grpControls:FlxTypedGroup<Alphabet>;
	private var grpChildren:FlxTypedGroup<FlxBasic>;
	var currentSelectedCat:OptionCategory;

	var holdt:Array<Float> = [0, 0];

	override function load()
	{
		options.push(new OptionCategory("Preferences", [
			new DownscrollOption("Toggle making the notes scroll down rather than up."),
			new SplashOption("enble/disable notesplashes when hitting sick."),
			new ProgressOption("Actully words here will not be shown"),
			new LangOption("Language, will be applied to tittle, UI, dialogue, etc"),
			new MouseOption("The skin of the mouse"),
			new FPSOption("Actully words here will not be shown"),
			new ShowFPSOption("Actully words here will not be shown")
		]));
		LoadingState.progress = 25;
		options.push(new OptionCategory("Controls", [new DFJKOption(controls), new UIKeyOption(controls)]));
		LoadingState.progress += 25;
		options.push(new OptionCategory("Account", [new AccountOption("account")]));
		if (FlxGameJolt.initialized)
		{
			options[2].addOption(new DataOption("bruh"));
			options[2].addOption(new AutoSyncOption("bruh"));
		}
		LoadingState.progress += 25;
		options.push(new OptionCategory("Exit", []));
		LoadingState.progress += 25;
		super.load();
	}

	override function create()
	{
		// clean();
		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = FlxG.save.data.antialiasing;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		grpChildren = new FlxTypedGroup<FlxBasic>();
		add(grpControls);
		add(grpChildren);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(50, (100 * i) + (FlxG.height * 0.48), options[i].getName(), true, false, true);
			controlLabel.isOption = true;
			controlLabel.targetY = i;
			controlLabel.x = (FlxG.width - controlLabel.sumwidth) / 2;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		changeSelection();

		super.create();
	}

	var isCat:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK && !isCat)
			{
				MainMenuState.optioned = true;
				MainMenuState.storied = true;
				LoadingState.loadAndSwitchState(new MainMenuState(), false, 1);
			}
			else if (controls.BACK)
			{
				isCat = false;
				grpControls.clear();
				grpChildren.clear();
				for (i in 0...options.length)
				{
					var controlLabel:Alphabet = new Alphabet(50, (100 * i) + (FlxG.height * 0.48), options[i].getName(), true, false);
					controlLabel.isOption = true;
					controlLabel.targetY = i;
					controlLabel.x = (FlxG.width - controlLabel.sumwidth) / 2;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}

				curSelected = 0;

				changeSelection(curSelected);
			}

			if (controls.UP_UI || FlxG.mouse.wheel > 0)
				changeSelection(-1);
			if (controls.DOWN_UI || FlxG.mouse.wheel < 0)
				changeSelection(1);

			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (controls.RIGHT_UI)
					{
						if (currentSelectedCat.getOptions()[curSelected].right())
						{
							grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
							for (i in 0...grpControls.members[curSelected].children.length)
								grpControls.members[curSelected].children[i].reType(currentSelectedCat.getOptions()[curSelected].getDisplay2()[i]);
							trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
						}
					}
					if (controls.LEFT_UI)
					{
						if (currentSelectedCat.getOptions()[curSelected].left())
						{
							grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
							for (i in 0...grpControls.members[curSelected].children.length)
								grpControls.members[curSelected].children[i].reType(currentSelectedCat.getOptions()[curSelected].getDisplay2()[i]);
							trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
						}
					}
					if (controls.LEFT_UI_H)
					{
						holdt[0] += elapsed;
						if (holdt[0] >= 0.53)
						{
							if (currentSelectedCat.getOptions()[curSelected].left())
							{
								grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
								for (i in 0...grpControls.members[curSelected].children.length)
									grpControls.members[curSelected].children[i].reType(currentSelectedCat.getOptions()[curSelected].getDisplay2()[i]);
							}
							holdt[0] = 0.5;
						}
					}
					else
						holdt[0] = 0;
					if (controls.RIGHT_UI_H)
					{
						holdt[1] += elapsed;
						if (holdt[1] >= 0.53)
						{
							if (currentSelectedCat.getOptions()[curSelected].right())
							{
								grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
								for (i in 0...grpControls.members[curSelected].children.length)
									grpControls.members[curSelected].children[i].reType(currentSelectedCat.getOptions()[curSelected].getDisplay2()[i]);
							}
							holdt[1] = 0.5;
						}
					}
					else
						holdt[1] = 0;
				}
			}

			var bruh:Int = 0;
			var brighter:Int = -1;
			var enter:Bool = false;
			for (item in grpControls.members)
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
							enter = true;
						else
							changeSelection(bruh - curSelected);
					}
				}
				bruh += 1;
			}
			var bruh = 0;
			for (item in grpControls.members)
			{
				if (item.alpha != 1 && bruh == brighter)
				{
					item.alpha = 0.8;
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

			if (controls.ACCEPT || enter)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press())
					{
						grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
						if (currentSelectedCat.getOptions()[curSelected].hascheckbox)
							grpControls.members[curSelected].checkbox.animation.play(currentSelectedCat.getOptions()[curSelected].updateCheck() ? "check" : "uncheck");
						for (i in 0...grpControls.members[curSelected].children.length)
							grpControls.members[curSelected].children[i].reType(currentSelectedCat.getOptions()[curSelected].getDisplay2()[i]);
						trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					grpChildren.clear();
					if (currentSelectedCat.getName() == "Exit")
					{
						MainMenuState.optioned = true;
						MainMenuState.storied = true;
						FlxTransitionableState.skipNextTransIn = true;
						FlxG.switchState(new MainMenuState());
					}
					else
					{
						for (i in 0...currentSelectedCat.getOptions().length)
						{
							var ox:Float = currentSelectedCat.getOptions()[i].hascheckbox ? 130 : 50;
							var controlLabel:Alphabet = new Alphabet(ox, (100 * i) + (FlxG.height * 0.48), currentSelectedCat.getOptions()[i].getDisplay(),
								true, false);
							controlLabel.isOption = true;
							controlLabel.targetY = i;
							grpControls.add(controlLabel);
							if (currentSelectedCat.getOptions()[i].hascheckbox)
							{
								var cb = new FlxSprite(25, (100 * i) + (FlxG.height * 0.48) - 15);
								cb.frames = Paths.getSparrowAtlas('checkbox');
								cb.animation.addByPrefix('none', 'checkbox0', 24, false);
								cb.animation.addByPrefix('check', 'checkbox anim0', 24, false);
								cb.animation.addByPrefix('uncheck', 'checkbox anim reverse', 24, false);
								cb.animation.addByPrefix('finish', 'checkbox finish', 24, false);
								cb.animation.play("none");
								cb.antialiasing = true;
								cb.setGraphicSize(0, 70);
								cb.updateHitbox();
								cb.animation.play(currentSelectedCat.getOptions()[i].updateCheck() ? "finish" : "none");
								grpChildren.add(cb);
								controlLabel.checkbox = cb;
							}
							var sx = controlLabel.x + controlLabel.sumwidth + 60;
							for (j in 0...currentSelectedCat.getOptions()[i].getDisplay2().length)
							{
								var child:Alphabet = new Alphabet(sx, (100 * i) + (FlxG.height * 0.48), currentSelectedCat.getOptions()[i].getDisplay2()[j],
									false, false);
								child.isOption = true;
								child.targetY = i;
								grpChildren.add(child);
								controlLabel.children.push(child);
								sx += child.sumwidth + 60;
							}
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
						curSelected = 0;
					}
				}

				changeSelection();
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	public function updateAccount()
	{
		options[2].addOption(new DataOption("bruh"));
		options[2].addOption(new AutoSyncOption("bruh"));

		currentSelectedCat = options[2];
		isCat = true;
		grpControls.clear();
		grpChildren.clear();
		for (i in 0...currentSelectedCat.getOptions().length)
		{
			var ox:Float = currentSelectedCat.getOptions()[i].hascheckbox ? 130 : 50;
			var controlLabel:Alphabet = new Alphabet(ox, (100 * i) + (FlxG.height * 0.48), currentSelectedCat.getOptions()[i].getDisplay(), true, false);
			controlLabel.isOption = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			if (currentSelectedCat.getOptions()[i].hascheckbox)
			{
				var cb = new FlxSprite(25, (100 * i) + (FlxG.height * 0.48) - 15);
				cb.frames = Paths.getSparrowAtlas('checkbox');
				cb.animation.addByPrefix('none', 'checkbox0', 24, false);
				cb.animation.addByPrefix('check', 'checkbox anim0', 24, false);
				cb.animation.addByPrefix('uncheck', 'checkbox anim reverse', 24, false);
				cb.animation.addByPrefix('finish', 'checkbox finish', 24, false);
				cb.animation.play("none");
				cb.antialiasing = true;
				cb.setGraphicSize(0, 70);
				cb.updateHitbox();
				cb.animation.play(currentSelectedCat.getOptions()[i].updateCheck() ? "finish" : "none");
				grpChildren.add(cb);
				controlLabel.checkbox = cb;
			}
			var sx = controlLabel.x + controlLabel.sumwidth + 60;
			for (j in 0...currentSelectedCat.getOptions()[i].getDisplay2().length)
			{
				var child:Alphabet = new Alphabet(sx, (100 * i) + (FlxG.height * 0.48), currentSelectedCat.getOptions()[i].getDisplay2()[j], false, false);
				child.isOption = true;
				child.targetY = i;
				grpChildren.add(child);
				controlLabel.children.push(child);
				sx += child.sumwidth + 60;
			}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		curSelected = 0;

		var welcome = new Welcome();
		add(welcome);
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		holdt = [0, 0];

		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;

			item.alpha = 0.6;
			for (i in 0...item.children.length)
			{
				item.children[i].targetY = bullShit - curSelected;
				item.children[i].alpha = 0.6;
			}

			bullShit++;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				for (i in 0...item.children.length)
					item.children[i].alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
