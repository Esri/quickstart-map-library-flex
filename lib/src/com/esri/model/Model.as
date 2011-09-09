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
import mx.core.IMXMLObject;

public final class Model implements IMXMLObject
{
    public var requestTimeout:int = 30;

    public const polygonArrCol:ArrayCollection = new ArrayCollection();

    public const polylineArrCol:ArrayCollection = new ArrayCollection();

    public const pointArrCol:ArrayCollection = new ArrayCollection();

    public var locatorURL:String = 'http://tasks.arcgisonline.com/ArcGIS/rest/services/Locators/TA_Address_NA_10/GeocodeServer';
    public var locatorKey:String = 'SingleLine';
    public var locatorVal:String = 'Match_addr';

    public var routeTaskURL:String = 'http://tasks.arcgisonline.com/ArcGIS/rest/services/NetworkAnalysis/ESRI_Route_NA/NAServer/Route';

    [Bindable]
    public var baseLayers:ArrayList;

    [Bindable]
    public var baseLayerURL:String;

    public function Model()
    {
    }

    public function initialized(document:Object, id:String):void
    {
        if (baseLayers && baseLayers.length)
        {
            baseLayerURL = baseLayers.getItemAt(0).url;
        }
    }
}
}
