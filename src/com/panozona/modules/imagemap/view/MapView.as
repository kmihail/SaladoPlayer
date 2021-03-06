﻿/*
Copyright 2010 Marek Standio.

This file is part of SaladoPlayer.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published 
by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty 
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.imagemap.view {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	//import com.panozona.modules.imagemap.model.MapData;
	import com.panozona.modules.imagemap.model.ImageMapData;
	
	import com.panozona.modules.imagemap.events.ContentViewerEvent;
	
	/**
	 * @author mstandio
	 */
	public class MapView extends Sprite {
		
		private var _imageMapData:ImageMapData;
		
		private var _mapImage:Bitmap;
		private var _waypointsContainer:Sprite;
		
		public function MapView(imageMapData:ImageMapData) {
			
			_imageMapData = imageMapData;
			
			_mapImage = new Bitmap();
			addChild(_mapImage);
			
			_waypointsContainer = new Sprite();
			addChild(_waypointsContainer);
			
			addEventListener(ContentViewerEvent.FOCUS_LOST, focusLost, false, 0, true);
		}
		
		private function focusLost(contentViewerEvent:ContentViewerEvent):void {
			_imageMapData.mapData.dispatchEvent(contentViewerEvent);
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
		
		public function get mapImage():Bitmap {
			return _mapImage;
		}
		
		public function get waypointsContainer():Sprite {
			return _waypointsContainer;
		}
	}
}