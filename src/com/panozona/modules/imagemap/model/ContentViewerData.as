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
package com.panozona.modules.imagemap.model {
	
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	
	import com.panozona.modules.imagemap.model.structure.Viewer;
		
	import com.panozona.modules.imagemap.events.ContentViewerEvent;
	
	/**
	 * 
	 * @author mstandio
	 */
	public class ContentViewerData extends EventDispatcher{
		
		public var viewer:Viewer;
		
		private var _moveLeft:Boolean;
		private var _moveRight:Boolean;
		private var _moveUp:Boolean;
		private var _moveDown:Boolean;
		
		private var _zoomIn:Boolean;
		private var _zoomOut:Boolean;
		
		private var _mouseOver:Boolean;
		private var _mouseDrag:Boolean;
		
		private var _focusPoint:Point;
		
		/**
		 * 
		 */
		public function ContentViewerData() {
			_focusPoint = new Point(NaN, NaN);
			viewer = new Viewer();
		}
		
		/**
		 * 
		 */
		public function get moveLeft():Boolean {
			return _moveLeft;
		}
		
		/**
		 * @private
		 */
		public function set moveLeft(value:Boolean):void {
			if (_moveLeft == value) return;
			_moveLeft = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_MOVE));
		}
		
		/**
		 * 
		 */
		public function get moveRight():Boolean {
			return _moveRight;
		}
		
		/**
		 * @private
		 */
		public function set moveRight(value:Boolean):void {
			if (_moveRight == value) return;
			_moveRight = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_MOVE));
		}
		
		/**
		 * 
		 */
		public function get moveUp():Boolean {
			return _moveUp;
		}
		
		/**
		 * @private
		 */
		public function set moveUp(value:Boolean):void {
			if (_moveUp == value) return;
			_moveUp = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_MOVE));
		}
		
		/**
		 * 
		 */
		public function get moveDown():Boolean {
			return _moveDown;
		}
		
		/**
		 * @private
		 */
		public function set moveDown(value:Boolean):void {
			if (_moveDown == value) return;
			_moveDown = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_MOVE));
		}
		
		/**
		 * 
		 */
		public function get zoomIn():Boolean {
			return _zoomIn;
		}
		
		/**
		 * @private
		 */
		public function set zoomIn(value:Boolean):void {
			if (_zoomIn == value) return;
			_zoomIn = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_ZOOM));
		}
		
		/**
		 * 
		 */
		public function get zoomOut():Boolean {
			return _zoomOut;
		}
		
		/**
		 * @private
		 */
		public function set zoomOut(value:Boolean):void {
			if (_zoomOut == value) return;
			_zoomOut = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_ZOOM));
		}
		
		/**
		 * 
		 */
		public function get mouseOver():Boolean { 
			return _mouseOver; 
		}
		
		/**
		 * @private
		 */
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_MOUSE_OVER));
		}
		
		/**
		 * 
		 */
		public function get mouseDrag():Boolean {
			return _mouseDrag; 
		}
		
		/**
		 * @private
		 */
		public function set mouseDrag(value:Boolean):void {
			if (value == _mouseDrag) return;
			if (value && !_mouseOver) return;
			_mouseDrag = value;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_MOUSE_DRAG));
		}
		
		/**
		 * 
		 */
		public function get focusPoint():Point {
			return _focusPoint;
		}
		
		/**
		 * @private
		 */
		public function set focusPoint(value:Point):void {
			_focusPoint.x = value.x; 
			_focusPoint.y = value.y;
			dispatchEvent(new ContentViewerEvent(ContentViewerEvent.CHANGED_FOCUS_POINT));
		}	
	}
}