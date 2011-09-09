///////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010-2011 Esri. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License.
///////////////////////////////////////////////////////////////////////////
package com.esri.controllers
{

import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.geometry.WebMercatorMapPoint;
import com.esri.ags.symbols.Symbol;
import com.esri.events.GeolocationUpdateEvent;
import com.esri.model.Model;
import com.esri.views.BitmapSymbol;

import flash.events.GeolocationEvent;
import flash.sensors.Geolocation;

import mx.rpc.Fault;
import mx.rpc.events.FaultEvent;

public final class GeoLocationController
{
    [Embed(source='/assets/blueball.png')]
    private const BLUE_BALL:Class;

    public var map:Map;

    public var model:Model;

    private var m_geoLocation:Geolocation;

    private var m_symbol:BitmapSymbol;

    private function getSymbol():Symbol
    {
        if (m_symbol === null)
        {
            m_symbol = new BitmapSymbol();
            m_symbol.source = BLUE_BALL;
            m_symbol.hotSpotX = 8;
            m_symbol.hotSpotY = 8;
        }
        return m_symbol;
    }

    public function whereAmI(zoomLevel:int):void
    {
        if (Geolocation.isSupported)
        {
            if (m_geoLocation === null)
            {
                m_geoLocation = new Geolocation();
            }
            m_geoLocation.removeEventListener(GeolocationEvent.UPDATE, geoLocation_updateHandler);
            m_geoLocation.addEventListener(GeolocationEvent.UPDATE, geoLocation_updateHandler);

            function geoLocation_updateHandler(event:GeolocationEvent):void
            {
                m_geoLocation.removeEventListener(GeolocationEvent.UPDATE, geoLocation_updateHandler);
                const mapPoint:WebMercatorMapPoint = new WebMercatorMapPoint(event.longitude, event.latitude);
                const feature:Graphic = new Graphic(mapPoint, getSymbol(), event);
                model.pointArrCol.addItem(feature);
                if (zoomLevel > -1)
                {
                    map.centerAt(mapPoint);
                    map.level = zoomLevel;
                }
                if (map.hasEventListener(GeolocationUpdateEvent.GEOLOCATION_UPDATE))
                {
                    map.dispatchEvent(new GeolocationUpdateEvent(GeolocationUpdateEvent.GEOLOCATION_UPDATE, false, false, feature, event.latitude, event.longitude, event.altitude, event.horizontalAccuracy, event.verticalAccuracy, event.speed, event.heading, event.timestamp));
                }
            }
        }
        else if (map.hasEventListener(FaultEvent.FAULT))
        {
            map.dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, new Fault('geoLocationNotSupported', 'Geolocation is not supported')));
        }
    }
}
}
