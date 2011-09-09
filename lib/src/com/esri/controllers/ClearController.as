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
