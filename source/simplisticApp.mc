import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.Time;


class simplisticApp extends Application.AppBase {
    var _view as simplisticView?;
    var analytics = new Analytics();

    function initialize() {
        AppBase.initialize();
        //Log.debug("AppBase initialized");

    }

    function onStart(state as Dictionary?) as Void {
        var settings = System.getDeviceSettings();
        SafeStorage.setValue("deviceId", settings.uniqueIdentifier);
        SafeStorage.setValue("partNumber", settings.partNumber);
        // fire every six hours, to check if this day was used, also send settings changes, if stored
        Background.registerForTemporalEvent(new Time.Duration(6*60*60));
    }


    function onAppInstall() as Void {
        analytics.trackImmediate("install", null, method(:onAnalyticsSent));
    }

    function onAppUpdate() as Void {
        analytics.trackImmediate("update", null, method(:onAnalyticsSent));
    }

    function onAnalyticsSent(responseCode as Number, data as Dictionary or String or Null) as Void {
        System.println("simplisticApp.onAnalyticsSent responseCode=" + responseCode + " data=" + data);
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