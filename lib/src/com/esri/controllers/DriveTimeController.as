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

import com.esri.ags.FeatureSet;
import com.esri.ags.Graphic;
import com.esri.ags.esri_internal;
import com.esri.ags.events.GeoprocessorEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.SimpleFillSymbol;
import com.esri.ags.tasks.Geoprocessor;
import com.esri.ags.utils.WebMercatorUtil;
import com.esri.model.Model;
import com.esri.views.ESRIMap;

import mx.managers.CursorManager;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;

use namespace esri_internal;

public final class DriveTimeController
{
    [Bindable]
    public var map:ESRIMap;

    [Bindable]
    public var model:Model;

    public function DriveTimeController()
    {
    }

    public function calculateDriveTimePolygon(fromLocation:Object, driveTimesInMinutes:Array, responder:IResponder):void
    {
        var geometry:MapPoint; // Make sure geometry coordinates are lat/lon values as this GP expects geographical values.
        if (fromLocation is MapPoint)
        {
            const mapPoint:MapPoint = fromLocation as MapPoint;
            if (-180.0 < mapPoint.x && mapPoint.x < 180.0 && -90.0 < mapPoint.y && mapPoint.y < 90)
            {
                geometry = mapPoint;
            }
            else
            {
                geometry = new MapPoint(WebMercatorUtil.xToLongitude(mapPoint.x), WebMercatorUtil.yToLatitude(mapPoint.y));
            }
        }
        else if (fromLocation is Array)
        {
            const arr:Array = fromLocation as Array;
            const x:Number = arr[0];
            const y:Number = arr[1];
            if (-180.0 < x && x < 180.0 && -90.0 < y && y < 90)
            {
                geometry = new MapPoint(x, y);
            }
            else
            {
                geometry = new MapPoint(WebMercatorUtil.xToLongitude(x), WebMercatorUtil.yToLatitude(y));
            }
        }
        const feature:Graphic = new Graphic(geometry);
        const features:Array = [ feature ];
        const featureSet:FeatureSet = new FeatureSet(features);
        const driveTimes:String = driveTimesInMinutes.join(' ');
        const inputParameters:Object = { Input_Location: featureSet, Drive_Times: driveTimes };
        const gp:Geoprocessor = new Geoprocessor("http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Network/ESRI_DriveTime_US/GPServer/CreateDriveTimePolygons");
        gp.requestTimeout = model.requestTimeout;
        gp.autoNormalize = false;
        gp.outSpatialReference = map.spatialReference;
        gp.addEventListener(FaultEvent.FAULT, gp_faultHandler);
        gp.addEventListener(GeoprocessorEvent.EXECUTE_COMPLETE, gp_executeCompleteHandler);
        gp.execute(inputParameters, responder);
        CursorManager.setBusyCursor();
    }

    private function gp_executeCompleteHandler(event:GeoprocessorEvent):void
    {
        CursorManager.removeBusyCursor();
        if (map.hasEventListener(event.type))
        {
            map.dispatchEvent(event);
            if (event.isDefaultPrevented())
            {
                return;
            }
        }
        const extent:Extent = map.extent.duplicate();
        const colors:Array = [ 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF ]; // TODO - make nicer colors !!
        const gp:Geoprocessor = event.target as Geoprocessor;
        const featureSet:FeatureSet = gp.executeLastResultFirstFeatureSet;
        const index:int = 0;
        for each (var feature:Graphic in featureSet.features)
        {
            feature.symbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, colors[index++ % colors.length]);
            feature.toolTip = feature.attributes.ToBreak + " min";
            model.polygonArrCol.addItem(feature);
            extent.unionExtent(feature.geometry.extent);
        }
        map.extent = extent.expand(1.5);
    }

    private function gp_faultHandler(event:FaultEvent):void
    {
        CursorManager.removeBusyCursor();
        if (map.hasEventListener(event.type))
        {
            map.dispatchEvent(event);
        }
    }
}
}
