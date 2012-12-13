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

import com.esri.model.BaseLayer;
import com.esri.model.Model;
import com.esri.views.MapType;

import mx.binding.utils.BindingUtils;

public final class MapTypeController
{
    private var m_model:Model;

    public function MapTypeController()
    {
    }

    public function set model(value:Model):void
    {
        m_model = value;
        BindingUtils.bindSetter(baseLayerHandler, value, "baseLayer");
    }

    private function baseLayerHandler(baseLayer:BaseLayer):void
    {
        setBasemap(baseLayer.mapType);
    }

    public function setBasemap(mapType:String):void
    {
        if (mapType === MapType.OPEN_STREET_MAP)
        {
            m_model.arcgisTiledMapServiceLayerVisible = false;
            m_model.openStreetMapLayerVisible = true;
            m_model.baseLayer = BaseLayer.OPEN_STREET_MAP;
        }
        else
        {
            m_model.arcgisTiledMapServiceLayerVisible = true;
            m_model.openStreetMapLayerVisible = false;
            switch (mapType)
            {
                case MapType.STREETS:
                {
                    m_model.baseLayer = BaseLayer.STREETS;
                    break;
                }
                case MapType.AERIAL:
                {
                    m_model.baseLayer = BaseLayer.AERIAL;
                    break;
                }
                case MapType.TOPO:
                {
                    m_model.baseLayer = BaseLayer.TOPO;
                    break;
                }
                case MapType.TOPO_US:
                {
                    m_model.baseLayer = BaseLayer.TOPO_US;
                    break;
                }
                case MapType.TERRAIN:
                {
                    m_model.baseLayer = BaseLayer.TERRAIN;
                    break;
                }
                case MapType.OCEAN:
                {
                    m_model.baseLayer = BaseLayer.OCEAN;
                    break;
                }
            }
            m_model.arcgisTiledMapServiceLayerURL = m_model.baseLayer.mapType;
        }
    }
}
}
