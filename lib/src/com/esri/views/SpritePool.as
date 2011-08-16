package com.esri.views
{

import flash.display.Sprite;

internal final class SpritePool
{
    private var m_vec:Vector.<Sprite> = new Vector.<Sprite>();

    public function SpritePool()
    {
    }

    public function release(sprite:Sprite):void
    {
        m_vec.push(sprite);
    }

    public function acquire():Sprite
    {
        if (m_vec.length === 0)
        {
            return new Sprite();
        }
        return m_vec.pop();
    }

}
}
