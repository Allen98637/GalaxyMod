package;

import haxe.Exception;
import flixel.FlxSprite;
import Song.SwagSong;
import flixel.math.FlxMath;
import Std;
import flixel.FlxG;
import openfl.Lib;
import openfl.system.Capabilities;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.FixedScaleMode;

using StringTools;

class PlayWindow
{
    public static var res:Array<Int> = [0,0,0,0];
    public static var stage:Array<Int> = [0,0];
    public static var count:Int = 0;
    public static var suc:Int = 0;
    public static var pos:Array<Int> = [0,0];
    public static var camz:Float = 1;
    public static function nreset()
    {
        count = 0;
        pos = [0,0];
        suc = 0;
        camz = 1;
    }
    public static function reset()
    {
        res = [Lib.application.window.x,Lib.application.window.y,Lib.application.window.width,Lib.application.window.height];
        stage = [Std.int(Capabilities.screenResolutionX),Std.int(Capabilities.screenResolutionY)];
        FlxG.scaleMode = new RatioScaleMode();
    }
    public static function back(camHUD:FlxCamera)
    {
        Lib.application.window.move(res[0], res[1]);
        Lib.application.window.resize(res[2], res[3]);
        camHUD.zoom = 1;
        camHUD.x = 0;
        camz = 1;
        FlxG.scaleMode = new RatioScaleMode();
    }
    public static function move(camHUD:FlxCamera)
    {
        if(PlayState.SONG.song.toLowerCase() == "cyber" && PlayState.storyDifficulty != 0)
        {
            FlxG.fullscreen = false;
            if(Conductor.songPosition < 5393.258426966292)
            {
                reset();
            }
            else if (Conductor.songPosition >= 5393.258426966292 && Conductor.songPosition < 10702.247191011236)
            {//640 360
                var tar:Array<Int> = [Std.int(stage[0]/2 - 320), Std.int(stage[1]/2 - 180)];
                Lib.application.window.resize(Std.int(640 + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (res[2]-640)) , Std.int(360 + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (res[3]-360)));
                Lib.application.window.move(Std.int(tar[0] + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (res[0]-tar[0])), Std.int(tar[1] + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (res[1]-tar[1])));
            }
            else if (Conductor.songPosition >= 10786.516853932584 && Conductor.songPosition < 16089.887640449437)
            {
                var bef:Array<Int> = [Std.int(stage[0]/2 - 320), Std.int(stage[1]/2 - 180)];
                var tar:Array<Int> = [Std.int(stage[0]/2 - 320), Std.int(stage[1] * 3 / 10 - 180)];
                Lib.application.window.resize(640,360);
                Lib.application.window.move(Std.int(tar[0] + (16089.887640449437 - Conductor.songPosition) / (5303.37078652) * (bef[0]-tar[0])), Std.int(tar[1] + (16089.887640449437 - Conductor.songPosition) / (5303.37078652) * (bef[1]-tar[1])));
            }
            else if (Conductor.songPosition >= 16179.775280898875 && Conductor.songPosition < 25617.977528089887)
            {
                Lib.application.window.resize(640,360);
                Lib.application.window.move(Std.int(FlxMath.fastSin((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (stage[0] * 2 / 10) + stage[0] / 2 - 320), Std.int(FlxMath.fastCos((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (stage[1] * -2 / 10) + stage[1] / 2 - 180));
            }
            else if (Conductor.songPosition >= 25617.977528089887 && Conductor.songPosition < 26629.213483146068)
            {
                Lib.application.window.resize(640,360);
                Lib.application.window.move(Std.int(stage[0]*3/10-320),Std.int(stage[1]/2-180));
            }
            else if (Conductor.songPosition >= 26629.213483146068 && Conductor.songPosition < 26882.02247191011)
            {
                Lib.application.window.resize(640,360);
                Lib.application.window.move(Std.int(stage[0]*3/10-320), Std.int((stage[1]/-4) - 180 + (26882.02247191011 - Conductor.songPosition) / (252.808988764) * (stage[1]/2 + stage[1]/4)));
            }
            else if (Conductor.songPosition >= 26966.29213483146 && Conductor.songPosition < 37673.49636483807)
            {
                Lib.application.window.resize(640,360);
                if (Conductor.songPosition < 27303.370786516854)
                    Lib.application.window.move(Std.int(stage[0] - (Conductor.songPosition - 26966.29213483146)/337.078651685 * 320), Std.int(stage[1]/2-180));
                else if (Conductor.songPosition < 32022.47191011236)
                    Lib.application.window.move(Std.int(stage[0]-320 - (Conductor.songPosition - 27303.370786516854)/4719.1011236 * 160), Std.int(stage[1]/2-180));
                else if (Conductor.songPosition < 32359.55056179775)
                    Lib.application.window.move(Std.int(stage[0]-480 - (Conductor.songPosition - 32022.47191011236)/337.078651685 * (stage[0]-320)), Std.int(stage[1]/2-180));
                else 
                    Lib.application.window.move(Std.int(-160 - (Conductor.songPosition - 33707.86516853933)/4719.1011236 * (160)), Std.int(stage[1]/2-180));
            }
            else if(Conductor.songPosition >= 37752.808988764045 && Conductor.songPosition < 48117.9775281)
            {
                if (Std.int((Conductor.songPosition-37752.808988764045) / 674.15730337) >= count)
                {
                    pos = [FlxG.random.int(480,stage[0]-480),FlxG.random.int(270,stage[1]-270)];
                    count += 1;
                }
                if (Std.int((Conductor.songPosition-37752.808988764045) / 337.078651685) % 2 == 0)
                {
                    Lib.application.window.resize(960,540);
                }
                else 
                {
                    Lib.application.window.resize(Std.int(960 - ((Conductor.songPosition-37752.808988764045) % 337.078651685)/337.078651685 * 640), Std.int(540 - ((Conductor.songPosition-37752.808988764045) % 337.078651685)/337.078651685 * 360));
                }
                Lib.application.window.move(Std.int(pos[0]-Lib.application.window.width/2),Std.int(pos[1]-Lib.application.window.height/2));
            }
            else if(Conductor.songPosition >= 48117.9775281 && Conductor.songPosition < 48455.05617977528)
            {
                Lib.application.window.resize(960,540);
                Lib.application.window.move(Std.int(pos[0]-480),Std.int(pos[1] + (Conductor.songPosition - 48117.9775281) / 337.078651685 * (stage[1]*1.3-pos[1]) - 270));
            }
            else if(Conductor.songPosition >= 48539.32584269663 && Conductor.songPosition < 70112.3595505)
            {
                count = 0;
                FlxG.scaleMode = new FixedScaleMode();
                Lib.application.window.resize(480,640);
                camz = 0.9;
                if(Conductor.songPosition < 48707.86516853933)
                {
                    Lib.application.window.move(Std.int(stage[0]*0.3-240),Std.int(stage[1]*(-0.3)+((Conductor.songPosition-48539.32584269663)/168.539325843)*(stage[1]*0.8)-320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 58988.76404494382)
                {
                    Lib.application.window.move(Std.int(stage[0]*0.3-240),Std.int(stage[1]*(0.5)+((Conductor.songPosition-48707.86516853933)/10280.8988764)*144-320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 59325.84269662921)
                {
                    Lib.application.window.move(Std.int(stage[0]*0.3-240),Std.int(stage[1]*(0.5)+144+((Conductor.songPosition-58988.76404494382)/337.078651685)*(stage[1]*0.8-144)-320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 59494.38202247191)
                {
                    Lib.application.window.move(Std.int(stage[0]*0.7-240),Std.int(stage[1]*(-0.3)+((Conductor.songPosition-59325.84269662921)/168.539325843)*(stage[1]*0.8)-320));
                    camHUD.x = -260;
                }
                else if (Conductor.songPosition < 69775.28089887642)
                {
                    Lib.application.window.move(Std.int(stage[0]*0.7-240),Std.int(stage[1]*(0.5)+((Conductor.songPosition-59494.38202247191)/10280.8988764)*144-320));
                    camHUD.x = -260;
                }
                else if (Conductor.songPosition < 70112.3595505)
                {
                    Lib.application.window.move(Std.int(stage[0]*0.7-240),Std.int(stage[1]*(0.5)+144+((Conductor.songPosition-69775.28089887642)/337.078651685)*(stage[1]*0.8-144)-320));
                    camHUD.x = -260;
                }
            }
            else if(Conductor.songPosition >= 70112.35955056181 && Conductor.songPosition < 70280.8988764045)
            {
                camHUD.x = 0;
                camz = 1;
                FlxG.scaleMode = new RatioScaleMode();
                Lib.application.window.resize(640,360);
                Lib.application.window.move(Std.int(stage[0]/2-320),Std.int(stage[1]-(Conductor.songPosition-70112.35955056181)/168.539325843 * (stage[1]/2 + 55)));
            }
            else if(Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
            {
                Lib.application.window.resize(640,360);
                if(Conductor.songPosition >= 80898.87640449445)
                    Lib.application.window.move(Std.int(stage[0]/2+FlxMath.fastSin(((Conductor.songPosition-80898.87640449445)/1348.31460674)*3.1415926535)*stage[0]/5 - 320),Std.int(stage[1]/2+FlxMath.fastSin(((Conductor.songPosition-70280.8988764045)/1348.31460674-0.5)*3.1415926535)*125 - 180));
                else 
                    Lib.application.window.move(Std.int(stage[0]/2-320),Std.int(stage[1]/2+FlxMath.fastSin(((Conductor.songPosition-70280.8988764045)/1348.31460674-0.5)*3.1415926535)*125 - 180));
            }
            else if(Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 102471.91011235974)
            {
                Lib.application.window.resize(640,360);
                if (Conductor.songPosition % 40 < 20)
                {
                    Lib.application.window.move(Std.int(FlxMath.fastSin(((Conductor.songPosition - 16179.775280898875) / (2696.62921348)+1) * 3.1415926535) * (stage[0] * 2 / 10) + stage[0] / 2 - 320), Std.int(FlxMath.fastCos(((Conductor.songPosition - 16179.775280898875) / (2696.62921348)+1) * 3.1415926535) * (stage[1] * -2 / 10) + stage[1] / 2 - 180));
                }
                else 
                {
                    Lib.application.window.move(Std.int(FlxMath.fastSin((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (stage[0] * 2 / 10) + stage[0] / 2 - 320), Std.int(FlxMath.fastCos((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (stage[1] * -2 / 10) + stage[1] / 2 - 180));
                }
            }
            else if (Conductor.songPosition >= 102471.91011235974 && Conductor.songPosition < 113258.42696629238)
            {
                Lib.application.window.resize(640,360);
                if((Conductor.songPosition-102471.91011235974)%674.157303371 < 337.078651685)
                    Lib.application.window.move(Std.int(stage[0]*4/10+(((Conductor.songPosition-102471.91011235974)%337.078651685)/337.078651685)*stage[0]/5-320),Std.int(stage[1]/2-Math.abs(FlxMath.fastSin(((Conductor.songPosition-102471.91011235974)%337.078651685)/337.078651685*3.1415926))*stage[1]/10-180));
                else 
                    Lib.application.window.move(Std.int(stage[0]*6/10-(((Conductor.songPosition-102471.91011235974)%337.078651685)/337.078651685)*stage[0]/5-320),Std.int(stage[1]/2-Math.abs(FlxMath.fastSin(((Conductor.songPosition-102471.91011235974)%337.078651685)/337.078651685*3.1415926))*stage[1]/10-180));
            }
            else if (Conductor.songPosition >= 113258.42696629238 && Conductor.songPosition < 123707.86516853962)
            {
                Lib.application.window.resize(640,360);
                if ((Conductor.songPosition-102471.91011235974)%674.157303371 < 337.078651685)
                    Lib.application.window.move(Std.int(stage[0]/2-640),Std.int(stage[1]/2 - 180));
                else
                    Lib.application.window.move(Std.int(stage[0]/2),Std.int(stage[1]/2 - 180));
            }
            else if (Conductor.songPosition >= 123707.86516853962 && Conductor.songPosition < 156235.95505617998)
            {
                count = 0;
                FlxG.scaleMode = new FixedScaleMode();
                if (Conductor.songPosition < 145617.97752809015)
                    camz = 0.9;
                if (Conductor.songPosition < 124044.94382022502)
                {
                    Lib.application.window.resize(480,1);
                    Lib.application.window.move(Std.int(stage[0]*0.3-240),Std.int(stage[1]/2 - 320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 124213.48314606771)
                {
                    Lib.application.window.resize(480,Std.int((Conductor.songPosition - 124044.94382022502)/168.539325843*640));
                    Lib.application.window.move(Std.int(stage[0]*0.3-240),Std.int(stage[1]/2 - 320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 134494.38202247224)
                {
                    Lib.application.window.resize(480,640 + Std.int((Conductor.songPosition - 124213.48314606771)/10280.8988764*80));
                    Lib.application.window.move(Std.int(stage[0]*0.3-240),Std.int(stage[1]/2 - 320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 134662.92134831494)
                {
                    Lib.application.window.resize(480,720 - Std.int((Conductor.songPosition - 134494.38202247224)/168.539325843*719));
                    Lib.application.window.move(Std.int(stage[0]*0.3 + (Conductor.songPosition - 134494.38202247224)/168.539325843*(stage[0]*0.4))-240,Std.int(stage[1]/2 - 320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 134831.46067415763)
                {
                    Lib.application.window.resize(480,1);
                    Lib.application.window.move(Std.int(stage[0]*0.7)-240,Std.int(stage[1]/2 - 320));
                    camHUD.x = 320;
                }
                else if (Conductor.songPosition < 135000.00000000032)
                {
                    Lib.application.window.resize(480,Std.int((Conductor.songPosition - 134831.46067415763)/168.539325843*640));
                    Lib.application.window.move(Std.int(stage[0]*0.7)-240,Std.int(stage[1]/2 - 320));
                    camHUD.x = -260;
                }
                else if (Conductor.songPosition < 145280.89887640477)
                {
                    Lib.application.window.resize(480,640+ Std.int((Conductor.songPosition - 135000.00000000032)/10280.8988764*80));
                    Lib.application.window.move(Std.int(stage[0]*0.7)-240,Std.int(stage[1]/2 - 320));
                    camHUD.x = -260;
                }
                else if (Conductor.songPosition < 145449.43820224746)
                {
                    Lib.application.window.resize(480 + Std.int((Conductor.songPosition - 145280.89887640477)/168.539325843*160),720 - Std.int((Conductor.songPosition - 145280.89887640477)/168.539325843*719));
                    Lib.application.window.move(Std.int(stage[0]*0.7-240 - (Conductor.songPosition - 145280.89887640477)/168.539325843 * (stage[0]*0.2+80)),Std.int(stage[1]/2 - 320 + (Conductor.songPosition - 145280.89887640477)/168.539325843 * 140));
                    camHUD.x = -260;
                }
                else if (Conductor.songPosition < 145617.97752809015)
                {
                    Lib.application.window.resize(640,1);
                    Lib.application.window.move(Std.int(stage[0]/2)-320,Std.int(stage[1]/2 - 180));
                    camHUD.x = -260;
                }
                else if (Conductor.songPosition < 145786.51685393284)
                {
                    Lib.application.window.resize(640,Std.int((Conductor.songPosition - 145617.97752809015)/168.539325843*320));
                    Lib.application.window.move(Std.int(stage[0]/2)-320,Std.int(stage[1]/2 - 180));
                    camHUD.x = 0;
                    camz = 0.45;
                    PlayState.defaultCamZoom = 0.425;
                }
                else if (Conductor.songPosition < 156067.4157303373)
                {
                    Lib.application.window.resize(640, 320 + Std.int((Conductor.songPosition - 145786.51685393284)/10280.8988764*40));
                    Lib.application.window.move(Std.int(stage[0]/2)-320,Std.int(stage[1]/2 - 180));
                    camHUD.x = 0;
                    camz = 0.5;
                    PlayState.defaultCamZoom = 0.425;
                }
                else 
                {
                    Lib.application.window.resize(640, 360);
                    Lib.application.window.move(Std.int(stage[0]/2 -320),Std.int(stage[1]/2 - (Conductor.songPosition - 156067.4157303373)/168.539325843*stage[1]/5) - 180);
                    camHUD.x = 0;
                    camz = 0.5;
                    PlayState.defaultCamZoom = 0.425;
                }
            }
            else if (Conductor.songPosition >= 156404.49438202268 && Conductor.songPosition < 167106.74157303385)
            {
                camz = 1;
                PlayState.defaultCamZoom = 0.85;
                FlxG.scaleMode = new RatioScaleMode();
                Lib.application.window.resize(640,360);
                Lib.application.window.move(Std.int(FlxMath.fastSin((Conductor.songPosition - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (stage[0] * 2 / 10) + stage[0] / 2 - 320), Std.int(FlxMath.fastCos((Conductor.songPosition - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (stage[1] * -2 / 10) + stage[1] / 2 - 180));
            }
            else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
            {
                Lib.application.window.resize(640,360);
                switch(Std.int((Conductor.songPosition - 167191.0112359552)/337.078651685)%4)
                {
                    case 0:
                        if (Conductor.songPosition % 40 < 20)
                            Lib.application.window.move(Std.int(stage[0]/2 - 480),Std.int(stage[1]/2-360));
                        else
                            Lib.application.window.move(Std.int(stage[0]/2 - 160),Std.int(stage[1]/2));
                    case 1:
                        if (Conductor.songPosition % 40 < 20)
                            Lib.application.window.move(Std.int(stage[0]/2 - 480 + 320 * ((Conductor.songPosition - 167191.0112359552)%337.078651685) / 337.078651685),Std.int(stage[1]/2-360));
                        else
                            Lib.application.window.move(Std.int(stage[0]/2 - 160 - 320 * ((Conductor.songPosition - 167191.0112359552)%337.078651685) / 337.078651685),Std.int(stage[1]/2));
                    case 2:
                        if (Conductor.songPosition % 40 < 20)
                            Lib.application.window.move(Std.int(stage[0]/2 - 160),Std.int(stage[1]/2-360));
                        else
                            Lib.application.window.move(Std.int(stage[0]/2 - 480),Std.int(stage[1]/2));
                    case 3:
                        if (Conductor.songPosition % 40 < 20)
                            Lib.application.window.move(Std.int(stage[0]/2 - 160),Std.int(stage[1]/2-360 + 360 * ((Conductor.songPosition - 167191.0112359552)%337.078651685) / 337.078651685));
                        else
                            Lib.application.window.move(Std.int(stage[0]/2 - 480),Std.int(stage[1]/2 - 360 * ((Conductor.songPosition - 167191.0112359552)%337.078651685) / 337.078651685));
                }
            }
            else if (Conductor.songPosition >= 172584.26966292146 && Conductor.songPosition < 177977.52808988772)
            {
                Lib.application.window.resize(640,360);
                if (Conductor.songPosition % 1348.31460674 < 674.15730337)
                {
                    if (Conductor.songPosition % 40 < 20)
                        Lib.application.window.move(Std.int(stage[0]/2 + 320 * FlxMath.fastSin((Conductor.songPosition%674.15730337)/674.15730337 * 3.1415926535) - 320),Std.int(stage[1]/2-180));
                    else
                        Lib.application.window.move(Std.int(stage[0]/2 - 320 * FlxMath.fastSin((Conductor.songPosition%674.15730337)/674.15730337 * 3.1415926535) - 320),Std.int(stage[1]/2-180));
                }
                else
                {
                    if (Conductor.songPosition % 40 < 20)
                        Lib.application.window.move(Std.int(stage[0]/2 - 320),Std.int(stage[1]/2 +180 * FlxMath.fastSin((Conductor.songPosition%674.15730337)/674.15730337 * 3.1415926535) - 180));
                    else
                        Lib.application.window.move(Std.int(stage[0]/2 - 320),Std.int(stage[1]/2 -180 * FlxMath.fastSin((Conductor.songPosition%674.15730337)/674.15730337 * 3.1415926535) - 180));
                }
            }
        }
    }
}