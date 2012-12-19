package com.esri.events
{

import flash.events.Event;

/**
 * This Class handles HTML5 Geolocation events pulled from the browser. This is different from <code>flash.events.GeolocationEvent</code>.
 */
public class HTML5GeolocationEvent extends Event
{
    public static const GEOLOCATION_UPDATE:String = "geolocationUpdate";

    /**
     * Data that you want to send/receive.
     */
    public var data:Object;

    public var latitude:Number;
    public var longitude:Number;
    public var altitude:Number;
    public var speed:Number;
    public var accuracy:Number;
    public var heading:Number;
    public var timestamp:Number;

    /**
     * This Class handles HTML5 Geolocation events pulled from the browser. This is different from <code>flash.events.GeolocationEvent</code>.
     * @param type
     * @param bubbles default is false
     * @param cancelable default is false
     * @param latitude
     * @param longitude
     * @param altitude
     * @param accuracy
     * @param speed
     * @param heading
     * @param timestamp
     */
    public function HTML5GeolocationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, latitude:Number = 0, longitude:Number = 0, altitude:Number = 0, accuracy:Number = 0, speed:Number = 0, heading:Number = 0, timestamp:Number = 0)
    {
        super(type, bubbles, cancelable);
        this.longitude = longitude;
        this.latitude = latitude;
        this.altitude = altitude;
        this.speed = speed;
        this.accuracy = accuracy;
        this.heading = heading;
        this.timestamp = timestamp;

    }

    public override function clone():Event
    {
        return new HTML5GeolocationEvent(type, bubbles, cancelable, latitude, longitude, altitude, accuracy, speed, heading, timestamp);
    }
}

}
