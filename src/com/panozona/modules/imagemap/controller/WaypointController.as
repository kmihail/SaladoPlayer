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
package com.panozona.modules.imagemap.controller {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	import com.panozona.player.module.Module;
	
	import com.panozona.modules.imagemap.view.WaypointView;
	import com.panozona.modules.imagemap.events.WaypointEvent;
	
	/**
	 * @author mstandio
	 */
	public class WaypointController {
		
		private var _waypointView:WaypointView; 
		private var _module:Module;
		
		private var _pan:Number;
		private var _tilt:Number;
		private var _fov:Number;
		
		private var _isFocused:Boolean;
		
		private var pan1:Number;
		private var pan2:Number;
		private var pan3:Number;
		
		public function WaypointController(waypointView:WaypointView, module:Module) {
			_waypointView = waypointView;
			_module = module;
			
			var LoadPanoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			_waypointView.waypointData.addEventListener(WaypointEvent.CHANGED_SHOW_RADAR, handleShowRadarChange, false, 0, true);
			_waypointView.waypointData.addEventListener(WaypointEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			
			_waypointView.addEventListener(MouseEvent.CLICK, handleMouseClik, false, 0, true);
			
			drawButton();
		}
		
		public function lostFocus():void {
			_isFocused = false;
		}
		
		private function handleMouseClik(e:Event):void {
			if (_module.saladoPlayer.manager.currentPanoramaId != _waypointView.waypointData.waypoint.target){
				_module.saladoPlayer.manager.loadPano(_waypointView.waypointData.waypoint.target);
			}else {
				_waypointView.contentViewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
			}
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			if (_waypointView.waypointData.waypoint.target != null) { 
				if (loadPanoramaEvent.panoramaData.id == _waypointView.waypointData.waypoint.target) {
					// TODO: fade in effect
					_waypointView.waypointData.showRadar = true;
					_waypointView.contentViewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
				}else {
					// TODO: fade out effect
					_waypointView.waypointData.showRadar = false;
				}
			}
		}
		
		private function handleShowRadarChange(e:Event):void {
			drawButton();
			if (_waypointView.waypointData.showRadar) {
				_pan = NaN;
				_tilt = NaN;
				_fov = NaN;
				drawRadar();
				handleEnterFrame();
				_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			}else {
				_waypointView.radar.graphics.clear();
				_module.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}
		
		public function handleMouseOverChange(e:Event):void {
			drawButton();
		}
		
		private function handleEnterFrame(e:Event= null):void {
			if (_fov != _module.saladoPlayer.manager.fieldOfView) {
				drawRadar();
				_fov = _module.saladoPlayer.manager.fieldOfView;
			}
			if (_pan != _module.saladoPlayer.manager.pan || _tilt != _module.saladoPlayer.manager.tilt) {
				
				pan3 = pan2;
				pan2 = pan1;
				pan1 = _module.saladoPlayer.manager.pan;
				
				_waypointView.radar.rotationZ = - _module.saladoPlayer.manager.pan - _waypointView.waypointData.waypoint.panShift;
				_waypointView.radar.scaleX = 1 - Math.abs(_module.saladoPlayer.manager.tilt) / 100;
				_pan = _module.saladoPlayer.manager.pan;
				_tilt = _module.saladoPlayer.manager.tilt;
				
				if (_module.saladoPlayer.manager.tilt > 0) {
					_waypointView.radarFirst();
				}else {
					_waypointView.buttonFirst();
				}
				
				if (_waypointView.waypointData.showRadar && !_isFocused) {
					if(pan1 - pan2 < pan2 - pan3){
						_waypointView.contentViewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
						_isFocused = true;
					}
				}
			}
		}
		
		private function drawRadar():void {
			_waypointView.radar.graphics.clear();
			var startAngle:Number = - _module.saladoPlayer.manager.fieldOfView * Math.PI / 180 * 0.5;
			var endAngle:Number = _module.saladoPlayer.manager.fieldOfView * Math.PI / 180 * 0.5;
			var divisions:Number = Math.floor(Math.abs(endAngle - startAngle) / (Math.PI / 4))+1;
			var span:Number = Math.abs(endAngle - startAngle) / (2 * divisions);
			var controlRadius:Number = _waypointView.waypointData.radar.radius / Math.cos(span);
			_waypointView.radar.graphics.beginFill(_waypointView.waypointData.radar.color);
			_waypointView.radar.graphics.lineStyle(_waypointView.waypointData.radar.borderSize, _waypointView.waypointData.radar.borderColor);
			_waypointView.radar.graphics.moveTo(0, 0);
			_waypointView.radar.graphics.lineTo((Math.cos(startAngle)*_waypointView.waypointData.radar.radius), Math.sin(startAngle)*_waypointView.waypointData.radar.radius);
			var controlPoint:Point;
			var anchorPoint:Point;
			for(var i:Number=0; i<divisions; ++i){
				endAngle = startAngle + span;
				startAngle  = endAngle + span;
				controlPoint = new Point(Math.cos(endAngle)*controlRadius, Math.sin(endAngle)*controlRadius);
				anchorPoint = new Point(Math.cos(startAngle)*_waypointView.waypointData.radar.radius, Math.sin(startAngle)*_waypointView.waypointData.radar.radius);
				_waypointView.radar.graphics.curveTo(controlPoint.x, controlPoint.y, anchorPoint.x, anchorPoint.y);
			}
			_waypointView.radar.graphics.endFill();
		}
		
		private function drawButton():void {
			_waypointView.button.graphics.clear();
			if (_waypointView.waypointData.showRadar){
				_waypointView.button.graphics.beginFill(_waypointView.waypointData.button.activeColor);
			}else if (_waypointView.waypointData.mouseOver) {
				_waypointView.button.graphics.beginFill(_waypointView.waypointData.button.hoverColor);
			}else { // !mouseOver
				_waypointView.button.graphics.beginFill(_waypointView.waypointData.button.plainColor);
			}
			_waypointView.button.graphics.lineStyle(_waypointView.waypointData.button.borderSize, _waypointView.waypointData.button.borderColor);
			_waypointView.button.graphics.drawCircle(0, 0, _waypointView.waypointData.button.radius);
			_waypointView.button.graphics.endFill();
		}
	}
}