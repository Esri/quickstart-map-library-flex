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

import flash.events.MouseEvent;

import mx.core.IDataRenderer;
import mx.events.FlexEvent;

import spark.components.supportClasses.SkinnableComponent;

[SkinState("normal")]
[SkinState("hovered")]
/**
 * @private
 */
public class AddrInfo extends SkinnableComponent implements IDataRenderer
{

    private var m_over:Boolean = false;

    public function AddrInfo()
    {
        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
    }

    private function rollOutHandler(event:MouseEvent):void
    {
        m_over = false;
        invalidateSkinState();
    }

    private function rollOverHandler(event:MouseEvent):void
    {
        m_over = true;
        invalidateSkinState();
    }

    private var m_data:Object;

    [Bindable("dataChange")]
    public function get data():Object
    {
        return m_data;
    }

    public function set data(value:Object):void
    {
        m_data = value;
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    override protected function getCurrentSkinState():String
    {
        return m_over ? 'hovered' : 'normal';
    }

}
}
