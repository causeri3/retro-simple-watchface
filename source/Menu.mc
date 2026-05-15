import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class Menu extends WatchUi.Menu2 {

  function initialize() {
    Menu2.initialize({ :title => "Settings"});
    add_items();
  }

  function add_items() {     
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Field1, // label
            Settings.getFieldString(Settings.SettingField1), // sublabel
            "Field1", // id
            {} // options
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Field2,
            Settings.getFieldString(Settings.SettingField2),
            "Field2",
            {}
        )
    );

    Menu2.addItem(
        new MenuItem(
            Rez.Strings.barTop,
            Settings.getFieldString(Settings.SettingBarTop),
            "barTop", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.barTop,
            Settings.getFieldString(Settings.SettingBarBottom),
            "barBottom", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.BatteryField,
            Settings.getFieldString(Settings.batterySetting),
            "BatteryField", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.caloriesGoal, 
            Settings.caloriesGoal.toString(),
            "caloriesGoal", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.stepsGoal, 
            Settings.stepsGoal.toString(),
            "stepsGoal", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.fgColor,
            Settings.colorStringMap.get(Settings.fgColor),

            //Settings.fgColor.toString(),
            "fgColor",
            {}
        )
    );
  }                                                                                                       
}

class MenuDelegate extends WatchUi.Menu2InputDelegate {
  var _view as simplisticView?;

  function initialize(view as simplisticView) {
    Menu2InputDelegate.initialize();
    _view = view;
  }

  function onSelect(item) {
    var id = item.getId();
    var barKeys = [0, 2, 6, 7, 9, 11]; // only none, stress, body battery, % calories, % steps, battery level  
    var batteryKeys = [0, 6, 7, 9, 11]; // only none, body battery, % calories, % steps, battery level    
  
    if (id.equals("Field1")) {
      cycleFields(Settings.SettingField1, item, id, null);
    }
    else if (id.equals("Field2")) {
      cycleFields(Settings.SettingField2, item, id, null);
    }
    if (id.equals("barTop")) {
      cycleFields(Settings.SettingBarTop, item, id, barKeys);
    }
    if (id.equals("barBottom")) {
      cycleFields(Settings.SettingBarBottom, item, id, barKeys);
    }
    if (id.equals("BatteryField")) {
      cycleFields(Settings.batterySetting, item, id, batteryKeys);
    }
    else if (id.equals("caloriesGoal")) {                                                                      
       cycleNumbers(Settings.caloriesGoal, item, id, 100, 10100);                                                                     
     }
    else if (id.equals("stepsGoal")) {                                                                      
       cycleNumbers(Settings.stepsGoal, item, id, 1000, 101000);                                                                     
     }
    else if (id.equals("fgColor")) {
      cycleColors(Settings.fgColor, item, id);
    }
    (Application.getApp() as simplisticApp).analytics.trackSettings(Settings.getPropertiesAsDict());

  }

  function onBack() as Void {
        _view.dots = BenDayDotsRectangle.build();
        WatchUi.requestUpdate();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
  }

//var validKeys as Null or Array<Number> = null;

  hidden function cycleFields(setting, item, fieldId, validKeys){
    if (validKeys == null) {                                                 
           validKeys = Settings.fieldsMap.keys();                               
    }     
    var currentIndex = validKeys.indexOf(setting);
    var nextIndex = (currentIndex + 1) % validKeys.size();
    // make compiler happy by giving container type
    var keys = validKeys as Array<Number>;
    setting = keys[nextIndex]; 
    item.setSubLabel(Settings.getFieldString(setting));
    Application.Properties.setValue(fieldId, setting);
    Settings.getProperties();
  }

  hidden function cycleNumbers(setting, item, fieldId, step, max){                                                            
     var currentValue = setting;                                                           
     var nextValue = (currentValue + step) % max;
     item.setSubLabel(nextValue.toString());                                                                   
     Application.Properties.setValue(fieldId, nextValue);                                                      
     Settings.getProperties();                                                                                     
   } 

  hidden function cycleColors(current, item, fieldId) {
    var idx = Settings.colorList.indexOf(current);
    if (idx < 0) { idx = 0; }
    var nextIdx = (idx + 1) % Settings.colorList.size();
    var nextColor = (Settings.colorList as Array<Number>)[nextIdx];
    var subLabel = Settings.colorStringMap.get(nextColor);
    item.setSubLabel(subLabel);
    Application.Properties.setValue(fieldId, nextColor);
    Settings.getProperties();
  }
}
