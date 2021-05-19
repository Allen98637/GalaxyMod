package;

import haxe.Exception;
import flixel.FlxSprite;
import Song.SwagSong;
import flixel.math.FlxMath;
import Std;
import flixel.FlxG;
import openfl.Lib;

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
    public static var shinelist:Array<Float> = [45082.87292817678,46408.83977900551,47734.80662983424,49060.77348066297,49723.75690607733,
        50386.740331491696,51712.707182320424,53038.67403314915,54364.64088397788,55027.624309392246,
        55690.60773480661,57016.57458563534,58342.54143646407,59668.508287292796,60331.49171270716,60662.98342541434,
        60994.475138121525,62320.44198895025,63646.40883977898,64972.37569060771,65635.35911602208,65966.85082872926,135248.61878453035,
        136574.58563535908,137900.5524861878,139226.51933701654,139889.5027624309,140552.48618784526,141878.453038674,143204.41988950272,
        144530.38674033145,145193.37016574582,145856.35359116018,147182.3204419889,148508.28729281764,149834.25414364637,150497.23756906073,
        151160.2209944751,152486.18784530382,153812.15469613255,155138.12154696128,155801.10497237564
    ];

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
                if (2.7 + (2.7 / 1000) * (Conductor.songPosition - daNote.strumTime) > 0)
                    daNote.y = daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed*1.5, 2)) - (1.35 * 0.45 * (Conductor.songPosition - daNote.strumTime) * (Conductor.songPosition - daNote.strumTime) / 1000));
                else 
                    daNote.y = 1000;
                if(daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('hold'))
                {
                    daNote.scale.y= Conductor.stepCrochet / 100 * 1.5 * (PlayState.SONG.speed * 1.5 - 2.7 * (Conductor.songPosition - daNote.strumTime) / 1000);
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
                    daNote.scale.y= Conductor.stepCrochet / 100 * 1.5 * 1;
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
                if (daNote.strumTime > 61276 && daNote.sustainLength == 0 && !daNote.isSustainNote)
                    daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 2, 2)));
                else
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
            else if(
                (daNote.strumTime > 45082 && daNote.strumTime < 55525) ||
                (daNote.strumTime > 135248 && daNote.strumTime < 145856)
            )
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(daNote.strumTime >= i)
                        index += 1;
                }
                if(index % 2 == 1)
                    daNote.y = (50 - (Conductor.songPosition - daNote.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
                else
                    daNote.y = (550 + (Conductor.songPosition - daNote.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
            }
            else if (daNote.strumTime > 145856 && daNote.strumTime < 156465)
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
            else if(daNote.strumTime > 55690 && daNote.strumTime < 66216)
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(daNote.strumTime >= i)
                        index += 1;
                }
                if (daNote.mustPress)
                    daNote.x = pxlist[daNote.noteData];
                else
                    daNote.x = xlist[daNote.noteData];
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
                daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
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
            else if(Conductor.songPosition > 55690.60773480661 && Conductor.songPosition < 66215.46961325964)
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(Conductor.songPosition >= i)
                        index += 1;
                }
                for(i in 0...4)
                {
                    xlist[i] = oxlist[(i + index - 1) % 4];
                    pxlist[i] = poxlist[(i + index - 1) % 4];
                }
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
                    if(daNote.strumTime >= i)
                        index += 1;
                }
                return Conductor.songPosition < shinelist[index-1];
            }
            else if(daNote.strumTime > 145856 && daNote.strumTime < 156465)
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(daNote.strumTime >= i)
                        index += 1;
                }
                return (daNote.y < -daNote.height) || (daNote.y > FlxG.height) || Conductor.songPosition < 145856.35359116018;
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
                (daNote.strumTime > 135248 && daNote.strumTime < 145856)
            )
            {
                var index:Int = 0;
                for(i in shinelist)
                {
                    if(daNote.strumTime >= i)
                        index += 1;
                }
                if(index % 2 == 1)
                    return daNote.y < -daNote.height;
                else
                    return daNote.y > FlxG.height;
            }
            else if(daNote.strumTime > 145856 && daNote.strumTime < 156465)
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
        else 
            return daNote.y < -daNote.height;
    }
    inline static public function ups(daNote:Note,strumLine:FlxSprite):Bool
    {
        if(PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
        {
            if(Conductor.songPosition >= 95319.14893617031 && daNote.strumTime >= 95319 && daNote.strumTime < 122412)
            {
                return true;
            }
            else if (daNote.strumTime >= 68085 && daNote.strumTime <= 96880)
            {
                if(ylist[daNote.noteData] > 300)
                    return false;
                else
                    return true;
            }
            else 
            {
                if(strumLine.y > 300)
                    return false;
                else
                    return true;
            }
        }
        else 
        {
            return true;
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
            else 
            {
                return strumLine.y;
            }
        }
}