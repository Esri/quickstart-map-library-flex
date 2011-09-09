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
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.geometry.Polygon;
import com.esri.ags.geometry.Polyline;
import com.esri.ags.geometry.WebMercatorMapPoint;
import com.esri.ags.symbols.Symbol;
import com.esri.model.Model;

public final class LatLonController
{
    [Bindable]
    public var model:Model;

    public function addLatLon(lat:Number, lon:Number, symbol:Symbol = null):Graphic
    {
        const feature:Graphic = new Graphic(new WebMercatorMapPoint(lon, lat), symbol);
        feature.toolTip = lat.toFixed(6) + '\n' + lon.toFixed(6);
        model.pointArrCol.addItem(feature);
        return feature;
    }

    public function addLatLons(source:Array, symbol:Symbol = null):Array /*<Graphic>*/
    {
        const dest:Array = [];
        for each (var obj:Object in source)
        {
            const mapPoint:MapPoint = obj as MapPoint;
            if (mapPoint)
            {
                dest.push(addLatLon(mapPoint.y, mapPoint.x, symbol));
                continue;
            }
            const arr:Array = obj as Array;
            if (arr)
            {
                dest.push(addLatLon(arr[0], arr[1], symbol));
                continue;
            }
        }
        return dest;
    }

    public function addPoint(point:Object, symbol:Symbol = null):Graphic
    {
        const feature:Graphic = new Graphic(null, symbol);
        const mapPoint:MapPoint = point as MapPoint;
        if (mapPoint)
        {
            feature.geometry = toMercatorPoint(mapPoint);
        }
        else
        {
            const arr:Array = point as Array;
            if (arr)
            {
                const lat:Number = arr[0];
                const lon:Number = arr[1];
                feature.geometry = new WebMercatorMapPoint(lon, lat);
            }
        }
        model.pointArrCol.addItem(feature);
        return feature;
    }

    public function addLine(points:Array, symbol:Symbol = null):Graphic
    {
        const feature:Graphic = new Graphic(new Polyline([ toMercator(points)]), symbol);
        model.polylineArrCol.addItem(feature);
        return feature;
    }

    public function addPolygon(points:Array, symbol:Symbol = null):Graphic
    {
        const feature:Graphic = new Graphic(new Polygon([ toMercator(points)]), symbol);
        model.polylineArrCol.addItem(feature);
        return feature;
    }

    private function toMercator(orig:Array):Array
    {
        const dest:Array = [];
        for each (var obj:Object in orig)
        {
            const webPoint:WebMercatorMapPoint = obj as WebMercatorMapPoint;
            if (webPoint)
            {
                dest.push(webPoint);
                continue;
            }
            const mapPoint:MapPoint = obj as MapPoint;
            if (mapPoint)
            {
                dest.push(toMercatorPoint(mapPoint));
                continue;
            }
            const arr:Array = obj as Array;
            if (arr)
            {
                const lat:Number = arr[0];
                const lon:Number = arr[1];
                dest.push(new WebMercatorMapPoint(lon, lat));
            }
        }
        return dest;
    }

    private function toMercatorPoint(mapPoint:MapPoint):MapPoint
    {
        if (mapPoint.x >= -180.0 && mapPoint.x <= 180.0 && mapPoint.y >= -90 && mapPoint.y <= 90)
        {
            return new WebMercatorMapPoint(mapPoint.x, mapPoint.y);
        }
        return mapPoint;
    }
}
}
