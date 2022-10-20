import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class LoadingState extends MusicBeatState
{
	var target:MusicBeatState;
	var bar:FlxBar;

	public static var progress:Int = 0;

	public var localProg:Int = 0;

	public static var allOfThem:Array<Dynamic> = [];

	var mode:Int;

	inline static public function loadAndSwitchState(_target:MusicBeatState, stopMusic = false, _mode:Int = 0)
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		if (_mode < 2)
			FlxG.switchState(new LoadingState(_target, _mode));
		else
		{
			_target.load();
			FlxG.switchState(_target);
		}
	}

	public function new(_target:MusicBeatState, _mode:Int = 0)
	{
		target = _target;
		mode = _mode;
		super();
	}

	var startLoad:Bool = false;

	var bg:FlxSprite;
	var text:FlxSprite;
	var ch1:FlxSprite;
	var ch2:FlxSprite;
	var ch3:FlxSprite;
	var funkay:FlxSprite;

	override function create()
	{
		Main.clearCache();
		progress = 0;
		localProg = 0;
		switch (mode)
		{
			case 0:
				bg = new FlxSprite(0, 0).loadGraphic(Paths.image('loadbg'));
				bg.antialiasing = true;
				bg.scrollFactor.set();
				add(bg);
				text = new FlxSprite(0, 0).loadGraphic(Paths.image('loadingtext'));
				text.antialiasing = true;
				text.scrollFactor.set();
				add(text);
				ch1 = new FlxSprite(0, 0).loadGraphic(Paths.image('loadingcom1'));
				ch1.antialiasing = true;
				ch1.scrollFactor.set();
				add(ch1);
				ch2 = new FlxSprite(0, 0).loadGraphic(Paths.image('loadingcom2'));
				ch2.antialiasing = true;
				ch2.scrollFactor.set();
				add(ch2);
				ch3 = new FlxSprite(0, 0).loadGraphic(Paths.image('loadingcom3'));
				ch3.antialiasing = true;
				ch3.scrollFactor.set();
				add(ch3);

				bar = new FlxBar(0, FlxG.height - 20, FlxBarFillDirection.HORIZONTAL_INSIDE_OUT, FlxG.width, 10, this, "localProg", 0, 100);
				bar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.fromRGB(255, 22, 210));
				bar.scrollFactor.set();
				add(bar);
			case 1:
				bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
				add(bg);
		}

		trace("lets do some loading " + bar);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!startLoad)
		{
			startLoad = true;

			#if PRELOAD_ALL
			sys.thread.Thread.create(() ->
			{
				killEveryone(members);
				target.load();
				target.loadedCompletely = true;
				switch (mode)
				{
					case 0:
						new FlxTimer().start(0.7, function(timer:FlxTimer)
						{
							FlxG.camera.fade(FlxG.camera.bgColor, 0.5, false, function()
							{
								FlxG.switchState(target);
							});
						});
					case 1:
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						new FlxTimer().start(0.7, function(timer:FlxTimer)
						{
							FlxG.switchState(target);
						});
					default:
						FlxG.switchState(target);
				}
			});
			#else
			target.load();
			target.loadedCompletely = true;
			switch (mode)
			{
				case 0:
					new FlxTimer().start(0.7, function(timer:FlxTimer)
					{
						FlxG.camera.fade(FlxG.camera.bgColor, 0.5, false, function()
						{
							FlxG.switchState(target);
						});
					});
				case 1:
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					new FlxTimer().start(0.7, function(timer:FlxTimer)
					{
						FlxG.switchState(target);
					});
				default:
					FlxG.switchState(target);
			}
			#end
		}
		localProg = progress;
		super.update(elapsed);

		switch (mode)
		{
			case 0:
				text.scale.x = FlxMath.lerp(text.scale.x, 1, 0.1);
				text.scale.y = FlxMath.lerp(text.scale.y, 1, 0.1);
				bg.scale.x = FlxMath.lerp(bg.scale.x, 1, 0.1);
				bg.scale.y = FlxMath.lerp(bg.scale.y, 1, 0.1);
				ch1.scale.x = FlxMath.lerp(ch1.scale.x, 1, 0.2);
				ch1.scale.y = FlxMath.lerp(ch1.scale.y, 1, 0.2);
				ch2.scale.x = FlxMath.lerp(ch2.scale.x, 1, 0.2);
				ch2.scale.y = FlxMath.lerp(ch2.scale.y, 1, 0.2);
				ch3.scale.x = FlxMath.lerp(ch3.scale.x, 1, 0.2);
				ch3.scale.y = FlxMath.lerp(ch3.scale.y, 1, 0.2);
				if (!StoryMenuState.weekPassed[1].contains(true))
					ch1.alpha = 0;
				if (!StoryMenuState.weekPassed[2].contains(true))
					ch2.alpha = 0;
				if (!StoryMenuState.weekPassed[3].contains(true))
					ch3.alpha = 0;
				if (controls.ACCEPT)
				{
					text.scale.x = 1.1;
					text.scale.y = 1.1;
					bg.scale.x = 1.05;
					bg.scale.y = 1.05;
					ch1.scale.x = 1.4;
					ch1.scale.y = 1.4;
					ch2.scale.x = 1.4;
					ch2.scale.y = 1.4;
					ch3.scale.x = 1.4;
					ch3.scale.y = 1.4;
				}
		}
	}

	static function killEveryone(ignore:Array<Dynamic>, kilload:Bool = false)
	{
		var stay:Array<Dynamic> = [];
		Note.refresh();
		NoteStrum.refresh();
		NoteSplash.refresh();
		for (object in allOfThem)
		{
			if (object != null)
			{
				if (ignore.contains(object) && !kilload)
				{
					stay.push(object);
				}
				else
				{
					if (Std.isOfType(object, FlxSprite))
					{
						var sprite:FlxSprite = object;
						FlxG.bitmap.remove(sprite.graphic);
					}
					if (Std.isOfType(object, FlxGraphic))
					{
						var graph:FlxGraphic = object;
						FlxG.bitmap.remove(graph);
					}
				}
			}
		}
		allOfThem = stay.copy();
	}
}
