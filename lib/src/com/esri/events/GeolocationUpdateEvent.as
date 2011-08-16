package com.esri.events
{

import com.esri.ags.Graphic;
import com.esri.ags.geometry.MapPoint;

import flash.events.Event;
import flash.events.GeolocationEvent;

public class GeolocationUpdateEvent extends GeolocationEvent
{
    public static const GEOLOCATION_UPDATE:String = "geolocationUpdate";

    public var graphic:Graphic;

    public function GeolocationUpdateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, graphic:Graphic = null, latitude:Number = 0, longitude:Number = 0, altitude:Number = 0, hAccuracy:Number = 0, vAccuracy:Number = 0, speed:Number = 0, heading:Number = 0, timestamp:Number = 0)
    {
        super(type, bubbles, cancelable, latitude, longitude, altitude, hAccuracy, vAccuracy, speed, heading, timestamp);
        this.graphic = graphic;
    }

    public function get mapPoint():MapPoint
    {
        return graphic.geometry as MapPoint;
    }

    override public function clone():Event
    {
        return new GeolocationUpdateEvent(type, bubbles, cancelable, graphic, latitude, longitude, altitude, horizontalAccuracy, verticalAccuracy, speed, heading, timestamp);
    }
}
}
