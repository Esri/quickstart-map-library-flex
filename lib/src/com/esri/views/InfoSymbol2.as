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

import com.esri.ags.Map;
import com.esri.ags.components.supportClasses.InfoComponent;
import com.esri.ags.components.supportClasses.InfoSymbolWindow;
import com.esri.ags.esri_internal;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.GeomUtils;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.Symbol;

import flash.display.Sprite;

import mx.core.IFactory;
import mx.core.IVisualElement;

use namespace esri_internal;

/**
 * This will be removed when Esri will publish a non-halo depend version of InfoSymbol (which will be pretty soon :-)
 *
 * @private
 */
public class InfoSymbol2 extends Symbol
{
    private static const EXTENT:Extent = new Extent();
    private var m_infoPlacement:String;
    private var m_infoRenderer:IFactory;

    public var containerStyleName:String;

    public function InfoSymbol2()
    {
    }

    [Inspectable(enumeration="upperRight,lowerRight,upperLeft,lowerLeft,left,right,top,bottom,center")]
    public function get infoPlacement():String
    {
        return m_infoPlacement;
    }

    public function set infoPlacement(value:String):void
    {
        if (value !== m_infoPlacement)
        {
            m_infoPlacement = value;
            dispatchEventChange();
        }
    }

    public function get infoRenderer():IFactory
    {
        return m_infoRenderer;
    }

    public function set infoRenderer(value:IFactory):void
    {
        m_infoRenderer = value;
        dispatchEventChange();
    }

    override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map):void
    {
        const mapPoint:MapPoint = geometry as MapPoint;
        if (mapPoint && m_infoRenderer)
        {
            if (map.wrapAround180)
            {
                drawMultipleMapPoints(sprite, mapPoint, attributes, map);
            }
            else
            {
                drawSingleMapPoint(sprite, mapPoint, attributes, map);
            }
        }
    }

    private function drawMultipleMapPoints(sprite:Sprite, mapPoint:MapPoint, attributes:Object, map:Map):void
    {
        const sx:Number = map.toScreenX(mapPoint.x);
        const sy:Number = map.toScreenY(mapPoint.y);
        EXTENT.xmin = EXTENT.xmax = mapPoint.x;
        EXTENT.ymin = EXTENT.ymax = mapPoint.y;
        EXTENT.spatialReference = mapPoint.spatialReference;
        const pointOffsetArr:Array = GeomUtils.intersects(map, mapPoint, EXTENT);
        const mapPoints:Array = [];
        for each (var pointOffset:Number in pointOffsetArr)
        {
            const px:Number = map.toMapX(sx + pointOffset);
            const py:Number = map.toMapY(sy);
            if (map.extent.containsXY(px, py))
            {
                mapPoints.push(new MapPoint(px, py));
            }
        }
        if (mapPoints.length === 0)
        {
            removeAllChildren(sprite);
        }
        else if (sprite.numChildren === mapPoints.length)
        {
            doSameNumberOfChildren(sprite, mapPoints, attributes, map);
        }
        else if (sprite.numChildren < mapPoints.length)
        {
            doLessNumberOfChildren(sprite, mapPoints, attributes, map);
        }
        else if (sprite.numChildren > mapPoints.length)
        {
            doMoreNumberOfChildren(sprite, mapPoints, attributes, map);
        }
    }

    private function doMoreNumberOfChildren(sprite:Sprite, mapPoints:Array, attributes:Object, map:Map):void
    {
        const n:int = sprite.numChildren - mapPoints.length;
        while (n--)
        {
            sprite.removeChildAt(0);
        }
        doSameNumberOfChildren(sprite, mapPoints, attributes, map);
    }

    private function doLessNumberOfChildren(sprite:Sprite, mapPoints:Array, attributes:Object, map:Map):void
    {
        const i:int = 0;
        for (; i < sprite.numChildren; i++)
        {
            const mapPoint1:MapPoint = mapPoints[i];
            const infoSymbolWindow1:InfoSymbolWindow = sprite.getChildAt(i) as InfoSymbolWindow;
            if (m_infoPlacement)
            {
                infoSymbolWindow1.setStyle(InfoComponent.INFO_PLACEMENT, m_infoPlacement);
            }
            infoSymbolWindow1.data = attributes;
            infoSymbolWindow1.anchorX = toScreenX(map, mapPoint1.x);
            infoSymbolWindow1.anchorY = toScreenY(map, mapPoint1.y);
        }
        for (; i < mapPoints.length; i++)
        {
            const mapPoint2:MapPoint = mapPoints[i];
            const infoSymbolWindow2:InfoSymbolWindow = new InfoSymbolWindow(map, containerStyleName);
            if (m_infoPlacement)
            {
                infoSymbolWindow2.setStyle(InfoComponent.INFO_PLACEMENT, m_infoPlacement);
            }
            infoSymbolWindow2.content = infoRenderer.newInstance() as IVisualElement;
            infoSymbolWindow2.data = attributes;
            infoSymbolWindow2.anchorX = toScreenX(map, mapPoint2.x);
            infoSymbolWindow2.anchorY = toScreenY(map, mapPoint2.y);
            sprite.addChild(infoSymbolWindow2);
        }
    }

    private function doSameNumberOfChildren(sprite:Sprite, mapPoints:Array, attributes:Object, map:Map):void
    {
        for (var i:int = 0; i < sprite.numChildren; i++)
        {
            const mapPoint:MapPoint = mapPoints[i];
            const infoSymbolWindow:InfoSymbolWindow = sprite.getChildAt(i) as InfoSymbolWindow;
            infoSymbolWindow.data = attributes;
            infoSymbolWindow.anchorX = toScreenX(map, mapPoint.x);
            infoSymbolWindow.anchorY = toScreenY(map, mapPoint.y);
            if (m_infoPlacement)
            {
                infoSymbolWindow.setStyle(InfoComponent.INFO_PLACEMENT, m_infoPlacement);
            }
        }
    }

    private function drawSingleMapPoint(sprite:Sprite, mapPoint:MapPoint, attributes:Object, map:Map):void
    {
        var infoSymbolWindow:InfoSymbolWindow = sprite.getChildByName('infoSymbolWindow') as InfoSymbolWindow;
        if (infoSymbolWindow === null)
        {
            infoSymbolWindow = new InfoSymbolWindow(map, containerStyleName);
            infoSymbolWindow.name = 'infoSymbolWindow';
            infoSymbolWindow.content = infoRenderer.newInstance() as IVisualElement;
            sprite.addChild(infoSymbolWindow);
        }
        if (m_infoPlacement)
        {
            infoSymbolWindow.setStyle(InfoComponent.INFO_PLACEMENT, m_infoPlacement);
        }
        infoSymbolWindow.data = attributes;
        drawMapPoint(map, sprite, mapPoint, infoSymbolWindow);
    }

    /**
     * @private
     */
    override public function clear(sprite:Sprite):void
    {
        sprite.graphics.clear();
    }

    /**
     * @private
     */
    override public function destroy(sprite:Sprite):void
    {
        removeAllChildren(sprite);
        sprite.graphics.clear();
        sprite.x = 0;
        sprite.y = 0;
    }

    private function drawMapPoint(map:Map, sprite:Sprite, mapPoint:MapPoint, infoSymbolWindow:InfoSymbolWindow):void
    {
        if (map.extent.containsXY(mapPoint.x, mapPoint.y))
        {
            infoSymbolWindow.anchorX = toScreenX(map, mapPoint.x);
            infoSymbolWindow.anchorY = toScreenY(map, mapPoint.y);
            infoSymbolWindow.visible = true;
            infoSymbolWindow.includeInLayout = true;
        }
        else
        {
            infoSymbolWindow.visible = false;
            infoSymbolWindow.includeInLayout = false;
        }
    }

}

}
