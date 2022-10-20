package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var textfinished:Bool = false;

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;
	public var unfinish:Void->Void;
	public var screenThing:Void->Void;
	public var outro:Bool = true;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var num:Int;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>, num:Int = 0, willplay:Int = -1)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'cona':
				if (num == 0 && PlayState.isStoryMode && !PlayState.skipStory)
				{
					FlxG.sound.playMusic(Paths.music('spaceship'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			case "familanna":
				if (num == 0)
				{
					if (!PlayState.skipStory)
					{
						FlxG.sound.playMusic(Paths.music('spaceship'), 0);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					}
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('sleeptime'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			default:
				if (willplay == -1)
					willplay = (PlayState.isStoryMode && !PlayState.skipStory) ? 1 : 0;
				if (dialogueList[0].split(":")[1] == "MUSIC")
				{
					if (willplay == 1)
					{
						FlxG.sound.playMusic(Paths.music(dialogueList[0].split(":")[2]), 0);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					}
					dialogueList.remove(dialogueList[0]);
				}
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.4;
			if (bgFade.alpha > 0.4)
				bgFade.alpha = 0.4;
		}, 5);

		box = new FlxSprite(-20, 45);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			default:
				hasDialog = true;
				box = new FlxSprite(-20, 380);
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'Speech Bubble Normal Open', [11], "", 24);
				box.antialiasing = true;
		}

		this.dialogueList = dialogueList;
		this.num = num;

		if (!hasDialog)
			return;

		portraitLeft = new FlxSprite(-20, 40);
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			case 'galaxy' | 'game' | 'kastimagina' | 'familanna' | 'cona' | 'underworld' | 'cyber':
				portraitLeft.frames = Paths.getSparrowAtlas('kap');
				portraitLeft.animation.addByPrefix('enter', 'kashow', 24, false);
				portraitLeft.animation.addByPrefix('nomic', 'kashon', 24, false);
				portraitLeft.animation.addByPrefix('sad', 'kasad', 24, false);
				portraitLeft.animation.addByPrefix('bor', 'kabor', 24, false);
				portraitLeft.animation.addByPrefix('kalisa', 'kalisa', 24, false);
				portraitLeft.animation.addByPrefix('fami', 'fami0', 24, false);
				portraitLeft.animation.addByPrefix('famiang', 'famiang', 24, false);
				portraitLeft.animation.addByPrefix('famitir', 'famitir', 24, false);
				portraitLeft.antialiasing = true;
			default:
				portraitLeft.frames = Paths.getSparrowAtlas('bubbles_left');
				// portraitLeft.animation.addByPrefix('enter', 'kasti', 24, false);
				portraitLeft.animation.addByPrefix('fami', 'familanna', 24, false);
				portraitLeft.animation.addByPrefix('famiscreen', 'famiscreen', 24, false);
				portraitLeft.animation.addByPrefix('famiserious', 'famiserious', 24, false);
				portraitLeft.animation.addByPrefix('famishock', 'famishock', 24, false);
				portraitLeft.animation.addByPrefix('kalisa', 'kalisa', 24, false);
				portraitLeft.animation.addByPrefix('rara', 'rara0', 24, false);
				portraitLeft.animation.addByPrefix('raramiko', 'raramiko0', 24, false);
				portraitLeft.animation.addByPrefix('raramikoshock', 'raramikoshock', 24, false);
				portraitLeft.animation.addByPrefix('unknown', 'unknown', 24, false);
				portraitLeft.antialiasing = true;
		}
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			case 'galaxy' | 'game' | 'kastimagina' | 'familanna' | 'cona' | 'underworld' | 'cyber':
				portraitRight.frames = Paths.getSparrowAtlas('bfp');
				portraitRight.animation.addByPrefix('enter', 'show', 24, false);
				portraitRight.animation.addByPrefix('gf', 'GF', 24, false);
				portraitRight.animation.addByPrefix('kasti', 'karight', 24, false);
				portraitRight.antialiasing = true;
			default:
				portraitRight.frames = Paths.getSparrowAtlas('bubbles_right');
				portraitRight.animation.addByPrefix('enter', 'bf0', 24, false);
				portraitRight.animation.addByPrefix('bfspace', 'bfspace0', 24, false);
				portraitRight.animation.addByPrefix('bfspacesad', 'bfspacesad', 24, false);
				portraitRight.animation.addByPrefix('bfspaceoh', 'bfspaceoh', 24, false);
				portraitRight.animation.addByPrefix('fami', 'famiright', 24, false);
				portraitRight.animation.addByPrefix('gf', 'gf0', 24, false);
				portraitRight.animation.addByPrefix('gfspace', 'gfspace', 24, false);
				portraitRight.animation.addByPrefix('kasti', 'kastiright', 24, false);
				portraitRight.animation.addByPrefix('kastiserious', 'kastiserious', 24, false);
				portraitRight.animation.addByPrefix('kastithink', 'kastithink', 24, false);
				portraitRight.animation.addByPrefix('kastishocked', 'kastishocked', 24, false);
				portraitRight.animation.addByPrefix('kastispace', 'kastispacenormal', 24, false);
				portraitRight.animation.addByPrefix('kastispaceo', 'kastispaceo', 24, false);
				portraitRight.animation.addByPrefix('kastispaceserious', 'kastispaceserioous', 24, false);
				portraitRight.antialiasing = true;
		}
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				add(handSelect);
		}

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		if (PlayState.SONG.song.toLowerCase() == 'senpai'
			|| PlayState.SONG.song.toLowerCase() == 'roses'
			|| PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			dropText.font = 'Pixel Arial 11 Bold';
		}
		else
		{
			if (FlxG.save.data.lang == 1)
				dropText.font = 'Taipei Sans TC Beta Bold';
			else
				dropText.font = 'VCR OSD Mono';
		}
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		if (PlayState.SONG.song.toLowerCase() == 'senpai'
			|| PlayState.SONG.song.toLowerCase() == 'roses'
			|| PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			swagDialogue.font = 'Pixel Arial 11 Bold';
		}
		else
		{
			if (FlxG.save.data.lang == 1)
				swagDialogue.font = 'Taipei Sans TC Beta Bold';
			else
				swagDialogue.font = 'VCR OSD Mono';
		}
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);

			if (!textfinished)
			{
				swagDialogue.skip();
				textfinished = true;
			}
			else if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai'
						|| PlayState.SONG.song.toLowerCase() == 'thorns'
						|| (PlayState.SONG.song.toLowerCase() == 'cona' && num == 0)
						|| (PlayState.SONG.song.toLowerCase() == 'familanna' && num == 0)
						|| PlayState.SONG.song.toLowerCase() == 'newton'
						|| PlayState.SONG.song.toLowerCase() == 'destiny')
						FlxG.sound.music.fadeOut(2.2, 0);

					if (outro)
					{
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitRight.visible = false;
							swagDialogue.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);
					}

					new FlxTimer().start(outro ? 1.2 : 0, function(tmr:FlxTimer)
					{
						if ((PlayState.SONG.song.toLowerCase() == 'cona' && num == 0) || PlayState.SONG.song.toLowerCase() == 'cyber')
							unfinish();
						else
							finishThing();
						kill();
					});
				}
			}
			else
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		if (curCharacter != 'MUSIC' && curCharacter != 'SCREEN')
		{
			textfinished = false;
			swagDialogue.resetText(dialogueList[0]);
			swagDialogue.start(0.04, true, false, [], function end()
			{
				textfinished = true;
			});
		}

		switch (curCharacter)
		{
			case 'SCREEN':
				dialogueList.remove(dialogueList[0]);
				screenThing();
				startDialogue();
			case 'MUSIC':
				if (dialogueList[0] == "")
				{
					FlxG.sound.music.stop();
					FlxG.sound.music.volume = 0;
				}
				else
					FlxG.sound.playMusic(Paths.music(dialogueList[0]), 0.8);
				dialogueList.remove(dialogueList[0]);
				startDialogue();

			case 'none':
				portraitRight.visible = false;
				portraitLeft.visible = false;

			case 'kasti':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'kastibore':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('bor');
			case 'kastisad':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('sad');
			case 'kastinomic':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('nomic');
			case 'kastiright':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('kasti');
			case 'kastiserious':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('kastiserious');
			case 'kastishock':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('kastishocked');
			case 'kastispace':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('kastispace');
			case 'kastispaceserious':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('kastispaceserious');
			case 'kastispaceo':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('kastispaceo');
			case 'kastithink':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('kastithink');

			case 'kalisa':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('kalisa');

			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}

			case 'bf':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			case 'bfspace':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('bfspace');
			case 'bfspacesad':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('bfspacesad');
			case 'bfspaceoh':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('bfspaceoh');

			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('gf');
			case 'gfspace':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('gfspace');

			case 'fami':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('fami');
			case 'famiright':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.animation.play('fami');
			case 'famiang':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('famiang');
			case 'famitir':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('famitir');
			case 'famiserious':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('famiserious');
			case 'famishock':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('famishock');
			case 'famiscreen':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('famiscreen');

			case 'rara':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('rara');
			case 'raramiko':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('raramiko');
			case 'raramikoshocked':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('raramikoshock');

			case 'unknown':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.animation.play('unknown');
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
