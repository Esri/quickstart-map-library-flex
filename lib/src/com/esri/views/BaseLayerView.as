package com.esri.views
{

import com.esri.model.Model;

import spark.components.supportClasses.ButtonBarBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.IndexChangeEvent;

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
