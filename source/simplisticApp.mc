import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Time;


class simplisticApp extends Application.AppBase {
    var _view as simplisticView?;
    var analytics = new Analytics();

    function initialize() {
        AppBase.initialize();
        //Log.debug("AppBase initialized");

    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        var settings = System.getDeviceSettings();
        Storage.setValue("deviceId", settings.uniqueIdentifier);
        Storage.setValue("partNumber", settings.partNumber);
        // fire every six hours, to check if this day was used, also send settings changes, if stored
        Background.registerForTemporalEvent(new Time.Duration(6*6*60));
    }


    function onAppInstall() as Void {
        analytics.track("install", null);
        Background.exit(null);
    }

    function onAppUpdate() as Void {
        analytics.track("update", null);
        Background.exit(null);
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
        analytics.trackSettings(Settings.getPropertiesAsDict());
        WatchUi.requestUpdate();
    }

  function getSettingsView() {
    return [new Menu(), new MenuDelegate(_view)];
  }

  function getServiceDelegate() {
    return [new AnalyticsBackground()];
  }

}