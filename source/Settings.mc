import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

module Settings {
    var SettingField1;
    var SettingField2;
    var SettingBarTop;
    var SettingBarBottom;
    var batterySetting;
    var stressScoreSetting;
    var caloriesGoal;
    var stepsGoal;
    var fgColor;


    function getOrDefault(key, defaultValue, expectedType) {
        var value = Application.Properties.getValue(key);
        return (value != null && value instanceof expectedType) ? value : defaultValue;
    }
    // default values are workaround for non-reproducable (in the simulator) crash: 
    // Error: Unexpected Type Error\n- **Details**: Failed invoking <symbol>
    // Affected Firmware: 006-B4261-00 (14.15), 006-B3838-00 (5.10), 006-B3704-00 (19.05), 006-B3703-00 (19.05), 006-B3536-00 (8.00), 006-B4532-00 (15.32)
    // in line: var fieldResource = getFieldResource(fieldId);

    function getProperties() {
        SettingField1 = getOrDefault("Field1", 4, Lang.Number);
        SettingField2 = getOrDefault("Field2", 5, Lang.Number);
        SettingBarTop = getOrDefault("barTop", 2, Lang.Number);
        SettingBarBottom = getOrDefault("barBottom", 6, Lang.Number);
        batterySetting = getOrDefault("BatteryField", 11, Lang.Number);
        stepsGoal = getOrDefault("stepsGoal", 10000, Lang.Number);
        caloriesGoal = getOrDefault("caloriesGoal", 2000, Lang.Number);
        fgColor = getOrDefault("fgColor", 0x5555FF, Lang.Number);
    }



    const fieldsMap = {
        0 => Rez.Strings.none,
        1 => Rez.Strings.heart,
        2 => Rez.Strings.stress,
        3 => Rez.Strings.calories,
        4 => Rez.Strings.date,
        5 => Rez.Strings.time,
        6 => Rez.Strings.body,
        7 => Rez.Strings.caloriesPerc,
        8 => Rez.Strings.steps,
        9 => Rez.Strings.stepsPerc,
        10 => Rez.Strings.minutes,
        11 => Rez.Strings.battery,
    };

      const colorList = [
        0x000000,0x000055,0x0000AA,0x0000FF,
        0x005500,0x005555,0x0055AA,0x0055FF,
        0x00AA00,0x00AA55,0x00AAAA,0x00AAFF,
        0x00FF00,0x00FF55,0x00FFAA,0x00FFFF,
        0x550000,0x550055,0x5500AA,0x5500FF,
        0x555500,0x555555,0x5555AA,0x5555FF,
        0x55AA00,0x55AA55,0x55AAAA,0x55AAFF,
        0x55FF00,0x55FF55,0x55FFAA,0x55FFFF,
        0xAA0000,0xAA0055,0xAA00AA,0xAA00FF,
        0xAA5500,0xAA5555,0xAA55AA,0xAA55FF,
        0xAAAA00,0xAAAA55,0xAAAAAA,0xAAAAFF,
        0xAAFF00,0xAAFF55,0xAAFFAA,0xAAFFFF,
        0xFF0000,0xFF0055,0xFF00AA,0xFF00FF,
        0xFF5500,0xFF5555,0xFF55AA,0xFF55FF,
        0xFFAA00,0xFFAA55,0xFFAAAA,0xFFAAFF,
        0xFFFF00,0xFFFF55,0xFFFFAA,0xFFFFFF
    ];

    const colorStringMap = {
        0x000000 => Rez.Strings.c_000000,
        0x000055 => Rez.Strings.c_000055,
        0x0000AA => Rez.Strings.c_0000AA,
        0x0000FF => Rez.Strings.c_0000FF,
        0x005500 => Rez.Strings.c_005500,
        0x005555 => Rez.Strings.c_005555,
        0x0055AA => Rez.Strings.c_0055AA,
        0x0055FF => Rez.Strings.c_0055FF,
        0x00AA00 => Rez.Strings.c_00AA00,
        0x00AA55 => Rez.Strings.c_00AA55,
        0x00AAAA => Rez.Strings.c_00AAAA,
        0x00AAFF => Rez.Strings.c_00AAFF,
        0x00FF00 => Rez.Strings.c_00FF00,
        0x00FF55 => Rez.Strings.c_00FF55,
        0x00FFAA => Rez.Strings.c_00FFAA,
        0x00FFFF => Rez.Strings.c_00FFFF,
        0x550000 => Rez.Strings.c_550000,
        0x550055 => Rez.Strings.c_550055,
        0x5500AA => Rez.Strings.c_5500AA,
        0x5500FF => Rez.Strings.c_5500FF,
        0x555500 => Rez.Strings.c_555500,
        0x555555 => Rez.Strings.c_555555,
        0x5555AA => Rez.Strings.c_5555AA,
        0x5555FF => Rez.Strings.c_5555FF,
        0x55AA00 => Rez.Strings.c_55AA00,
        0x55AA55 => Rez.Strings.c_55AA55,
        0x55AAAA => Rez.Strings.c_55AAAA,
        0x55AAFF => Rez.Strings.c_55AAFF,
        0x55FF00 => Rez.Strings.c_55FF00,
        0x55FF55 => Rez.Strings.c_55FF55,
        0x55FFAA => Rez.Strings.c_55FFAA,
        0x55FFFF => Rez.Strings.c_55FFFF,
        0xAA0000 => Rez.Strings.c_AA0000,
        0xAA0055 => Rez.Strings.c_AA0055,
        0xAA00AA => Rez.Strings.c_AA00AA,
        0xAA00FF => Rez.Strings.c_AA00FF,
        0xAA5500 => Rez.Strings.c_AA5500,
        0xAA5555 => Rez.Strings.c_AA5555,
        0xAA55AA => Rez.Strings.c_AA55AA,
        0xAA55FF => Rez.Strings.c_AA55FF,
        0xAAAA00 => Rez.Strings.c_AAAA00,
        0xAAAA55 => Rez.Strings.c_AAAA55,
        0xAAAAAA => Rez.Strings.c_AAAAAA,
        0xAAAAFF => Rez.Strings.c_AAAAFF,
        0xAAFF00 => Rez.Strings.c_AAFF00,
        0xAAFF55 => Rez.Strings.c_AAFF55,
        0xAAFFAA => Rez.Strings.c_AAFFAA,
        0xAAFFFF => Rez.Strings.c_AAFFFF,
        0xFF0000 => Rez.Strings.c_FF0000,
        0xFF0055 => Rez.Strings.c_FF0055,
        0xFF00AA => Rez.Strings.c_FF00AA,
        0xFF00FF => Rez.Strings.c_FF00FF,
        0xFF5500 => Rez.Strings.c_FF5500,
        0xFF5555 => Rez.Strings.c_FF5555,
        0xFF55AA => Rez.Strings.c_FF55AA,
        0xFF55FF => Rez.Strings.c_FF55FF,
        0xFFAA00 => Rez.Strings.c_FFAA00,
        0xFFAA55 => Rez.Strings.c_FFAA55,
        0xFFAAAA => Rez.Strings.c_FFAAAA,
        0xFFAAFF => Rez.Strings.c_FFAAFF,
        0xFFFF00 => Rez.Strings.c_FFFF00,
        0xFFFF55 => Rez.Strings.c_FFFF55,
        0xFFFFAA => Rez.Strings.c_FFFFAA,
        0xFFFFFF => Rez.Strings.c_FFFFFF
    };

    function getFieldResource(fieldId){
        var fieldResource = fieldsMap.get(fieldId);
        return fieldResource;
    }

    function getFieldString(fieldId) as String{
        //Log.debug("getFieldString " + fieldId);
        var fieldResource = getFieldResource(fieldId);
        var fieldString = WatchUi.loadResource(fieldResource);
        return (fieldString != null) ? fieldString : "";
    }

        function getPropertiesAsDict() as Dictionary {
        var keys = [
            "Field1", "Field2", "barTop", "barBottom",
            "BatteryField", "stepsGoal", "caloriesGoal", "fgColor"
        ];
        var result = {} as Dictionary;
        for (var i = 0; i < keys.size(); i++) {
            var value = Application.Properties.getValue(keys[i]);
            if (value != null) {
                result[keys[i]] = value;
            }
        }
        return result;
    }


}
