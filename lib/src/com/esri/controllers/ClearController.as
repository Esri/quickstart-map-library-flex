package com.esri.controllers
{

import com.esri.model.Model;

/**
 * Clear all graphics elements from Graphics Layers
 */
public final class ClearController
{
    [Bindable]
    /**
     * Reference to the model.
     */
    public var model:Model;

    /**
     * Clear all points, polylines and polygons on the map.
     */
    public function clearAll():void
    {
        clearPolygons();
        clearPolylines();
        clearPoints();
    }

    /**
     * Clear all polygons on the map.
     */
    public function clearPolygons():void
    {
        model.polygonArrCol.removeAll();
    }

    /**
     * Clear all polylines on the map.
     */
    public function clearPolylines():void
    {
        model.polylineArrCol.removeAll();
    }

    /**
     * Clear all points on the map.
     */
    public function clearPoints():void
    {
        model.pointArrCol.removeAll();
    }

}
}
