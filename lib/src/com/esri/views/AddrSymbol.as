package com.esri.views
{

import mx.core.ClassFactory;

/**
 * @private
 */
public class AddrSymbol extends InfoSymbol2
{
    public function AddrSymbol()
    {
        infoRenderer = new ClassFactory(AddrInfo);
    }
}
}
