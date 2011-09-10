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
package com.esri.views
{

/**
 * Available map types.
 */
public final class MapType
{
    public static const STREETS:String = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer";

    public static const AERIAL:String = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer";

    public static const TOPO:String = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer";

    public static const TOPO_US:String = "http://services.arcgisonline.com/ArcGIS/rest/services/USA_Topo_Maps/MapServer";

    public static const TERRAIN:String = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Terrain_Base/MapServer";

    public static const OCEAN:String = "http://services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer";

    public static const OPEN_STREET_MAP:String = "openStreetMap";

    public function MapType()
    {
    }
}
}
