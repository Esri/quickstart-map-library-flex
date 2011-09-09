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

import com.esri.model.Model;

import spark.components.supportClasses.ButtonBarBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.IndexChangeEvent;

/**
 * @private
 */
public class BaseLayerView extends SkinnableComponent
{
    [Bindable]
    public var model:Model;

    [SkinPart]
    public var buttonBar:ButtonBarBase;

    public function BaseLayerView()
    {
    }

    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        if (instance === buttonBar)
        {
            buttonBar.addEventListener(IndexChangeEvent.CHANGE, buttonBar_changeHandler);
        }
    }

    private function buttonBar_changeHandler(event:IndexChangeEvent):void
    {
        model.baseLayerURL = model.baseLayers.getItemAt(event.newIndex).url;
    }

    override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        if (instance === buttonBar)
        {
            buttonBar.removeEventListener(IndexChangeEvent.CHANGE, buttonBar_changeHandler);
        }
    }

}
}
