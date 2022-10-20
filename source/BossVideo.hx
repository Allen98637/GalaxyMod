package;

import flixel.FlxG;
import openfl.events.Event;
import src.VideoHandler;

class BossVideo extends VideoHandler
{
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function update(?E:Event):Void
	{
		isPlaying = libvlc.isPlaying();
		if (canSkip && controls.ACCEPT && initComplete)
		{
			FlxG.sound.music.stop();
			onVLCComplete();
		}

		if (FlxG.sound.muted || FlxG.sound.volume <= 0)
			volume = 0;
		else if (canUseSound)
			volume = FlxG.sound.volume;
	}
}
