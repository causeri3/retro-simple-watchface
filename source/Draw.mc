import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Application;


module Dimensions {
    var width, height, cx;

    function init(dc as Dc){
        width = dc.getWidth();
        height = dc.getHeight(); 
        cx = width / 2;
    }
}

class Fields{
    private var barThickness;
    private var fontSmall;
    private var fontBig;

    function init(dc as Dc){
        //Log.showMemoryUsage();
        Settings.getProperties();
        barThickness = Dimensions.width * 0.01;
        fontSmall = WatchUi.loadResource(Rez.Fonts.fontSmall);
        fontBig = WatchUi.loadResource(Rez.Fonts.fontBig);
    }

    function drawBattery(dc as Dc) as Void {
        dc.setPenWidth(Dimensions.width * 0.005);
        var batterySettingString = Settings.getFieldString(Settings.batterySetting);
        if (batterySettingString.equals("None")) {return;}
        var batteryValue = choose_field(batterySettingString);
        if (batteryValue == null) {return;}
        
        dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);

        var w_body = .15*Dimensions.width;
        var h_body = .03*Dimensions.height;
        var w_tip = .01*Dimensions.width;
        var h_tip = h_body*.6;
        var _x = .5*Dimensions.width - w_body/2 - w_tip/2;
        var _y = .9*Dimensions.height;
        dc.drawRectangle(_x, _y, w_body, h_body);  // battery body
        dc.drawRectangle(_x + w_body, (_y + (h_body-h_tip)/2), w_tip, h_tip); // battery tip
    
        // Fill battery level in different color if under 20%
        if ((batterySettingString.equals("Battery Level") || batterySettingString.equals("Body Battery")) 
            && batteryValue <= 20 ) {
            dc.setColor(0xff5555, Graphics.COLOR_TRANSPARENT);
        } 
        var fillWidth = (batteryValue / 100.0) * w_body;  // Scale battery level to fit
        dc.fillRectangle(_x + 1, _y + 1, fillWidth, h_body - 2);
    }

    function drawBar(
        dc as Dc, 
        ptsIndex1 as Number, 
        ptsIndex2 as Number, 
        distance as Number,
        percent as Number){

        dc.setColor(BenDayDotsRectangle.white, BenDayDotsRectangle.bg);
        dc.setPenWidth(barThickness);
        var pt1 = BenDayDotsRectangle.pts[ptsIndex1] as Array<Number>; 
        var pt2 = BenDayDotsRectangle.pts[ptsIndex2] as Array<Number>;

        var x1 = pt1[0] + Dimensions.width*0.01;
        var y1 = pt1[1] + distance;
        var x2 = pt2[0] - Dimensions.width*0.005;
        var y2 = pt2[1] + distance;
        var fillX  = x1 + ((x2 - x1) * (percent / 100.0));

        dc.drawLine(x1, y1, fillX, y2);
    }

    function drawTopBar(dc as Dc){
        var topBarSettingString = Settings.getFieldString(Settings.SettingBarTop);
        if (topBarSettingString.equals("None")) {return;}
        var value = choose_field(topBarSettingString);
        if (value == null) {return;}

        drawBar(dc, 0, 1, barThickness*1.5, value);
    }

    function drawBottomBar(dc as Dc){
        var bottomBarSettingString = Settings.getFieldString(Settings.SettingBarBottom);
        if (bottomBarSettingString.equals("None")) {return;}
        var value = choose_field(bottomBarSettingString);
        if (value == null) {return;}
        
        drawBar(dc, 5, 4, - (barThickness/2), value);
    }

    function drawMain(dc as Dc) as Void {
        var field2SettingString = Settings.getFieldString(Settings.SettingField2);
        var field2Value = choose_field(field2SettingString);
        field2Value = reformatToString(field2Value);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Dimensions.cx, Dimensions.height*.4, fontBig, field2Value, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawTop(dc as Dc) as Void {
        var field1SettingString = Settings.getFieldString(Settings.SettingField1);
        var field1Value = choose_field(field1SettingString);
        field1Value = reformatToString(field1Value);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Dimensions.cx, Dimensions.height*.05, fontSmall, field1Value, Graphics.TEXT_JUSTIFY_CENTER);
    }
     
    function choose_field(settingString) {
        var settingValue;
        
        if (settingString.equals("Calories")) {
            settingValue = getCalories();
        } 
        else if (settingString.equals("Stress Level")) {
            settingValue = getStressLevel();
        }
        else if (settingString.equals("Battery Level")) {
            settingValue = getBatteryLevel();
        }
        else if (settingString.equals("Body Battery")) {
            settingValue = getBodyBattery();
        }
        else if (settingString.equals("Calories Percentage")) {
            settingValue = getCaloriesProgress();
        }
        else if (settingString.equals("Date")) {
            settingValue = getDate();
        }
        else if (settingString.equals("Time")) {
            settingValue = getTime();
        }
        else if (settingString.equals("Heart Rate")) {
            settingValue = getHeartRate();
        }
        else if (settingString.equals("Active Minutes This Week")) {
            settingValue = getActiveMinutes();
        }
        else if (settingString.equals("Steps")) {
            settingValue = getSteps();
        }
        else if (settingString.equals("Steps Percentage")) {
            settingValue = getStepsProgress();
        }
        else if (settingString.equals("None")) {
            settingValue = "";
        }
        else {
            settingValue = "";
        }
        return settingValue;
    }


    function update_fields(dc as Dc) as Void {
        drawBattery(dc);
        drawTopBar(dc);
        drawBottomBar(dc);
        drawMain(dc);
        drawTop(dc);
    }
}


module BenDayDotsRectangle {
    var spacing = Dimensions.width/30;
    var r = (spacing * 0.45);
    var bg = 0x000000;
    var fg;

    var white = 0xFFFFFF;
    var _w = .9;
    var _h = .65;
    var w = Dimensions.width * _w;
    var h = Dimensions.height * _h;
    // center
    var cy = Dimensions.height * ((1 - _h) /2);
    var cx = Dimensions.width * ((1 - _w) /2);
   //var cx = 0;

    // octagon distance to outer edged of ben day rectangle
    var m = Dimensions.width * 0.125;
    // octagon length of 45° corners
    var b = Dimensions.width * 0.07;

    var L = cx + m;
    var T = cy + m;
    var R = cx + w - m;
    var B = cy + h - m;

    // octagon points
    var pts = [
        [L + b, T], // left end of top horizontal
        [R - b, T], // right end of top horizontal
        [R, T + b], // upper-right 45° corner
        [R, B - b], // right vertical
        [R - b, B], // right end of bottom horizontal
        [L + b, B], // left end of bottom horizontal
        [L, B - b], // lower-left 45° corner
        [L, T + b] // left vertical
        ] as Array<Array<Number>>;

    var benDayDotThickness = Dimensions.width * 0.125;
    var spacingWhiteOctogon = Dimensions.width * 0.1;

    function drawRectangleLine(bdc as Dc, penWidth as Number, spacing as Number, colour as Number){
        var L2 = L - spacing;
        var T2 = T - spacing;
        var R2 = R + spacing;
        var B2 = B + spacing;
        var d = spacing - penWidth / 2.0;
        var b2 = b + d * (2 - Math.sqrt(2));

        var pts2 = [
            [L2 + b2, T2],
            [R2 - b2, T2],
            [R2, T2 + b2],
            [R2, B2 - b2],
            [R2 - b2, B2],
            [L2 + b2, B2],
            [L2, B2 - b2],
            [L2, T2 + b2]
            ];

        bdc.setColor(colour, bg);
        bdc.setPenWidth(penWidth);
        for (var i = 0; i < pts2.size(); i += 1) {
            var a = pts2[i];
            var bpt = pts2[(i + 1) % pts2.size()];
            bdc.drawLine(a[0], a[1], bpt[0], bpt[1]);
            }
        }


    function drawBedDayDotsRectangle(bdc as Dc){
        fg = Application.Properties.getValue("fgColor");
        bdc.setColor(fg, bg);
        var row = 0;
        var y = cy;
        var yStep = Math.round(spacing * (Math.sqrt(3) / 2.0));

        while (y < cy + h) {
            var x = cx;
            x += (((row % 2) == 0) ? (spacing / 2) : spacing);
            while (x < cx + w) {
                bdc.fillCircle(x as Number, y as Number, r as Number);
                x += spacing;
            }
            row += 1;
            y += yStep;
        }
    }

    function build() as Graphics.BufferedBitmap? {
        fg = Application.Properties.getValue("fgColor");
        var palette = [ bg, fg, white ];
        var bb;
            // Prefer createBufferedBitmap if present (API Level 4.0.0 )
            if (Graphics has :createBufferedBitmap) {
                bb = Graphics.createBufferedBitmap({
                    :width  => Dimensions.width,
                    :height => Dimensions.height,
                    :palette => palette
                 }).get();
            // legacy constructor (API ≥2.3.0, deprecated after ConnectIQ version 4.0.0.)
            } else if (Graphics has :BufferedBitmap) {
                bb = new Graphics.BufferedBitmap({
                    :width  => Dimensions.width,
                    :height => Dimensions.height,
                    :palette => palette
                });
            } else {
                return null;
            }


            // bb = new Graphics.BufferedBitmap({
            //         :width  => Dimensions.width,
            //         :height => Dimensions.height,
            //         :palette => palette
            //     });

            var bdc = bb.getDc();
            drawBedDayDotsRectangle(bdc);
            bdc.setColor(bg, bg);
            bdc.fillPolygon(pts);
            drawRectangleLine(bdc, Dimensions.width * 0.1, benDayDotThickness, bg);
            drawRectangleLine(bdc, Dimensions.width * 0.005, spacingWhiteOctogon, white);

        return bb;
    }
}

