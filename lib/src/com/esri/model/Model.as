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
package com.esri.model
{

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;

public final class Model
{
    [Bindable]
    public var polygonArrCol:ArrayCollection = new ArrayCollection();

    [Bindable]
    public var polylineArrCol:ArrayCollection = new ArrayCollection();

    [Bindable]
    public var pointArrCol:ArrayCollection = new ArrayCollection();

    public var requestTimeout:int = 30; // In Seconds

    public var locatorURL:String = 'http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer';

    public var locatorKey:String = 'SingleLine';
    public var locatorVal:String = 'Match_addr';

    public var routeTaskURL:String = 'http://tasks.arcgisonline.com/ArcGIS/rest/services/NetworkAnalysis/ESRI_Route_NA/NAServer/Route';

    [Bindable]
    public var baseLayerProvider:ArrayList = new ArrayList([ BaseLayer.STREETS, BaseLayer.AERIAL, BaseLayer.OPEN_STREET_MAP ]); // Out of the box layers to be displayed on top right corner

    [Bindable]
    public var baseLayer:BaseLayer = BaseLayer.STREETS;

    [Bindable]
    public var arcgisTiledMapServiceLayerURL:String = BaseLayer.STREETS.mapType;

    [Bindable]
    public var arcgisTiledMapServiceLayerVisible:Boolean = true;

    [Bindable]
    public var openStreetMapLayerVisible:Boolean = false;

    public function Model()
    {
    }
}

}
