package com.esri.controllers
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.geometry.WebMercatorMapPoint;
	import com.esri.ags.symbols.Symbol;
	import com.esri.events.HTML5GeolocationEvent;
	import com.esri.model.Model;
	import com.esri.views.BitmapSymbol;
	
	import flash.external.ExternalInterface;
	
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;

	public class HTML5GeolocationController
	{
		public function HTML5GeolocationController()
		{
		}
		
		public var model:Model;
		
		[Embed(source='/assets/blueball.png')]
		private const BLUE_BALL:Class;
		
		public var map:Map;
		
		private var m_symbol:BitmapSymbol;		
		private var m_zoomLevel:int;
		
		private function getSymbol():Symbol
		{
			if (m_symbol === null)
			{
				m_symbol = new BitmapSymbol();
				m_symbol.source = BLUE_BALL;
				m_symbol.hotSpotX = 8;
				m_symbol.hotSpotY = 8;
			}
			return m_symbol;
		}
		
		public function whereAmI(zoomLevel:int):void
		{
			m_zoomLevel = zoomLevel;
			
			if (ExternalInterface.available)
			{
				const  VERIFY_GEOLOCATION:String = 
					"document.insertScript = function(){" +
						"verify_geolocation = function(){"+
							"var geoEnabled = false;" + 
							"if(navigator && navigator.geolocation)" +
							"{" +
							"    return geoEnabled = true;" +
							"}" +
							"else{" +
							"    return geoEnabled = false;" +
							"}"+
						"}"+
					"}";
				
				const  GET_GEOLOCATION:String = 
					"document.insertScript = function(){" +
						"get_geolocation = function(){"+
							"var location = null;" + 
							"var mySWF = document.getElementById('EsriQuickStartSample');"+
							"navigator.geolocation.getCurrentPosition(function(position){"+
							"     mySWF.sendDataToActionScript(position);"+
							"});"+
						"}"+
					"}";				
				
				//load the script in DOM
				ExternalInterface.call(VERIFY_GEOLOCATION); 
				
				//call the JS function
				var geoEnabled:Boolean = ExternalInterface.call("verify_geolocation");
				
				if(geoEnabled == true){
					//Load the script in DOM
					ExternalInterface.call(GET_GEOLOCATION); 
					
					//Step 1: set the callback
					ExternalInterface.addCallback("sendDataToActionScript",html5GeolocationHandler); 
					
					//Step 2: call the JS Function
					ExternalInterface.call("get_geolocation"); 
					
					trace("geoEnabled: " + geoEnabled);
				}		
			}
			else
			{
				if (map.hasEventListener(FaultEvent.FAULT))
				{
					map.dispatchEvent(new FaultEvent(FaultEvent.FAULT, false, true, new Fault('geoLocationNotSupported', 'Geolocation is not supported')));
				}
			}
				
		}
		
		private function html5GeolocationHandler(event:Object):void
		{
			const mapPoint:WebMercatorMapPoint = new WebMercatorMapPoint(event.coords.longitude, event.coords.latitude);
			const feature:Graphic = new Graphic(mapPoint, getSymbol(), event);
			model.pointArrCol.addItem(feature); //pointsLayer bindable to model.pointArrCol from ESRIMap
			if (m_zoomLevel > -1)
			{
				map.centerAt(mapPoint);
				map.level = m_zoomLevel;
			}
			if (map.hasEventListener(HTML5GeolocationEvent.GEOLOCATION_UPDATE))
			{
				map.dispatchEvent(new HTML5GeolocationEvent(HTML5GeolocationEvent.GEOLOCATION_UPDATE, false, false,  
					event.coords.latitude, event.coords.longitude, 
					event.coords.altitude, event.coords.horizontalAccuracy, 
					event.coords.speed, event.coords.heading, event.coords.timestamp));
			}		
		}
		
		
	}
}