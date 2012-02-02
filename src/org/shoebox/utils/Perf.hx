package org.shoebox.utils;

import nme.Assets;
import nme.events.Event;
import nme.Lib;
import nme.display.Sprite;
import nme.system.System;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * ...
 * @author shoe[box]
 */

class Perf extends Sprite{
	
	public var iFps 				: Int;
	public var iMem 				: Int;
	public var iTimer 				: Int;
	public var fps	 				: Int;
	public var iMs	 				: Int;
	
	private var _nMemory			: Float;
	private var _iPrevDelay			: Int;
	private var _iStart				: Int;
	private var _tfMemory 			: TextField;
	private var _tfMs 				: TextField;
	private var _tfFps 				: TextField;
	private var _oFormat 			: TextFormat;
	
	private static var WIDTH			: Int = 100;
	private static var HEIGHT			: Int = 50;	
	
	// -------o constructor
		
		/**
		* FrontController constructor method
		* 
		* @public
		* @param	container : optional container reference	( DisplayObjectContainer ) 
		* @return	void
		*/
		public function new() {
			super( );
			_iStart = System.totalMemory;
			addEventListener( Event.ADDED_TO_STAGE , _onStaged , false );
		}
	
	// -------o public
				
				

	// -------o protected
	
		private function _onStaged( e : Event ) : Void {
			removeEventListener( Event.ADDED_TO_STAGE , _onStaged , false );
			addEventListener( Event.REMOVED_FROM_STAGE , _onRemoved , false );
			addEventListener( Event.ENTER_FRAME , _onUpdate , false );
			_draw( );
		}
		
		private function _draw( ) : Void {
			graphics.beginFill( 0x2A2A2A );
			graphics.drawRect( 0 , 0 , WIDTH , HEIGHT );
			graphics.endFill( );
			_textFields( );
		}
		
		private function _textFields( ) : Void {
			
			//
				_tfFps = new TextField ();
				_tfMs = new TextField ();
				_tfMemory = new TextField ();
				_oFormat = new TextFormat ( null , 10 );
	
			//
				_tfFps.defaultTextFormat = _tfMs.defaultTextFormat = _tfMemory.defaultTextFormat = _oFormat;
				_tfFps.width = _tfMs.width = _tfMemory.width = WIDTH;
				_tfFps.selectable = _tfMs.selectable = _tfMemory.selectable = false;
				_tfFps.textColor = 0xFFFF00;
				_tfFps.text = "FPS: ";
				addChild ( _tfFps );
			
			//
				_tfMs.y = 15;
				_tfMs.textColor = 0x00FF00;
				_tfMs.text = "MS: ";
				addChild ( _tfMs );
	
			//
				_tfMemory.y = 30;
				_tfMemory.textColor = 0x00FFFF;
				_tfMemory.text = "MEM: ";
				addChild ( _tfMemory );
		}
		
		private function _onUpdate( e : Event ) : Void {
			
			iTimer = Lib.getTimer();
			fps++;
				
			if ( iTimer - 1000 > _iPrevDelay ) {
					
				_iPrevDelay = iTimer;
				_nMemory = Math.round( System.totalMemory * 0.000000954 * 100 ) / 100;// .toFixed ( 3 ) 
	
				iFps = Std.int( Math.min ( 50 , 50 / Lib.current.stage.frameRate * fps ) );
				iMem = Std.int( Math.min ( 50 , Math.sqrt ( Math.sqrt ( _nMemory * 5000 ) ) ) - 2 );
	
				_tfFps.text = "FPS: " + fps + " / " + stage.frameRate;
				_tfMemory.text = "MEM: " + _nMemory;
	
				fps = 0;
			}
				
			_tfMs.text = "MS: " + (iTimer - iMs);
			iMs = iTimer;
		}
		
		private function _onRemoved( e : Event ) : Void {
			trace('onRemoved');
			removeEventListener( Event.ENTER_FRAME , _onUpdate , false );
			removeEventListener( Event.REMOVED_FROM_STAGE , _onRemoved , false ); 
		}

	// -------o misc
	
		public static function main () {
			Lib.current.addChild ( new Perf() );		
		}
	
}