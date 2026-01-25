import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class simplisticApp extends Application.AppBase {
    var _view as simplisticView?;

    function initialize() {
        AppBase.initialize();
        //Log.debug("AppBase initialized");

    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        _view = new simplisticView();
        return [ _view ];
    }
    
    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void{
        Settings.getProperties();
        _view.dots = BenDayDotsRectangle.build();
        WatchUi.requestUpdate();
    }

  function getSettingsView() {
    return [new Menu(), new MenuDelegate(_view)];
  }


function getApp() as simplisticApp {
    return Application.getApp() as simplisticApp;
}
}