
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class simplisticView extends WatchUi.WatchFace{
    private var fields as Fields;
    var dots as Graphics.BufferedBitmap?;

    function initialize() {
        WatchFace.initialize();
        fields = new Fields();
        //Log.debug("simplisticView initialized");

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //Log.debug("onLayout");
        //Log.debug("Before init Dimensions");
        //Log.showMemoryUsage();
        Dimensions.init(dc);
        //Log.debug("Before init fields");
        //Log.showMemoryUsage();
        fields.init(dc);
        //Log.debug("After init fields");
        //Log.showMemoryUsage();        
        dots = BenDayDotsRectangle.build();
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        // Log.debug("onShow");
        // dots = BenDayDotsRectangle.build();
        // WatchUi.requestUpdate();
    }


    function onUpdate(dc as Dc) as Void {
        // Log.debug("onUpdate");
        // Log.showMemoryUsage();
        if (dots != null) {
            dc.drawBitmap(0, 0, dots);
        }
        fields.update_fields(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    // In Simulator trigger by:  Settings > Force onHide and Settings > Force onShow
    // or juts by caling the menu Settings > Trigger App Settings (here you can see that nothing is being updated)
    function onHide() as Void {
        //Log.debug("In onHide");
        }

    // The user has just looked at their watch. Timers and animations may be started here.
    // In Simulator trigger by: Settings > Disply Mode > Always on > Toggle Power Mode (ooff and on)
    function onExitSleep() as Void {
        //Log.debug("onExitSleep");
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        //Log.debug("onEnterSleep");
    }


}



