package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();

		if (!PlayState.isStoryMode)
		{
			if (!PlayState.practice)
				menuItems = ['Resume', 'Restart Song', 'Practice Mode', 'Exit to menu'];
			else
				menuItems = ['Resume', 'Restart Song', 'End Practice', 'Exit to menu'];
		}

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.music.pause();

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_UI;
		var downP = controls.DOWN_UI;
		var accepted = controls.ACCEPT;

		if (upP || FlxG.mouse.wheel > 0)
		{
			changeSelection(-1);
		}
		if (downP || FlxG.mouse.wheel < 0)
		{
			changeSelection(1);
		}

		var bruh:Int = 0;
		var brighter:Int = -1;
		for (item in grpMenuShit.members)
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
						accepted = true;
					else
						changeSelection(bruh - curSelected);
				}
			}
			bruh += 1;
		}
		var bruh = 0;
		for (item in grpMenuShit.members)
		{
			if (item.alpha != 1 && bruh == brighter)
				item.alpha = 0.8;
			else if (item.alpha != 1)
				item.alpha = 0.6;
			bruh += 1;
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					if (PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
						PlayWindow.reset();
					close();
				case "Restart Song":
					LoadingState.loadAndSwitchState(new PlayState(), true);
				case "Practice Mode":
					PlayState.practice = true;
					close();
				case "End Practice":
					PlayState.practice = false;
					LoadingState.loadAndSwitchState(new PlayState(), true);
				case "Exit to menu":
					PlayState.skipStory = false;
					PlayState.practice = false;
					if (PlayState.isStoryMode)
						LoadingState.loadAndSwitchState(new StoryMenuState(), true);
					else
						LoadingState.loadAndSwitchState(new FreeplayState(), true);
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
