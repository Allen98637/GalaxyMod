package;

import haxe.Exception;
import flixel.FlxSprite;
import Song.SwagSong;
import flixel.math.FlxMath;
import Std;
import flixel.FlxG;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class PlayMoving
{
    public static var sy:Float = 50;
    public static var xlist:Array<Float> = [50,162,274,386];
    public static var oxlist:Array<Float> = [50,162,274,386];
    public static var pxlist:Array<Float> = [690,802,914,1026];
    public static var poxlist:Array<Float> = [690,802,914,1026];
    public static var nlist:Array<Float> = [50,162,274,386];
    public static var pnlist:Array<Float> = [690,802,914,1026];
    public static var times:Float = 0;
    public static var temp:Float = 0;
    public static var ptemp:Float = 0;
    public static var ylist:Array<Float> = [50,50,50,50];
    public static var ns:String = "";
    public static var shinelist:Array<Float> = [45082.87292817678,46408.83977900551,47734.80662983424,49060.77348066297,49723.75690607733,
        50386.740331491696,51712.707182320424,53038.67403314915,54364.64088397788,55027.624309392246,
        55690.60773480661,57016.57458563534,58342.54143646407,59668.508287292796,60331.49171270716,60662.98342541434,
        60994.475138121525,62320.44198895025,63646.40883977898,64972.37569060771,65635.35911602208,65966.85082872926,135248.61878453035,
        136574.58563535908,137900.5524861878,139226.51933701654,139889.5027624309,140552.48618784526,141878.453038674,143204.41988950272,
        144530.38674033145,145193.37016574582,145856.35359116018,147182.3204419889,148508.28729281764,149834.25414364637,150497.23756906073,
        151160.2209944751,152486.18784530382,153812.15469613255,155138.12154696128,155801.10497237564
    ];
    public static var stage:Array<Int> = [0,0];

    public static function reset()
    {
        sy = 50;
        xlist = [50,162,274,386];
        pxlist = [690,802,914,1026];
        nlist = [50,162,274,386];
        pnlist = [690,802,914,1026];
        ylist = [50,50,50,50];
        times = 0;
        temp = 0;
        ptemp = 0;
        ns = "";
        stage = [Std.int(Capabilities.screenResolutionX),Std.int(Capabilities.screenResolutionY)];
    }
    //trace(Lib.current.stage.stageWidth);

    public static function pos(daNote:Note,strumLine:FlxSprite)
    {
        if(PlayState.SONG.song.toLowerCase() == "galaxy" && PlayState.storyDifficulty != 0)
        {
            if (    
                    (daNote.strumTime > 12387 && daNote.strumTime < 24581)||
                    (daNote.strumTime > 38709 && daNote.strumTime < 41613)||
                    (!daNote.isSustainNote && daNote.strumTime > 49548 && daNote.strumTime < 74232 && Std.int(FlxMath.roundDecimal((daNote.strumTime-49548.387096774226) / 193.548387097,0)) % 2 == 1)||
                    (Std.int(daNote.strumTime) == 81677 || Std.int(daNote.strumTime) == 83225)||
                    (daNote.strumTime > 84387 && daNote.strumTime < 84968)||
                    (daNote.strumTime > 85935 && daNote.strumTime < 86517)||
                    (daNote.strumTime > 99096 && daNote.strumTime < 111291)
                )
            {
                daNote.y =  (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(0.8, 2)));
            }
            else if (
                    (daNote.strumTime > 37161 && daNote.strumTime < 38517)||
                    (daNote.strumTime > 41806 && daNote.strumTime < 43162)
                )
            {
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(2, 2)));
            }
            else if (
                (daNote.strumTime > 43354 && daNote.strumTime < 49355)||
                (daNote.strumTime > 74322 && daNote.strumTime < 77226)||
                (daNote.strumTime > 77419 && daNote.strumTime < 78774 && !daNote.mustPress)||
                (daNote.strumTime > 78967 && daNote.strumTime < 80323 && daNote.mustPress)
            )
            {
                if (Conductor.songPosition >= daNote.strumTime)
                    daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else
                    daNote.y = (strumLine.y + (0.9 * (Conductor.songPosition - daNote.strumTime) * (Conductor.songPosition - daNote.strumTime) / 1000));
            }
            else 
            {
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
        {
            if (daNote.strumTime > 122553)
            {
                if (daNote.mustPress)
                    daNote.x = pxlist[daNote.noteData];
                else
                    daNote.x = xlist[daNote.noteData];
                if (daNote.isSustainNote)
                    daNote.x += daNote.width;
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(1.5, 2)));
                if(daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
                {
                    daNote.scale.y= 0.7 * Conductor.stepCrochet / 100 * 1.5 * 1.5;
                    daNote.updateHitbox();
                }
            }
            else if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
            {
                if (daNote.y >= strumLine.y || daNote.strumTime <= Conductor.songPosition)
                {
                    if (daNote.mustPress)
                        daNote.x = pxlist[daNote.noteData];
                    else
                        daNote.x = xlist[daNote.noteData];
                }
                else 
                {
                    if (daNote.mustPress)
                        daNote.x = pnlist[daNote.noteData];
                    else
                        daNote.x = nlist[daNote.noteData];
                }
                if (daNote.isSustainNote)
                    daNote.x += daNote.width;
                daNote.y = -75 + 775 * (((daNote.strumTime - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
                if(daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
                {
                    daNote.scale.y= 0.7 * Conductor.stepCrochet / 100 * 1.5 * 1;
                    daNote.updateHitbox();
                }
            }
            else if (daNote.strumTime > 44255 && daNote.strumTime < 47517)
            {
                if (2.7 + (2.7 / 1000) * (Conductor.songPosition - daNote.strumTime) > 0)
                    daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed*1.5, 2)) - (1.35 * 0.45 * (Conductor.songPosition - daNote.strumTime) * (Conductor.songPosition - daNote.strumTime) / 1000));
                else 
                    daNote.y = 1000;
            }
            else if (daNote.strumTime > 26382 && daNote.strumTime < 44114)
            {
                daNote.y = (sy - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(((300-sy)/250)*PlayState.SONG.speed, 2)));
            }
            else if (daNote.strumTime > 47659 && daNote.strumTime < 67944)
            {
                if (times == 1)
                {
                    if (daNote.mustPress)
                        daNote.x = pxlist[daNote.noteData];
                    else
                        daNote.x = xlist[daNote.noteData];
                    if (daNote.isSustainNote)
                        daNote.x += daNote.width;
                }
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
            {
                daNote.y = (ylist[daNote.noteData] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(((300-ylist[daNote.noteData])/250)*PlayState.SONG.speed, 2)));
            }
            else 
            {
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
        {
            if(
                (daNote.strumTime > 2652 && daNote.strumTime < 12929) ||
                (daNote.strumTime > 156465 && daNote.strumTime < 166741)
            )
            {
                if (daNote.mustPress)
                    daNote.x = pxlist[daNote.noteData];
                else
                    daNote.x = xlist[daNote.noteData];
                daNote.y = ylist[daNote.noteData];
                if(Conductor.songPosition > daNote.strumTime)
                    daNote.alpha = 0;
            }
            else if(
                (daNote.strumTime > 23867 && daNote.strumTime < 34393)
            )
            {
                if (daNote.noteData % 2 == 0)
                    daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else
                    daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(
                (daNote.strumTime > 34475 && daNote.strumTime < 45000)
            )
            {
                if (daNote.noteData % 2 == 1)
                    daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else
                    daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if (daNote.strumTime > 103425 && daNote.strumTime < 135166 && Conductor.songPosition < 124640.8839779005)
            {
                if (daNote.noteData == 2 || daNote.noteData == 1)
                    daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else
                    daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(daNote.strumTime > 13259 && daNote.strumTime < 23785)
            {
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                if (daNote.strumTime - Conductor.songPosition < 100)
                    daNote.alpha = 0;
                else if(daNote.strumTime - Conductor.songPosition < 500)
                    daNote.alpha = (daNote.strumTime - Conductor.songPosition - 100) / 400;
            }
            else if (
                (daNote.strumTime > 45082 && daNote.strumTime < 66216) ||
                (daNote.strumTime > 135248 && daNote.strumTime < 156465)
            )
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(Conductor.songPosition >= i)
                        index += 1;
                }
                if(index % 2 == 1)
                    daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else
                    daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(daNote.strumTime > 66298 && daNote.strumTime < 82045)
            {
                daNote.y = (strumLine.y - ((66298.34254143645 + FlxMath.roundDecimal((Conductor.songPosition - 66298.34254143645) / 165.745856354, 0) * 165.745856354) - daNote.strumTime) * (0.3 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(daNote.strumTime > 82209 && daNote.strumTime < 103338)
            {
                if (Std.int((daNote.strumTime - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) % 2 == 0)
                    daNote.y = -75 + 775 * (((daNote.strumTime - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
                else
                    daNote.y = 700 - 775 * (((daNote.strumTime - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
                if (Std.int((daNote.strumTime - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) == Std.int((Conductor.songPosition - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)))
                    daNote.alpha = 1;
                else 
                    daNote.alpha = 0.7;
            }
            else if(daNote.strumTime >= 124640 && daNote.strumTime < 135166 && Conductor.songPosition >= 124640.8839779005)
            {
                if (daNote.mustPress)
                    daNote.x = pxlist[daNote.noteData];
                else
                    daNote.x = xlist[daNote.noteData];
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(0.75*PlayState.SONG.speed, 2)));
            }
            else if (daNote.strumTime >= 167071)
            {
                if (daNote.mustPress)
                    daNote.x = 858;
                else
                    daNote.x = 218;
                daNote.y = (412 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                if (daNote.isSustainNote)
                    daNote.x += daNote.width;
            }
            else 
            {
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
        {
            if(daNote.strumTime >= 15000 && daNote.strumTime < 21562)
            {
                if (Conductor.songPosition < 15000)
                    daNote.y = daNote.y = (strumLine.y - (15000 - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2))) - (Conductor.songPosition - 15000) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
                else
                    daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                if(daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
                {
                    daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed/1.5;
                    daNote.updateHitbox();
                }
            }
            else if(daNote.strumTime >= 22500 && daNote.strumTime < 26016)
            {
                if (Conductor.songPosition < 22500)
                    daNote.y = daNote.y = (strumLine.y - (22500 - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2))) - (Conductor.songPosition - 22500) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2));
                else
                    daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                if(daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
                {
                    daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed/1.5;
                    daNote.updateHitbox();
                }
            }
            else if((daNote.strumTime >= 45000 && daNote.strumTime < 59766) || (daNote.strumTime >= 45000 && daNote.strumTime < 65625.0 && daNote.mustPress))
                daNote.y = (ylist[daNote.noteData] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            else if(daNote.strumTime >= 60000 && daNote.strumTime < 74766)
            {
                if (!daNote.mustPress)
                {
                    switch(daNote.noteData)
                    {
                        case 0:
                            daNote.x = (218 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                            daNote.y = 300;
                            if(daNote.x > 500)
                                daNote.alpha = (550 - daNote.x)/50;
                            else 
                                daNote.alpha = 1;
                        case 1:
                            daNote.x = 218;
                            daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                        case 2:
                            daNote.x = 218;
                            daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                        case 3:
                            daNote.x = (218 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                            daNote.y = 300;
                            if(daNote.x > 500)
                                daNote.alpha = (550 - daNote.x)/50;
                            else 
                                daNote.alpha = 1;
                    }
                }
                else
                {
                    switch(daNote.noteData)
                    {
                        case 0:
                            daNote.x = (858 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                            daNote.y = 300;
                            if(daNote.x < 570)
                                daNote.alpha = (daNote.x - 520)/50;
                            else 
                                daNote.alpha = 1;
                        case 1:
                            daNote.x = 858;
                            daNote.y = (300 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                        case 2:
                            daNote.x = 858;
                            daNote.y = (300 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                        case 3:
                            daNote.x = (858 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                            daNote.y = 300;
                            if(daNote.x < 570)
                                daNote.alpha = (daNote.x - 520)/50;
                            else 
                                daNote.alpha = 1;
                    }
                }
            }
            else if(daNote.strumTime >= 90000 && daNote.strumTime < 120000)
            {
                if ((Std.int((daNote.strumTime-90000)/7500) % 2 == 0 && daNote.mustPress) || Std.int((daNote.strumTime-90000)/7500) % 2 == 1 && !daNote.mustPress)
                {
                    if (daNote.mustPress)
                        daNote.y = (ylist[0] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    else
                        daNote.y = (ylist[1] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                }
                else
                {
                    if (daNote.mustPress)
                        daNote.y = (ylist[0] + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    else
                        daNote.y = (ylist[1] + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                }
            }
            else if (daNote.strumTime >= 120000)
            {
                if (daNote.mustPress)
                {
                    daNote.x = pxlist[daNote.noteData];
                    daNote.y = (ylist[0] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    if (daNote.isSustainNote)
                        daNote.x += daNote.width;
                }
                else 
                {
                    daNote.x = xlist[daNote.noteData];
                    daNote.y = (ylist[1] + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    if (daNote.isSustainNote)
                        daNote.x += daNote.width;
                }
            }
            else 
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
        }
        else if(PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
        {
            if(daNote.strumTime < 24114)
            {
                if (Std.int(Conductor.songPosition/1518.98734177) == Std.int(daNote.strumTime/1518.98734177))
                    daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else    
                    daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime - 189.873417722) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(daNote.strumTime >= 24303 && daNote.strumTime < 30190)
                daNote.y = (ylist[daNote.noteData] - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            else if(daNote.strumTime >= 30379 && daNote.strumTime < 36266)
            {
                if (!daNote.isSustainNote)
                    daNote.angle += 5;
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
            {
                if(daNote.mustPress)
                {
                    daNote.x = (1110 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    daNote.y = 132 + daNote.noteData * 112;
                }
                else 
                {
                    daNote.x = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    daNote.y = 468 - daNote.noteData * 112;
                }
                if(daNote.isSustainNote)
                {
                    if(daNote.mustPress)
                    {
                        daNote.angle = 90;
                        if(daNote.animation.curAnim.name.endsWith('end'))
                            daNote.x += daNote.height/1.5;
                    }
                    else
                    {
                        daNote.angle = -90;
                    }
                    daNote.x += (daNote.height - daNote.width) / 2;
                    daNote.y -= (daNote.height - daNote.width) / 2 - daNote.width;
                }
            }
            else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
            {
                if(daNote.mustPress)
                {
                    switch(daNote.noteData)
                    {
                        case 0:
                            daNote.y = 300;
                            daNote.x = (690 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                        case 3:
                            daNote.y = 300;
                            daNote.x = (1110 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                        case 1:
                            daNote.y = (510 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                            daNote.x = 900;
                        case 2:
                            daNote.y = (90 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                            daNote.x = 900;
                    }
                }
                else 
                {
                    switch(daNote.noteData)
                    {
                        case 0:
                            daNote.y = 300;
                            daNote.x = (50 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                        case 3:
                            daNote.y = 300;
                            daNote.x = (470 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                        case 1:
                            daNote.y = (510 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                            daNote.x = 260;
                        case 2:
                            daNote.y = (90 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed/1.5, 2)));
                            daNote.x = 260;
                    }
                }
                if(daNote.isSustainNote)
                {
                    if(daNote.animation.curAnim.name.endsWith('hold'))
                    {
                        daNote.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed/1.5;
                        daNote.updateHitbox();
                    }
                    if(daNote.noteData == 3)
                    {
                        daNote.angle = 90;
                        if(daNote.animation.curAnim.name.endsWith('end'))
                            daNote.x += daNote.height/1.5;
                    }
                    else if(daNote.noteData == 0)
                    {
                        daNote.angle = -90;
                    }
                    if (daNote.noteData == 3 || daNote.noteData == 0)
                    {
                        daNote.x += (daNote.height - daNote.width) / 2;
                        daNote.y -= (daNote.height - daNote.width) / 2 - daNote.width;
                    }
                    else 
                    {
                        daNote.x += daNote.width;
                    }
                }
            }
            else if(daNote.strumTime >= 60759 && daNote.strumTime < 72722)
            {
                if(!daNote.isSustainNote)
                {
                    switch(daNote.noteData)
                    {
                        case 0:
                            daNote.angle = 90;
                        case 3:
                            daNote.angle = -90;
                        case 1:
                            daNote.angle = 180;
                    }
                }
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(daNote.strumTime >= 78987 && daNote.strumTime < 91045)
            {
                if(daNote.mustPress)
                {
                    if ((daNote.strumTime - 85063.29113924058) / 6075.94936709 < 0.5)
                        daNote.y = ((50 + 500 * (daNote.strumTime - 85063.29113924058) / 6075.94936709) - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    else
                        daNote.y = ((50 + 500 * (daNote.strumTime - 85063.29113924058) / 6075.94936709) + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                }
                else 
                {
                    if ((daNote.strumTime - 78987.34177215197) / 6075.94936709 < 0.5)
                        daNote.y = ((50 + 500 * (daNote.strumTime - 78987.34177215197) / 6075.94936709) - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    else
                        daNote.y = ((50 + 500 * (daNote.strumTime - 78987.34177215197) / 6075.94936709) + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                }
            }
            else if(daNote.strumTime >= 91139 && daNote.strumTime < 97026)
            {
                if(daNote.mustPress)
                    daNote.x = pxlist[daNote.noteData];
                else
                    daNote.x = xlist[daNote.noteData];
                if (daNote.isSustainNote)
                    daNote.x += daNote.width;
                daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if(daNote.strumTime >= 97215 && daNote.strumTime < 109178)
            {
                if(daNote.mustPress)
                {
                    daNote.x = (690 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    daNote.y = 468 - daNote.noteData * 112;
                }
                else 
                {
                    daNote.x = (520 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    daNote.y = 132 + daNote.noteData * 112;
                }
                if(daNote.isSustainNote)
                {
                    if(!daNote.mustPress)
                    {
                        daNote.angle = 90;
                        if(daNote.animation.curAnim.name.endsWith('end'))
                            daNote.x += daNote.height/1.5;
                    }
                    else
                    {
                        daNote.angle = -90;
                    }
                    daNote.x += (daNote.height - daNote.width) / 2;
                    daNote.y -= (daNote.height - daNote.width) / 2 - daNote.width;
                }
            }
            else if(daNote.strumTime >= 109367 && daNote.strumTime < 121330)
            {
                daNote.y = 300;
                daNote.scale.x = 2 - 1.9 * (daNote.strumTime - Conductor.songPosition)/ 379.746835444;
                daNote.scale.y = 2 - 1.9 * (daNote.strumTime - Conductor.songPosition)/ 379.746835444;
                if(daNote.mustPress)
                    daNote.x = 538 + (poxlist[daNote.noteData] - 538)/3 + 1.2 * (poxlist[daNote.noteData] - 538) * (1 - (daNote.strumTime - Conductor.songPosition)/379.746835444);
                else
                    daNote.x = 538 - (538 - oxlist[daNote.noteData])/3 - 1.2 * (538 - oxlist[daNote.noteData]) * (1 - (daNote.strumTime - Conductor.songPosition)/379.746835444);
                if(Conductor.songPosition > daNote.strumTime)
                    daNote.alpha = 0;
            }
            else if(daNote.strumTime >= 121518 && daNote.strumTime < 145633)
            {
                if(daNote.mustPress)
                {
                    daNote.x = 538 + (poxlist[daNote.noteData] - 538) * FlxMath.fastCos(daNote.strumTime/1518.98734177 * 3.1415926);
                    daNote.y = 300 - (100+50*daNote.noteData) * FlxMath.fastSin(daNote.strumTime/1518.98734177 * 3.1415926);
                }
                else
                {
                    daNote.x = 538 - (538 - oxlist[daNote.noteData]) * FlxMath.fastCos(daNote.strumTime/1518.98734177 * 3.1415926);
                    daNote.y = 300 + (100+50*(3-daNote.noteData)) * FlxMath.fastSin(daNote.strumTime/1518.98734177 * 3.1415926);
                }
            }
            else 
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
        }
        else if(PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
                daNote.y = (sy - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(((300-sy)/250)*PlayState.SONG.speed, 2)));
            else if(Conductor.songPosition >= 124044.94382022502 && Conductor.songPosition < 145617.977528)
            {
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                if (
                    ((Conductor.songPosition-124044.94382022502)%2696.62921348 < 1348.31460674 && daNote.y <= sy) || 
                    ((Conductor.songPosition-124044.94382022502)%2696.62921348 >= 1348.31460674 && daNote.y > sy)
                )
                {
                    if(daNote.mustPress)
                        daNote.x = poxlist[daNote.noteData];
                    else
                        daNote.x = oxlist[daNote.noteData];
                }
                else
                {
                    if(daNote.mustPress)
                        daNote.x = poxlist[3 - daNote.noteData];
                    else
                        daNote.x = oxlist[3 - daNote.noteData];
                }
                if (daNote.isSustainNote)
                    daNote.x += daNote.width;
            }
            else if(daNote.strumTime >= 145617 && daNote.strumTime < 156236)
            {
                if(daNote.mustPress)
                    daNote.x = poxlist[daNote.noteData];
                else
                    daNote.x = oxlist[daNote.noteData];
                if (daNote.isSustainNote)
                    daNote.x += daNote.width;
                else
                    daNote.angle += 5;
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if (daNote.strumTime >= 156404 && daNote.strumTime < 168456 && Conductor.songPosition < 167191.0112359552)
            {
                if(daNote.mustPress)
                    daNote.x = poxlist[daNote.noteData] + (FlxMath.fastSin((daNote.strumTime - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (stage[0] * 2 / 10) + stage[0] / 2 - Lib.application.window.x - 320)*2;
                else
                    daNote.x = oxlist[daNote.noteData] + (FlxMath.fastSin((daNote.strumTime - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (stage[0] * 2 / 10) + stage[0] / 2 - Lib.application.window.x - 320)*2;
                daNote.y = strumLine.y + (FlxMath.fastCos((daNote.strumTime - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (stage[1] * -2 / 10) + stage[1] / 2 - Lib.application.window.y - 180)*2;
            }
            else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
            {
                if(daNote.mustPress)
                    daNote.x = poxlist[daNote.noteData];
                else
                    daNote.x = oxlist[daNote.noteData];
                if (daNote.strumTime % 2696.62921348 < 1348.31460674)
                    if(daNote.strumTime % 1348.31460674 < 674.157303371)
                        daNote.y = (50 + 500 * (daNote.strumTime % 1348.31460674) / 1348.31460674 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    else
                        daNote.y = (50 + 500 * (daNote.strumTime % 1348.31460674) / 1348.31460674 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else
                    if(daNote.strumTime % 1348.31460674 < 674.157303371)
                        daNote.y = (550 - 500 * (daNote.strumTime % 1348.31460674) / 1348.31460674 + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                    else
                        daNote.y = (550 - 500 * (daNote.strumTime % 1348.31460674) / 1348.31460674 - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if (Conductor.songPosition >= 172584.26966292146 && Conductor.songPosition < 177977.52808988772)
            {
                if(daNote.mustPress)
                    daNote.x = pxlist[daNote.noteData];
                else
                    daNote.x = xlist[daNote.noteData];
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
                /*if(Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 102387.64044943838)
            {
                if (Conductor.songPosition % 40 < 20)
                {
                    if (daNote.noteData < 2)
                        daNote.alpha = 0;
                    else 
                        daNote.alpha = 1;
                }
                else
                {
                    if (daNote.noteData < 2)
                        daNote.alpha = 1;
                    else 
                        daNote.alpha = 0;
                }
                if(!daNote.mustPress)
                    daNote.x = oxlist[1 + daNote.noteData % 2];
                else
                    daNote.x = poxlist[1 + daNote.noteData % 2];
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }*/
            else
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
        }
        else
        {
            daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
        }
    }
    public static function spos(dastrum:FlxSprite,strumLine:FlxSprite)
    {
        if(PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
        {
            if (Conductor.songPosition >= 122553.19148936185)
            {
                xlist = [274,50,162,386];
                pxlist = [914,690,802,1026];
                strumLine.y = 50;
                if(dastrum.x > 640)
                    dastrum.x = pxlist[dastrum.ID];
                else
                    dastrum.x = xlist[dastrum.ID];
                dastrum.y = 50;
            }
            else if (Conductor.songPosition >= 95319.14893617031 && Conductor.songPosition < 122553.19148936185)
            {
                if ((Conductor.songPosition - 108936.17021276608) / (97021.27659574478 - 95319.14893617031) > times)
                {
                    temp = xlist[0];
                    ptemp = pxlist[0];
                    xlist[0] = xlist[1];
                    xlist[1] = xlist[2];
                    xlist[2] = xlist[3];
                    xlist[3] = temp;
                    pxlist[0] = pxlist[1];
                    pxlist[1] = pxlist[2];
                    pxlist[2] = pxlist[3];
                    pxlist[3] = ptemp;
                    nlist[0] = xlist[1];
                    nlist[1] = xlist[2];
                    nlist[2] = xlist[3];
                    nlist[3] = xlist[0];
                    pnlist[0] = pxlist[1];
                    pnlist[1] = pxlist[2];
                    pnlist[2] = pxlist[3];
                    pnlist[3] = pxlist[0];
                    times += 1;
                }
                if(dastrum.x > 640)
                    dastrum.x = pxlist[dastrum.ID];
                else
                    dastrum.x = xlist[dastrum.ID];
                dastrum.y = -75 + 775 * (((Conductor.songPosition - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
                strumLine.y = dastrum.y;
            }
            else if (Conductor.songPosition >= 68085.10638297877 && Conductor.songPosition <= 95177.3049645391)
            {
                times = 0;
                if(dastrum.x > 640)
                    {
                        dastrum.x = poxlist[dastrum.ID];
                        pxlist[dastrum.ID] = dastrum.x;
                    }
                        else
                    {
                        dastrum.x = oxlist[dastrum.ID];
                        xlist[dastrum.ID] = dastrum.x;
                    }
                switch(Std.int((Conductor.songPosition - 68085.10638297877) / (68510.63829787239 - 68085.10638297877)) % 8)
                {
                    case 0:
                        if(dastrum.ID == 0 || dastrum.ID == 2)
                        {
                            dastrum.y = 50 + (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239 - 68085.10638297877)) * 500;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.y = 50;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                    case 1:
                        if(dastrum.ID == 0 || dastrum.ID == 2)
                        {
                            dastrum.y = 550;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.y = 50;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                    case 2:
                        if(dastrum.ID == 0 || dastrum.ID == 2)
                        {
                            dastrum.y = 550;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.y = 50 + (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239 - 68085.10638297877)) * 500;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                    case 3:
                        if(dastrum.ID == 0 || dastrum.ID == 2)
                        {
                            dastrum.y = 550;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.y = 550;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                    case 4:
                        if(dastrum.ID == 0 || dastrum.ID == 2)
                        {
                            dastrum.y = 550 - (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239 - 68085.10638297877)) * 500;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.y = 550;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                    case 5:
                        if(dastrum.ID == 0 || dastrum.ID == 2)
                        {
                            dastrum.y = 50;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.y = 550;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                    case 6:
                    if(dastrum.ID == 0 || dastrum.ID == 2)
                    {
                        dastrum.y = 50;
                        ylist[dastrum.ID] = dastrum.y;
                    }
                    else 
                    {
                        dastrum.y = 550 - (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239 - 68085.10638297877)) * 500;
                        ylist[dastrum.ID] = dastrum.y;
                    }
                    case 7:
                        if(dastrum.ID == 0 || dastrum.ID == 2)
                        {
                            dastrum.y = 50;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.y = 50;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                }
            }
            else if (Conductor.songPosition >= 47659.57446808513 && Conductor.songPosition <= 67943.26241134756)
            {
                /*if (times == 0)
                {
                    while (nlist[0] == xlist[0] && nlist[1] == xlist[1] && nlist[2] == xlist[2] && nlist[3] == xlist[3])
                    {
                        var dalist:Array<Int> = [];
                        var numlist:Array<Int> = [0,1,2,3];
                        for (i in 0...4)
                        {
                            var num = FlxG.random.int(0,3-i);
                            dalist.push(numlist[num]);
                            numlist.remove(numlist[num]);
                            nlist[i] = oxlist[dalist[i]];
                            pnlist[i] = poxlist[dalist[i]];
                        }
                        trace(nlist+" "+xlist);
                    }
                    for (i in 0...4)
                    {
                        xlist[i] = nlist[i];
                        pxlist[i] = pnlist[i];
                    }
                    times += 1;
                }*/
                if(Conductor.songPosition <= 47759.57446808513)
                {
                    if(dastrum.x > 640)
                    {
                        dastrum.x = 858 - (47759.57446808513 - Conductor.songPosition) / 100 * (858 - poxlist[dastrum.ID]);
                        pxlist[dastrum.ID] = dastrum.x;
                    }
                        else
                    {
                        dastrum.x = 218 - (47759.57446808513 - Conductor.songPosition) / 100 * (218 - oxlist[dastrum.ID]);
                        xlist[dastrum.ID] = dastrum.x;
                    }
                }
                else if(Conductor.songPosition >= 67843.26241134756)
                {
                    if(dastrum.x > 640)
                    {
                        dastrum.x = poxlist[dastrum.ID] - (67943.26241134756 - Conductor.songPosition) / 100 * (poxlist[dastrum.ID] - 858);
                        pxlist[dastrum.ID] = dastrum.x;
                    }
                        else
                    {
                        dastrum.x = oxlist[dastrum.ID] - (67943.26241134756 - Conductor.songPosition) / 100 * (oxlist[dastrum.ID] - 218);
                        xlist[dastrum.ID] = dastrum.x;
                    }
                }
                else 
                {
                    if (dastrum.x > 640)
                    {
                        dastrum.x = 858;
                        pxlist[dastrum.ID] = dastrum.x;
                    }
                    else 
                    {
                        dastrum.x = 218;
                        xlist[dastrum.ID] = dastrum.x;
                    }
                }
                times = 1;
                dastrum.y = strumLine.y;
            }
            else if (Conductor.songPosition >= 40851.06382978724 && Conductor.songPosition <= 44113.47517730498)
            {
                sy = (50 + 500 * (44113.47517730498 - Conductor.songPosition) / (44113.47517730498 - 40851.06382978724));
                strumLine.y = sy;
                dastrum.y = sy;
            }
            else if (Conductor.songPosition >= 27092.19858156028 && Conductor.songPosition <= 40851.06382978724)
            {
                sy = 550;
                strumLine.y = 550;
                dastrum.y = sy;
            }
            else if (Conductor.songPosition >= 26382.978723404252 && Conductor.songPosition <= 27092.19858156028)
            {
                sy = (550 - 500 * (27092.19858156028 - Conductor.songPosition) / (27092.19858156028 - 26382.978723404252));
                strumLine.y = sy;
                dastrum.y = sy;
            }
            else
            {
                dastrum.y = strumLine.y;
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
        {
            if (
                (Conductor.songPosition >= 2651.9337016574586 && Conductor.songPosition < 13259.668508287292) ||
                (Conductor.songPosition >= 156464.08839779 && Conductor.songPosition < 166740.33149171266)
            )
            {
                xlist = [106,218,218,330];
                pxlist = [746,858,858,970];
                ylist = [300,412,188,300];
                if(dastrum.x > 640)
                {
                    dastrum.x = pxlist[dastrum.ID];
                    dastrum.y = ylist[dastrum.ID];
                }
                else 
                {
                    dastrum.x = xlist[dastrum.ID];
                    dastrum.y = ylist[dastrum.ID];
                }
            }
            else if (Conductor.songPosition >= 13259.668508287292 && Conductor.songPosition < 23784.530386740327)
            {
                xlist = [50,162,274,386];
                pxlist = [690,802,914,1026];
                ylist = [50,50,50,50];
                if(dastrum.x > 640)
                {
                    dastrum.x = pxlist[dastrum.ID];
                    dastrum.y = ylist[dastrum.ID];
                }
                else 
                {
                    dastrum.x = xlist[dastrum.ID];
                    dastrum.y = ylist[dastrum.ID];
                }
            }
            else if(
                (Conductor.songPosition > 45082 && Conductor.songPosition < 55525) ||
                (Conductor.songPosition > 55690.60773480661 && Conductor.songPosition < 66215.46961325964) ||
                (Conductor.songPosition > 135248 && Conductor.songPosition < 156382)
            )
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(Conductor.songPosition >= i)
                        index += 1;
                }
                xlist = [50,162,274,386];
                pxlist = [690,802,914,1026];
                if(dastrum.x > 640)
                    dastrum.x = pxlist[dastrum.ID];
                else
                    dastrum.x = xlist[dastrum.ID];
                if(index % 2 == 1)
                    dastrum.y = 50;
                else
                    dastrum.y = 550;
            }
            else if (
                (Conductor.songPosition >= 23867.403314917123 && Conductor.songPosition < 44999.999999999985)||
                (Conductor.songPosition >= 103425.41436464085 && Conductor.songPosition < 124558.01104972372)
            )
            {
                dastrum.y = 300;
            }
            else if (Conductor.songPosition >= 66298.34254143645 && Conductor.songPosition < 71436.46408839777)
            {
                xlist = [50,162,274,386];
                pxlist = [690,802,914,1026];
                if(dastrum.x > 640)
                    dastrum.x = pxlist[dastrum.ID];
                else
                    dastrum.x = xlist[dastrum.ID];
                dastrum.y = 50;
            }
            else if(Conductor.songPosition >= 82209.94475138119 && Conductor.songPosition < 103337.0165745856)
            {
                if (Std.int((Conductor.songPosition - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) % 2 == 0)
                    dastrum.y = -75 + 775 * (((Conductor.songPosition - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
                else
                    dastrum.y = 700 - 775 * (((Conductor.songPosition - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
                strumLine.y = dastrum.y;
            }
            else if(Conductor.songPosition >= 124640.8839779005 && Conductor.songPosition < 135165.74585635355)
            {
                if(dastrum.x > 640)
                {
                    pxlist[dastrum.ID] = FlxMath.fastSin((((Conductor.songPosition - 124640.8839779005) / 1325.96685083 + (-0.5 + dastrum.ID / 3)) * 3.1415926535)) * 168 + 858;
                    dastrum.x = pxlist[dastrum.ID];
                }
                else
                {
                    xlist[dastrum.ID] = FlxMath.fastSin((((Conductor.songPosition - 124640.8839779005) / 1325.96685083 + (-0.5 + dastrum.ID / 3)) * 3.1415926535)) * 168 + 218;
                    dastrum.x = xlist[dastrum.ID];
                }
                dastrum.y = 50;
                strumLine.y = dastrum.y;
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 30000 && Conductor.songPosition < 45000)
            {
                if(Std.int((Conductor.songPosition-30000)/937.5) % 2 == 0)
                    dastrum.y = 50 + ((Conductor.songPosition-30000) % 937.5)/937.5 * 200;
                else
                    dastrum.y = 250 - ((Conductor.songPosition-30000) % 937.5)/937.5 * 200;
                strumLine.y = dastrum.y;
            }
            else if(Conductor.songPosition >= 45000 && Conductor.songPosition < 59531.25)
            {
                switch (Std.int((Conductor.songPosition-30000)/937.5) % 4)
                {
                    case 0:
                        if (dastrum.ID % 2 == 0)
                            dastrum.y = 50 + ((Conductor.songPosition-30000) % 937.5)/937.5 * 200;
                    case 1:
                        if (dastrum.ID % 2 == 0)
                            dastrum.y = 250 - ((Conductor.songPosition-30000) % 937.5)/937.5 * 200;
                    case 2:
                        if (dastrum.ID % 2 == 1)
                            dastrum.y = 50 + ((Conductor.songPosition-30000) % 937.5)/937.5 * 200;
                    case 3:
                        if (dastrum.ID % 2 == 1)
                            dastrum.y = 250 - ((Conductor.songPosition-30000) % 937.5)/937.5 * 200;
                }
                ylist[dastrum.ID] = dastrum.y;
            }
            else if(Conductor.songPosition >= 59531.25 && Conductor.songPosition < 73125)
            {
                if(Conductor.songPosition < 60000.0)
                    {
                        if(dastrum.x > 640)
                        {
                            if (dastrum.ID % 2 == 1)
                                dastrum.y = 250 - ((Conductor.songPosition-30000) % 937.5)/937.5 * 200;
                            ylist[dastrum.ID] = dastrum.y;
                        }
                        else 
                        {
                            dastrum.x = oxlist[dastrum.ID] - (Conductor.songPosition-59531.25)/468.75 * (oxlist[dastrum.ID]-218);
                            dastrum.y = 50 + (Conductor.songPosition-59531.25)/468.75 * 250;
                        }
                    }
                else if (Conductor.songPosition >= 63750.0 && Conductor.songPosition < 64218.75)
                {
                    if(dastrum.x > 640)
                    {
                        dastrum.x = poxlist[dastrum.ID] - (Conductor.songPosition-63750.0)/468.75 * (poxlist[dastrum.ID]-858);
                        dastrum.y = 50 + (Conductor.songPosition-63750.0)/468.75 * 250;
                    }
                }
            }
            else if(Conductor.songPosition >= 74531.25 && Conductor.songPosition < 75468.75)
            {
                if(Conductor.songPosition < 75000.0)
                {
                    if(dastrum.x < 640)
                    {
                        dastrum.x = 218 - (Conductor.songPosition-74531.25)/468.75 * (218 - oxlist[dastrum.ID]);
                        dastrum.y = 300 - (Conductor.songPosition-74531.25)/468.75 * 250;
                    }
                }
                else if (Conductor.songPosition >= 75000.0 && Conductor.songPosition < 75468.75)
                {
                    if(dastrum.x > 640)
                    {
                        dastrum.x = 858 + (Conductor.songPosition-75000.0)/468.75 * (poxlist[dastrum.ID]-858);
                        dastrum.y = 300 - (Conductor.songPosition-75000.0)/468.75 * 250;
                    }
                }
            }
            else if (Conductor.songPosition >= 89531.25 && Conductor.songPosition < 90000)
            {
                if(dastrum.x < 640)
                    dastrum.y = 50 + (Conductor.songPosition-89531.25)/468.75 * 500;
            }
            else if(Conductor.songPosition >= 90000 && Conductor.songPosition < 120000)
            {
                if ((Std.int((Conductor.songPosition-90000)/7500) % 2 == 0 && dastrum.x > 640) || Std.int((Conductor.songPosition-90000)/7500) % 2 == 1 && dastrum.x < 640)
                {
                    if(Std.int((Conductor.songPosition-90000)/937.5) % 8 > 5)
                        dastrum.y = 50 + ((Conductor.songPosition-90000) % 1875)/1875 * 500;
                    else if(Std.int((Conductor.songPosition-90000)/937.5) % 2 == 0)
                        dastrum.y = 50 + ((Conductor.songPosition-90000) % 937.5)/937.5 * 200;
                    else
                        dastrum.y = 250 - ((Conductor.songPosition-90000) % 937.5)/937.5 * 200;
                }
                else 
                {
                    if(Std.int((Conductor.songPosition-90000)/937.5) % 8 > 5)
                        dastrum.y = 550 - ((Conductor.songPosition-90000) % 1875)/1875 * 500;
                    else if(Std.int((Conductor.songPosition-90000)/937.5) % 2 == 0)
                        dastrum.y = 550 - ((Conductor.songPosition-90000) % 937.5)/937.5 * 200;
                    else
                        dastrum.y = 350 + ((Conductor.songPosition-90000) % 937.5)/937.5 * 200;
                }
                if(dastrum.x < 640)
                    ylist[1] = dastrum.y;
                else
                    ylist[0] = dastrum.y;
            }
            else if (Conductor.songPosition >= 120000 && Conductor.songPosition < 120937.5)
            {
                if (dastrum.x > 472 + dastrum.ID*112)
                {
                    dastrum.x = poxlist[dastrum.ID] + ((Conductor.songPosition-120000) % 937.5)/937.5 * (472 + dastrum.ID*112 - poxlist[dastrum.ID]);
                    dastrum.y = 50 + ((Conductor.songPosition-120000) % 937.5)/937.5 * 250;
                    ylist[0] = dastrum.y;
                    pxlist[dastrum.ID] = dastrum.x;
                }
                else 
                {
                    dastrum.x = oxlist[dastrum.ID] + ((Conductor.songPosition-120000) % 937.5)/937.5 * (472 + dastrum.ID*112 - oxlist[dastrum.ID]);
                    dastrum.y = 550 - ((Conductor.songPosition-120000) % 937.5)/937.5 * 250;
                    ylist[1] = dastrum.y;
                    xlist[dastrum.ID] = dastrum.x;
                }
            }
            else if (Conductor.songPosition >= 120937.5)
            {
                dastrum.x = 472 + dastrum.ID*112;
                dastrum.y = 300;
                ylist[0] = dastrum.y;
                pxlist[dastrum.ID] = dastrum.x;
                ylist[1] = dastrum.y;
                xlist[dastrum.ID] = dastrum.x;
            }
            
        }
        else if(PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 24303.797468354438 && Conductor.songPosition < 30379.746835443053)
            {    
                if (Conductor.songPosition % 759.493670886 < 379.746835443)
                {
                    if(dastrum.ID % 2 == 0)
                    {
                        dastrum.y = 150;
                        ylist[dastrum.ID] = 150;
                    }
                    else 
                    {
                        dastrum.y = 50;
                        ylist[dastrum.ID] = 50;
                    }
                }
                else 
                {
                    if(dastrum.ID % 2 == 0)
                    {
                        dastrum.y = 50;
                        ylist[dastrum.ID] = 50;
                    }
                    else 
                    {
                        dastrum.y = 150;
                        ylist[dastrum.ID] = 150;
                    }
                }
            }
            else if(Conductor.songPosition >= 30379.746835443053 && Conductor.songPosition < 31189.873417721534)
                dastrum.y = 50;
            else if(Conductor.songPosition >= 36455.69620253167 && Conductor.songPosition < 48227.84810126586)
            {
                if(dastrum.x > 640)
                {
                    dastrum.x = 1110;
                    dastrum.y = 132 + dastrum.ID * 112;
                }
                else 
                {
                    dastrum.x = 50;
                    dastrum.y = 468 - dastrum.ID * 112;
                }
            }
            else if(Conductor.songPosition >= 48227.84810126586 && Conductor.songPosition < 48987.341772151936)
            {
                if (Conductor.songPosition < 48607.5949367089)
                {
                    if(dastrum.x < 640)
                    {
                        switch(dastrum.ID)
                        {
                            case 0:
                                dastrum.x = 50;
                                dastrum.y = 468 - (Conductor.songPosition - 48227.84810126586)/379.746835443 * (168);
                            case 1:
                                dastrum.x = 50 + (Conductor.songPosition - 48227.84810126586)/379.746835443 * (210);
                                dastrum.y = 356 + (Conductor.songPosition - 48227.84810126586)/379.746835443 * (154);
                            case 2:
                                dastrum.x = 50 + (Conductor.songPosition - 48227.84810126586)/379.746835443 * (210);
                                dastrum.y = 244 - (Conductor.songPosition - 48227.84810126586)/379.746835443 * (154);
                            case 3:
                                dastrum.x = 50 + (Conductor.songPosition - 48227.84810126586)/379.746835443 * (420);
                                dastrum.y = 132 + (Conductor.songPosition - 48227.84810126586)/379.746835443 * (168);
                        }
                    }
                }
                else
                {
                    if(dastrum.x > 640)
                    {
                        switch(dastrum.ID)
                        {
                            case 0:
                                dastrum.x = 1110 - (Conductor.songPosition - 48607.5949367089)/379.746835443 * (420);
                                dastrum.y = 132 + (Conductor.songPosition - 48607.5949367089)/379.746835443 * (168);
                            case 1:
                                dastrum.x = 1110 - (Conductor.songPosition - 48607.5949367089)/379.746835443 * (210);
                                dastrum.y = 244 + (Conductor.songPosition - 48607.5949367089)/379.746835443 * (266);
                            case 2:
                                dastrum.x = 1110 - (Conductor.songPosition - 48607.5949367089)/379.746835443 * (210);
                                dastrum.y = 356 - (Conductor.songPosition - 48607.5949367089)/379.746835443 * (266);
                            case 3:
                                dastrum.x = 1110;
                                dastrum.y = 468 - (Conductor.songPosition - 48607.5949367089)/379.746835443 * (168);
                        }
                    }
                    else 
                    {
                        switch(dastrum.ID)
                        {
                            case 0:
                                dastrum.x = 50;
                                dastrum.y = 300;
                            case 1:
                                dastrum.x = 260;
                                dastrum.y = 510;
                            case 2:
                                dastrum.x = 260;
                                dastrum.y = 90;
                            case 3:
                                dastrum.x = 470;
                                dastrum.y = 300;
                        }
                    }
                }
            }
            else if(Conductor.songPosition >= 48987.341772151936 && Conductor.songPosition < 49987.341772151936)
            {
                if(dastrum.x > 640)
                {
                    switch(dastrum.ID)
                    {
                        case 0:
                            dastrum.x = 690;
                            dastrum.y = 300;
                        case 1:
                            dastrum.x = 900;
                            dastrum.y = 510;
                        case 2:
                            dastrum.x = 900;
                            dastrum.y = 90;
                        case 3:
                            dastrum.x = 1110;
                            dastrum.y = 300;
                    }
                }
            }
            else if(Conductor.songPosition >= 72911.39240506335 && Conductor.songPosition < 78797.46835443044)
            {
                if (Conductor.songPosition < 73101.26582278487)
                    dastrum.alpha = (73101.26582278487 - Conductor.songPosition) / 189.873417722;
                else
                    dastrum.alpha = 0;
            }
            else if (Conductor.songPosition >= 78987.34177215197 && Conductor.songPosition < 91044.30379746843)
            {
                if (Conductor.songPosition < 79177.21518987349)
                    dastrum.alpha = (Conductor.songPosition - 78987.34177215197) / 189.873417722;
                else
                    dastrum.alpha = 1;
                if (Conductor.songPosition < 85063.29113924058)
                {
                    if(dastrum.x < 640)
                        dastrum.y = 50 + 500 * (Conductor.songPosition - 78987.34177215197) / 6075.94936709;
                }
                else
                {
                    if(dastrum.x > 640)
                        dastrum.y = 50 + 500 * (Conductor.songPosition - 85063.29113924058) / 6075.94936709;
                }
            }
            else if (Conductor.songPosition >= 91139.2405063292 && Conductor.songPosition < 97025.31645569629)
            {
                if (Conductor.songPosition % 1518.98734177 < 379.746835443)
                {
                    if (dastrum.x > 640)
                    {
                        if(dastrum.ID%2 == 0)
                        {
                            dastrum.x = poxlist[dastrum.ID] + (Conductor.songPosition % 379.746835443)/379.746835443 * (poxlist[dastrum.ID+1] - poxlist[dastrum.ID]);
                            pxlist[dastrum.ID] = dastrum.x;
                        }
                        else
                        {
                            dastrum.x = poxlist[dastrum.ID] + (Conductor.songPosition % 379.746835443)/379.746835443 * (poxlist[dastrum.ID-1] - poxlist[dastrum.ID]);
                            pxlist[dastrum.ID] = dastrum.x;
                        }
                    }
                    else
                    {
                        if(dastrum.ID%2 == 0)
                        {
                            dastrum.x = oxlist[dastrum.ID] + (Conductor.songPosition % 379.746835443)/379.746835443 * (oxlist[dastrum.ID+1] - oxlist[dastrum.ID]);
                            xlist[dastrum.ID] = dastrum.x;
                        }
                        else
                        {
                            dastrum.x = oxlist[dastrum.ID] + (Conductor.songPosition % 379.746835443)/379.746835443 * (oxlist[dastrum.ID-1] - oxlist[dastrum.ID]);
                            xlist[dastrum.ID] = dastrum.x;
                        }
                    }
                }
                else if(Conductor.songPosition % 1518.98734177 >= 759.493670886 && Conductor.songPosition % 1518.98734177 < 1139.24050633)
                {
                    if (dastrum.x > 640)
                        {
                            if(dastrum.ID%2 == 0)
                            {
                                dastrum.x = poxlist[dastrum.ID+1] - (Conductor.songPosition % 379.746835443)/379.746835443 * (poxlist[dastrum.ID+1] - poxlist[dastrum.ID]);
                                pxlist[dastrum.ID] = dastrum.x;
                            }
                            else
                            {
                                dastrum.x = poxlist[dastrum.ID-1] - (Conductor.songPosition % 379.746835443)/379.746835443 * (poxlist[dastrum.ID-1] - poxlist[dastrum.ID]);
                                pxlist[dastrum.ID] = dastrum.x;
                            }
                        }
                        else
                        {
                            if(dastrum.ID%2 == 0)
                            {
                                dastrum.x = oxlist[dastrum.ID+1] - (Conductor.songPosition % 379.746835443)/379.746835443 * (oxlist[dastrum.ID+1] - oxlist[dastrum.ID]);
                                xlist[dastrum.ID] = dastrum.x;
                            }
                            else
                            {
                                dastrum.x = oxlist[dastrum.ID-1] - (Conductor.songPosition % 379.746835443)/379.746835443 * (oxlist[dastrum.ID-1] - oxlist[dastrum.ID]);
                                xlist[dastrum.ID] = dastrum.x;
                            }
                        }
                }
            }
            else if(Conductor.songPosition >= 97215.18987341781 && Conductor.songPosition < 109177.21518987352)
            {
                if(dastrum.x > 640)
                {
                    dastrum.x = 690;
                    dastrum.y = 468 - dastrum.ID * 112;
                }
                else 
                {
                    dastrum.x = 520;
                    dastrum.y = 132 + dastrum.ID * 112;
                }
            }
            else if(Conductor.songPosition >= 109367.08860759504 && Conductor.songPosition < 110886.0759493672)
            {
                if (Conductor.songPosition < 109556.962025)
                {
                    dastrum.scale.x = (109556.962025 - Conductor.songPosition) / 189.873417722 * 0.7;
                    dastrum.scale.y = (109556.962025 - Conductor.songPosition) / 189.873417722 * 0.7;
                }
                else
                    dastrum.alpha = 0;
            }
            else if(Conductor.songPosition >= 121139.24050632922 && Conductor.songPosition < 121329.11392405075)
            {
                if(dastrum.x > 640)
                    dastrum.x = poxlist[dastrum.ID];
                else
                    dastrum.x = oxlist[dastrum.ID];
                dastrum.y = 300;
                dastrum.alpha = 1;
                dastrum.x = 538 - (538 - oxlist[dastrum.ID]) * FlxMath.fastCos(Conductor.songPosition/1518.98734177 * 3.1415926);
                dastrum.y = 300 + (100+50*(3-dastrum.ID)) * FlxMath.fastSin(Conductor.songPosition/1518.98734177 * 3.1415926);
                dastrum.scale.x = (Conductor.songPosition - 121139.24050632922) / 189.873417722 * 0.7;
                dastrum.scale.y = (Conductor.songPosition - 121139.24050632922) / 189.873417722 * 0.7;
            }
            else if(Conductor.songPosition >= 121518.98734177227 && Conductor.songPosition < 145822.78481)
            {
                dastrum.scale.x = 0.7;
                dastrum.scale.y = 0.7;
                dastrum.x = 538 - (538 - oxlist[dastrum.ID]) * FlxMath.fastCos(Conductor.songPosition/1518.98734177 * 3.1415926);
                dastrum.y = 300 + (100+50*(3-dastrum.ID)) * FlxMath.fastSin(Conductor.songPosition/1518.98734177 * 3.1415926);
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 48707.86516853933 && Conductor.songPosition < 58988.76404494382)
            {
                dastrum.y = 50 - ((Conductor.songPosition-48707.86516853933)/10280.8988764)*160;
                strumLine.y = dastrum.y;
            }
            else if (Conductor.songPosition >= 59325.84269662921 && Conductor.songPosition < 59494.38202247191)
            {
                dastrum.y = 50;
                strumLine.y = dastrum.y;
            }
            else if (Conductor.songPosition >= 59494.38202247191 && Conductor.songPosition < 69775.28089887642)
            {
                dastrum.y = 50 - ((Conductor.songPosition-59494.38202247191)/10280.8988764)*160;
                strumLine.y = dastrum.y;
            }
            else if (Conductor.songPosition >= 70112.35955056181 && Conductor.songPosition < 70280.8988764045)
            {
                dastrum.y = 50;
                strumLine.y = dastrum.y;
            }
            else if(Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
            {
                dastrum.y = 300 - FlxMath.fastSin(((Conductor.songPosition-70280.8988764045)/1348.31460674-0.5)*3.1415926535)*250;
                strumLine.y  = dastrum.y;
                sy = dastrum.y;
            }
            else if(Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 93033.70786516868)
            {
                dastrum.y = 50;
                strumLine.y = dastrum.y;
            }
            else if(Conductor.songPosition >= 124044.94382022502 && Conductor.songPosition < 145617.977528)
            {
                if ((Conductor.songPosition-124044.94382022502)%2696.62921348 < 1348.31460674)
                {
                    if(dastrum.x > 640)
                        dastrum.x = poxlist[dastrum.ID];
                    else
                        dastrum.x = oxlist[dastrum.ID];
                }
                else
                {
                    if(dastrum.x > 640)
                        dastrum.x = poxlist[3 - dastrum.ID];
                    else
                        dastrum.x = oxlist[3 - dastrum.ID];
                }
                sy = 50 + ((Conductor.songPosition-124044.94382022502)%1348.31460674)/1348.31460674 * 1230;
            }
            else if(Conductor.songPosition >= 145617.97752809015 && Conductor.songPosition < 156067.4157303373)
            {
                if(dastrum.x > 640)
                    dastrum.x = poxlist[dastrum.ID];
                else
                    dastrum.x = oxlist[dastrum.ID];
            }
            else if (Conductor.songPosition >= 156067.4157303373 && Conductor.songPosition < 156235.95505617998)
            {
                dastrum.y = 50 + (Conductor.songPosition - 156067.4157303373) / 168.539325843 + 250;
                strumLine.y = dastrum.y;
            }
            else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
            {
                if (Conductor.songPosition % 2696.62921348 < 1348.31460674)
                    dastrum.y = 50 + 500 * (Conductor.songPosition % 1348.31460674) / 1348.31460674;
                else
                    dastrum.y = 550 - 500 * (Conductor.songPosition % 1348.31460674) / 1348.31460674;
            }
            else if (Conductor.songPosition >= 172584.26966292146 && Conductor.songPosition < 177977.52808988772)
            {
                dastrum.y = 50;
                strumLine.y = 50;
                dastrum.scale.x = 0.7;
                dastrum.scale.y = 0.7;
                if(dastrum.x > 640)
                {
                    dastrum.x =  poxlist[dastrum.ID];
                }
                else
                {
                    dastrum.x = oxlist[dastrum.ID];
                }
            }
            /*else if(Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 102387.64044943838)
            {
                if (Conductor.songPosition % 40 < 20)
                {
                    if (dastrum.ID < 2)
                        dastrum.alpha = 0;
                    else 
                        dastrum.alpha = 1;
                }
                else
                {
                    if (dastrum.ID < 2)
                        dastrum.alpha = 1;
                    else 
                        dastrum.alpha = 0;
                }
                if(dastrum.x<640)
                    dastrum.x = oxlist[1 + dastrum.ID % 2];
                else
                    dastrum.x = poxlist[1 + dastrum.ID % 2];
            }*/
        }
    }
    public static function pspos(dastrum:FlxSprite,strumLine:FlxSprite)
    {
        if(PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 121139.24050632922 && Conductor.songPosition < 145822.78481)
            {
                dastrum.scale.x = 0.7;
                dastrum.scale.y = 0.7;
                dastrum.x = 538 + (poxlist[dastrum.ID] - 538) * FlxMath.fastCos(Conductor.songPosition/1518.98734177 * 3.1415926);
                dastrum.y = 300 - (100+50*dastrum.ID) * FlxMath.fastSin(Conductor.songPosition/1518.98734177 * 3.1415926);
            }
        }
    }
    inline static public function show(daNote:Note):Bool
    {
        if(PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
        {
            if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
            {
                return (daNote.strumTime - Conductor.songPosition) > (96595.74468085116 - 95319.14893617031);
            }
            else if (daNote.strumTime > 26382 && daNote.strumTime < 44114)
            {
                return (Math.abs(daNote.y-300) > Math.abs(((300-sy)/250)) * 360);
            }
            else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
            {
                return (Math.abs(daNote.y-300) > Math.abs(((300-ylist[daNote.noteData])/250)) * 360);
            }
            else 
            {
                return (daNote.y > FlxG.height);
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
        {
            if(
                (daNote.strumTime > 2652 && daNote.strumTime < 12929) ||
                (daNote.strumTime > 156465 && daNote.strumTime < 166741)
            )
            {
                return daNote.strumTime - Conductor.songPosition > (2983.425414364641 - 2651.9337016574586);
            }
            else if(daNote.strumTime > 13259 && daNote.strumTime < 23785)
            {
                return (daNote.y > FlxG.height) || Conductor.songPosition < 13259.668508287292;
            }
            else if(daNote.strumTime > 23867 && daNote.strumTime < 45000)
            {
                return (daNote.y < -daNote.height) || (daNote.y > FlxG.height) || Conductor.songPosition < 23867.403314917123;
            }
            else if(
                (daNote.strumTime > 45082 && daNote.strumTime < 66216) ||
                (daNote.strumTime > 135248 && daNote.strumTime < 145856)
            )
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(daNote.strumTime - 331 >= i)
                        index += 1;
                }
                if (daNote.strumTime > 135248)
                    return Conductor.songPosition < shinelist[index-1]|| Conductor.songPosition < 135248;
                else
                    return Conductor.songPosition < shinelist[index-1]|| Conductor.songPosition < 45082;
            }
            else if(daNote.strumTime > 145856 && daNote.strumTime < 156465)
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(daNote.strumTime >= i)
                        index += 1;
                }
                return (daNote.y < -daNote.height) || (daNote.y > FlxG.height);
            }
            else if(daNote.strumTime > 66298 && daNote.strumTime < 82045)
            {
                return (daNote.y > FlxG.height) || Conductor.songPosition < 66298.34254143645;
            }
            else if(daNote.strumTime > 82209 && daNote.strumTime < 103338)
            {
                return (daNote.strumTime - Conductor.songPosition) > (83204.41988950274 - 82209.94475138119) || Conductor.songPosition < 82209.94475138119;
            }
            else if(daNote.strumTime > 103425 && daNote.strumTime < 135166 && Conductor.songPosition < 124640.8839779005)
            {
                return (daNote.y < -daNote.height) || (daNote.y > FlxG.height) || Conductor.songPosition < 103425.41436464085;
            }
            else 
            {
                return (daNote.y > FlxG.height);
            }
        }
        /*else if(PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
        {
            if(daNote.strumTime >= 60000 && daNote.strumTime < 74766)
            {
                if(daNote.mustPress)
                    return daNote.x > FlxG.height + daNote.width;
                else
                    return daNote.x < -daNote.width;
            }
            else 
                return (daNote.y > FlxG.height);
        }*/
        else if(PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
            {
                if(daNote.mustPress)
                    return daNote.x < 640;
                else
                    return daNote.x > 640;
            }
            else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
            {
                if(daNote.mustPress)
                {
                    switch(daNote.noteData)
                    {
                        case 0:
                            return daNote.x > 900;
                        case 3:
                            return daNote.x < 900;
                        case 1:
                            return daNote.y < 300;
                        default:
                            return daNote.y > 300;
                    }
                }
                else 
                {
                    switch(daNote.noteData)
                    {
                        case 0:
                            return daNote.x > 260;
                        case 3:
                            return daNote.x < 260;
                        case 1:
                            return daNote.y < 300;
                        default:
                            return daNote.y > 300;
                    }
                }
            }
            else if(daNote.strumTime >= 109367 && daNote.strumTime < 121330)
                return daNote.strumTime - Conductor.songPosition > 379.746835444;
            else if(daNote.strumTime >= 121518 && daNote.strumTime < 145633)
                return daNote.strumTime - Conductor.songPosition > 759.493670885;
            else 
                return (daNote.y > FlxG.height);
        }
        else if(PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
                return (Math.abs(daNote.y-300) > Math.abs(((300-sy)/250)) * 360);
            else if(daNote.strumTime >= 156404 && daNote.strumTime < 168456 && Conductor.songPosition < 167191.0112359552)
                return Conductor.songPosition < 156404 || daNote.strumTime - Conductor.songPosition > 2696.62921348;
            else
                return (daNote.y > FlxG.height);
        }
        else 
        {
            return (daNote.y > FlxG.height);
        }
    }
    inline static public function kill(daNote:Note):Bool
    {
        if(PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
        {
            if (Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
            {
                return (Conductor.songPosition - daNote.strumTime) > (1000 / 6);
            }
            else if (daNote.strumTime > 26382 && daNote.strumTime < 44114)
            {
                return ((Math.abs(daNote.y-300) > Math.abs(((300-sy)/250)) * 50) && Conductor.songPosition - daNote.strumTime > 1000 / 6);
            }
            else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
            {
                return ((Math.abs(daNote.y-300) > Math.abs(((300-ylist[daNote.noteData])/250)) * 50) && Conductor.songPosition - daNote.strumTime > 1000 / 6);
            }
            else 
            {
                return daNote.y < -daNote.height;
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
        {
            if(
                (daNote.strumTime > 0 && daNote.strumTime < 12929) ||
                (daNote.strumTime > 156464 && daNote.strumTime < 166741)
            )
            {
                return Conductor.songPosition - daNote.strumTime > (1000 / 6);
            }
            else if(
                (daNote.strumTime > 23867 && daNote.strumTime < 45000) ||
                (daNote.strumTime > 103425 && daNote.strumTime < 135166 && Conductor.songPosition < 124640.8839779005)
            )
            {
                return ((daNote.y < -daNote.height) || (daNote.y > FlxG.height)) && Conductor.songPosition > daNote.strumTime;
            }  
            else if(
                (daNote.strumTime > 45082 && daNote.strumTime < 66216) ||
                (daNote.strumTime > 135248 && daNote.strumTime < 156465)
            )
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(Conductor.songPosition >= i)
                        index += 1;
                }
                if(index % 2 == 1)
                    return daNote.y < -daNote.height;
                else
                    return daNote.y > FlxG.height;
            }
            else if(daNote.strumTime > 82209 && daNote.strumTime < 103338)
            {
                return Conductor.songPosition - daNote.strumTime > (1000 / 6);
            }
            else 
            {
                return daNote.y < -daNote.height;
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
        {
            if(daNote.strumTime >= 60000 && daNote.strumTime < 74766)
                return ((daNote.x < -daNote.width) || (daNote.x > FlxG.width) || (daNote.y < -daNote.height) || (daNote.y > FlxG.height) || (daNote.alpha <= 0)) && Conductor.songPosition > daNote.strumTime;
            else if(daNote.strumTime >= 90000)
                return ((daNote.y < -daNote.height) || (daNote.y > FlxG.height)) && Conductor.songPosition > daNote.strumTime;
            else 
                return daNote.y < -daNote.height;
        }
        else if(PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
            {
                if(daNote.mustPress)
                    return daNote.x > FlxG.width;
                else
                    return daNote.x < -daNote.width;
            }
            else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
            {
                if(daNote.mustPress)
                    return (daNote.x > FlxG.width || daNote.x < 640 || daNote.y < -daNote.height || daNote.y > FlxG.height) && Conductor.songPosition > daNote.strumTime;
                else
                    return (daNote.x > 640 || daNote.x < -daNote.height || daNote.y < -daNote.height || daNote.y > FlxG.height) && Conductor.songPosition > daNote.strumTime;
            }
            else if(daNote.strumTime >= 78987 && daNote.strumTime < 91045)
                return ((daNote.y < -daNote.height) || (daNote.y > FlxG.height)) && Conductor.songPosition > daNote.strumTime;
            else if(daNote.strumTime >= 91139 && daNote.strumTime < 97026)
                return daNote.y > FlxG.height;
            else if(daNote.strumTime >= 97215 && daNote.strumTime < 109178)
            {
                if(daNote.mustPress)
                    return daNote.x < -daNote.width;
                else
                    return daNote.x > FlxG.width;
            }
            else if(daNote.strumTime >= 109367 && daNote.strumTime < 121330)
            {
                return Conductor.songPosition - daNote.strumTime > (1000 / 6);
            }
            else if(daNote.strumTime >= 121518 && daNote.strumTime < 145633)
                return Conductor.songPosition - daNote.strumTime > (1000 / 6);
            else
                return daNote.y < -daNote.height;
        }
        else if(PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
        {
            if(daNote.strumTime >= 48707 && daNote.strumTime < 70029)
                return daNote.y < -daNote.height && Conductor.songPosition > daNote.strumTime + 1000/6;
            else if(Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
                return ((Math.abs(daNote.y-300) > Math.abs(((300-sy)/250)) * 50) && Conductor.songPosition - daNote.strumTime > 1000 / 6);
            else if(daNote.strumTime >= 156404 && daNote.strumTime < 168456 && Conductor.songPosition < 167191.0112359552)
                return Conductor.songPosition > daNote.strumTime + 1000/6;
            else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
                return Conductor.songPosition > daNote.strumTime + 1000/6;
            else 
                return daNote.y < -daNote.height;
        }
        else 
            return daNote.y < -daNote.height;
    }
    inline static public function ups(daNote:Note,strumLine:FlxSprite)
    {
        if(PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
            {
                return 2;
            }
            else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
            {
                if(ylist[daNote.noteData] > 300)
                    return 1;
                else
                    return 2;
            }
            else 
            {
                if(strumLine.y > 300)
                    return 1;
                else
                    return 2;
            }
        }
        else if(PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
        {
            if(daNote.strumTime >= 90000 && daNote.strumTime < 120000)
            {
                if ((Std.int((daNote.strumTime-90000)/7500) % 2 == 0 && daNote.mustPress) || Std.int((daNote.strumTime-90000)/7500) % 2 == 1 && !daNote.mustPress)
                    return 2;
                else
                    return 1;
            }
            else if (daNote.strumTime > 120000)
                if (daNote.mustPress)
                    return 2
                else 
                    return 1;
            else 
                return 2;
        }      
        else if(PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
            {
                if(daNote.mustPress)
                    return 3;
                else
                    return 0;
            }
            else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
                return daNote.noteData;
            else if(daNote.strumTime >= 91139 && daNote.strumTime < 97026)
                return 1;
            else if(daNote.strumTime >= 97215 && daNote.strumTime < 109178)
            {
                if(daNote.mustPress)
                    return 0;
                else
                    return 3;
            }
            else
                return 2;
        }      
        else 
        {
            return 2;
        }
    }
    inline static public function stry(daNote:Note,strumLine:FlxSprite)
        {
            if(PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
            {
                if(Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
                {
                    return strumLine.y;
                }
                else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
                {
                    return ylist[daNote.noteData];
                }
                else 
                {
                    return strumLine.y;
                }
            }
            if(PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
            {
                return 412;
            }
            if(PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
            {
                if((daNote.strumTime >= 45000 && daNote.strumTime < 59766) || (daNote.strumTime >= 45000 && daNote.strumTime < 65625.0 && daNote.mustPress))
                    return ylist[daNote.noteData];
                else if(daNote.strumTime >= 90000)
                {
                    if(daNote.mustPress)
                        return ylist[0];
                    else 
                        return ylist[1];
                }
                else 
                    return strumLine.y;
            }
            if(PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
            {
                if(daNote.strumTime >= 24303 && daNote.strumTime < 30190)
                    return ylist[daNote.noteData];
                if(Conductor.songPosition >= 36455.69620253167 && daNote.strumTime < 48418)
                {
                    if(daNote.mustPress)
                        return 1110;
                    else
                        return 50;
                }
                else if (daNote.strumTime >= 48607 && daNote.strumTime < 60570)
                {
                    if(daNote.mustPress)
                    {
                        switch(daNote.noteData)
                        {
                            case 0:
                                return 690;
                            case 3:
                                return 1110;
                            case 1:
                                return 510;
                            default:
                                return 90;
                        }
                    }
                    else 
                    {
                        switch(daNote.noteData)
                        {
                            case 0:
                                return 50;
                            case 3:
                                return 470;
                            case 1:
                                return 510;
                            default:
                                return 90;
                        }
                    }
                }
                else if(daNote.strumTime >= 91139 && daNote.strumTime < 97026)
                    return 550;
                else if(daNote.strumTime >= 97215 && daNote.strumTime < 109178)
                {
                    if(daNote.mustPress)
                        return 690;
                    else
                        return 520;
                }
                else
                    return strumLine.y;
            }
            else 
            {
                return strumLine.y;
            }
            
        }
}