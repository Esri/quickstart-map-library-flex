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

import flash.display.Sprite;

/**
 * @private
 */
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
