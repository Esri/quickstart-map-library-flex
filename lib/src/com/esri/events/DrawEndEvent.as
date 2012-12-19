package com.esri.events
{

import com.esri.ags.Graphic;

import flash.events.Event;

/**
 * Used with custom components to broadcast that <codecom.esri.ags.events.DrawEvent</code> has completed.
 */
public class DrawEndEvent extends Event
{
    /**
     * Drawing has completed.
     * Use in conjuction with <code>[Event(name="drawEnd", type="com.esri.events.DrawEndEvent")]</code>
     */
    public static const DRAW_END:String = "drawEnd";

    public var graphic:Graphic;

    /**
     * Used with custom components to broadcast that <code>com.esri.ags.events.DrawEvent</code> has completed.
     * @param type
     * @param bubbles default is false
     * @param cancelable default is false
     * @param graphic this is the <code>com.esri.ags.Graphic</code> from the <code>com.esri.ags.events.DrawEvent</code>
     */
    public function DrawEndEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, graphic:Graphic = null)
    {
        super(type, bubbles, cancelable);
        this.graphic = graphic;
    }

    public override function clone():Event
    {
        return new DrawEndEvent(type, bubbles, cancelable, graphic);
    }
}

}
