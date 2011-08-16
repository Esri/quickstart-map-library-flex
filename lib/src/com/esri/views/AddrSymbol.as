package com.esri.views
{

import mx.core.ClassFactory;

public class AddrSymbol extends InfoSymbol2
{
    public function AddrSymbol()
    {
        infoRenderer = new ClassFactory(AddrInfo);
    }
}
}
