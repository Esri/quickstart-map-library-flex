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
import com.esri.ags.Map;
import com.esri.ags.events.LocatorEvent;
import com.esri.ags.events.RouteEvent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.SimpleLineSymbol;
import com.esri.ags.symbols.Symbol;
import com.esri.ags.tasks.Locator;
import com.esri.ags.tasks.RouteTask;
import com.esri.ags.tasks.supportClasses.AddressCandidate;
import com.esri.ags.tasks.supportClasses.DirectionsFeatureSet;
import com.esri.ags.tasks.supportClasses.RouteParameters;
import com.esri.ags.tasks.supportClasses.RouteResult;
import com.esri.model.Model;

import flash.events.MouseEvent;

import mx.core.IMXMLObject;
import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;

public final class RouteController implements IMXMLObject
{
    private var m_lastFeatures:Array = [];

    private var m_overSymbol:Symbol;

    [Bindable]
    public var map:Map;

    [Bindable]
    public var model:Model;

    public function initialized(document:Object, id:String):void
    {
        m_overSymbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0x00FF00, 0.5, 10);
    }

    public function route(source:Array, zoomFactor:Number, responder:IResponder):void
    {
        const counter:Counter = new Counter();
        if (source === null && model.pointArrCol.length)
        {
            doRoute(zoomFactor, responder, counter);
        }
        else
        {
            for each (var obj:Object in source)
            {
                const addr:String = obj as String;
                if (addr)
                {
                    doAddr(addr, zoomFactor, responder, counter);
                    continue;
                }
                const mapPoint:MapPoint = obj as MapPoint;
                if (mapPoint)
                {
                    model.pointArrCol.addItem(new Graphic(mapPoint));
                    continue;
                }
                const graphic:Graphic = obj as Graphic;
                if (graphic && graphic.geometry is MapPoint)
                {
                    model.pointArrCol.addItem(graphic);
                    continue;
                }
            }
            doRoute(zoomFactor, responder, counter);
        }
    }

    private function doAddr(addr:String, zoomFactor:Number, responder:IResponder, counter:Counter):void
    {
        counter.count++;

        const param:Object = {};
        param[model.locatorKey] = addr;

        const locator:Locator = new Locator(model.locatorURL);
        locator.outSpatialReference = map.spatialReference;
        locator.requestTimeout = model.requestTimeout;
        locator.showBusyCursor = true;
        locator.addEventListener(FaultEvent.FAULT, locator_faultHandler);
        locator.addEventListener(LocatorEvent.ADDRESS_TO_LOCATIONS_COMPLETE, locator_addressToLocationsCompleteHandler);
        locator.addressToLocations(param, [ model.locatorVal ], responder);

        function locator_addressToLocationsCompleteHandler(event:LocatorEvent):void
        {
            if (locator.addressToLocationsLastResult && locator.addressToLocationsLastResult.length)
            {
                const addrCand:AddressCandidate = locator.addressToLocationsLastResult[0];
                const graphic:Graphic = new Graphic(addrCand.location, null, addrCand.attributes);
                graphic.toolTip = addrCand.attributes[model.locatorVal];
                model.pointArrCol.addItem(graphic);
            }
            counter.count--;
            doRoute(zoomFactor, responder, counter);
        }
        function locator_faultHandler(event:FaultEvent):void
        {
            if (map.hasEventListener(event.type))
            {
                map.dispatchEvent(event);
            }
            counter.count--;
            doRoute(zoomFactor, responder, counter);
        }
    }

    private function toFeatureSet():FeatureSet
    {
        return new FeatureSet(model.pointArrCol.toArray());
    }

    private function doRoute(zoomFactor:Number, responder:IResponder, counter:Counter):void
    {
        if (counter.count > 0)
        {
            return;
        }
        const routeParameters:RouteParameters = new RouteParameters();
        routeParameters.stops = toFeatureSet(); // new FeatureSet(model.pointArrCol.source);
        routeParameters.outSpatialReference = map.spatialReference;
        routeParameters.returnDirections = true
        routeParameters.returnRoutes = false;
        routeParameters.ignoreInvalidLocations = false;
        routeParameters.doNotLocateOnRestrictedElements = false;

        const routeTask:RouteTask = new RouteTask(model.routeTaskURL);
        routeTask.showBusyCursor = true;
        routeTask.requestTimeout = model.requestTimeout;
        routeTask.addEventListener(FaultEvent.FAULT, faultHandler);
        routeTask.addEventListener(RouteEvent.SOLVE_COMPLETE, routeTask_solveCompleteHandler);
        routeTask.solve(routeParameters, responder);

        function routeTask_solveCompleteHandler(event:RouteEvent):void
        {
            if (map.hasEventListener(event.type))
            {
                map.dispatchEvent(event);
                if (event.isDefaultPrevented())
                {
                    return;
                }
            }
            removeOldSegments();
            if (event.routeSolveResult.routeResults.length)
            {
                const routeResult:RouteResult = event.routeSolveResult.routeResults[0];
                const directionsFeatureSet:DirectionsFeatureSet = routeResult.directions;
                m_lastFeatures = directionsFeatureSet.features;
                for each (var feature:Graphic in directionsFeatureSet.features)
                {
                    feature.toolTip = feature.attributes.text;
                    feature.addEventListener(MouseEvent.ROLL_OVER, feature_overHandler);
                    feature.addEventListener(MouseEvent.ROLL_OUT, feature_outHandler);
                    model.polylineArrCol.addItem(feature);
                }

                if (zoomFactor >= 1.0)
                {
                    map.extent = directionsFeatureSet.mergedGeometry.extent.expand(zoomFactor);
                }
            }
        }

        function removeOldSegments():void
        {
            for each (var feature:Graphic in m_lastFeatures)
            {
                feature.removeEventListener(MouseEvent.ROLL_OVER, feature_overHandler);
                feature.removeEventListener(MouseEvent.ROLL_OUT, feature_outHandler);
                const index:int = model.polylineArrCol.getItemIndex(feature);
                if (index > -1)
                {
                    model.polylineArrCol.removeItemAt(index);
                }
            }
        }

        function feature_outHandler(event:MouseEvent):void
        {
            const feature:Graphic = event.target as Graphic;
            if (feature)
            {
                feature.symbol = null;
            }
        }

        function feature_overHandler(event:MouseEvent):void
        {
            const feature:Graphic = event.target as Graphic;
            if (feature)
            {
                feature.symbol = m_overSymbol;
            }
        }
    }

    private function faultHandler(event:FaultEvent):void
    {
        if (map.hasEventListener(event.type))
        {
            map.dispatchEvent(event);
        }
    }

}
}

final class Counter
{
    public var count:int = 0;
}
