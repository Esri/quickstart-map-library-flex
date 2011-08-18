package com.esri.views
{

import com.esri.ags.Map;
import com.esri.ags.esri_internal;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.GeomUtils;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.symbols.Symbol;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.utils.Dictionary;

use namespace esri_internal;

/**
 * @private
 */
public class BitmapSymbol extends Symbol
{
    private static const BITMAP_DATA_DICT:Dictionary = new Dictionary();
    private static const SPRITE_POOL:SpritePool = new SpritePool();
    private static const EXTENT:Extent = new Extent();

    private const m_matrix:Matrix = new Matrix();

    public var source:Class;
    public var rotation:Number = 0.0;
    public var scale:Number = 1.0;
    public var hotSpotX:Number = Number.NaN;
    public var hotSpotY:Number = Number.NaN;

    public function BitmapSymbol()
    {
    }

    override public function clear(sprite:Sprite):void
    {
        while (sprite.numChildren)
        {
            SPRITE_POOL.release(Sprite(sprite.removeChildAt(0)));
        }
    }

    override public function destroy(sprite:Sprite):void
    {
        while (sprite.numChildren)
        {
            SPRITE_POOL.release(Sprite(sprite.removeChildAt(0)));
        }
    }

    override public function draw(parent:Sprite, geometry:Geometry, attributes:Object, map:Map):void
    {
        const mapPoint:MapPoint = geometry as MapPoint;
        if (mapPoint)
        {
            if (map.wrapAround180)
            {
                parent.x = 0;
                parent.y = 0;
                const sx:Number = map.toScreenX(mapPoint.x);
                const sy:Number = map.toScreenY(mapPoint.y);
                EXTENT.xmin = EXTENT.xmax = mapPoint.x;
                EXTENT.ymin = EXTENT.ymax = mapPoint.y;
                EXTENT.spatialReference = mapPoint.spatialReference;
                const pointOffsetArr:Array = GeomUtils.intersects(map, geometry, EXTENT);
                for each (var pointOffset:Number in pointOffsetArr)
                {
                    const px:Number = map.toMapX(sx + pointOffset);
                    const py:Number = map.toMapY(sy);
                    if (map.extent.containsXY(px, py))
                    {
                        const child:Sprite = SPRITE_POOL.acquire();
                        drawMapPoint(child, px, py, map);
                        parent.addChild(child);
                    }
                }
            }
            else if (map.extent.containsXY(mapPoint.x, mapPoint.y))
            {
                drawMapPoint(parent, mapPoint.x, mapPoint.y, map);
            }
        }
    }

    private function drawMapPoint(sprite:Sprite, px:Number, py:Number, map:Map):void
    {
        const bitmapData:BitmapData = BITMAP_DATA_DICT[source];
        if (bitmapData)
        {
            drawBitmapData(map, sprite, px, py, bitmapData);
        }
        else
        {
            const bitmap:Bitmap = new source();
            BITMAP_DATA_DICT[source] = bitmap.bitmapData;
            drawBitmapData(map, sprite, px, py, bitmap.bitmapData);
        }
    }

    private function drawBitmapData(map:Map, sprite:Sprite, px:Number, py:Number, bitmapData:BitmapData):void
    {
        sprite.x = toScreenX(map, px);
        sprite.y = toScreenY(map, py);

        sprite.rotation = rotation;
        sprite.scaleX = scale;
        sprite.scaleY = scale;

        m_matrix.a = 1.0;
        m_matrix.d = 1.0;
        if (isNaN(hotSpotX) && isNaN(hotSpotY))
        {
            m_matrix.tx = bitmapData.width * -0.5;
            m_matrix.ty = bitmapData.height * -0.5;
        }
        else
        {
            m_matrix.tx = -hotSpotX;
            m_matrix.ty = -hotSpotY;
        }

        sprite.graphics.clear();
        sprite.graphics.beginBitmapFill(bitmapData, m_matrix, false, true);
        sprite.graphics.drawRect(m_matrix.tx, m_matrix.ty, bitmapData.width, bitmapData.height);
        sprite.graphics.endFill();
    }

}

}
