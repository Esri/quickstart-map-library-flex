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
