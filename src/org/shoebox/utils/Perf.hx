package org.shoebox.utils;

import haxe.Timer;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.events.Event;
import nme.Lib;
import nme.display.Sprite;
import nme.system.System;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import org.shoebox.utils.FrameTimer;

using org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */

class Perf extends Sprite{
	
	public var iTimer : Int;
	public var iMs    : Int;
	
	private var _aTimes     : Array<Float>;
	private var _bmpBack    : Bitmap;
	private var _nMemory    : Float;
	private var _iPrevDelay : Int;
	private var _iStart     : Int;
	private var _tfMs       : TextField;
	private var _tfFps      : TextField;
	private var _oFormat    : TextFormat;
	
	private static var WIDTH			: Int = 100;
	private static var HEIGHT			: Int = 40;	
	
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
			mouseChildren = mouseEnabled = false;
			//addEventListener( Event.ADDED_TO_STAGE , _onStaged , false );
			onStaged( ).connect( _onStaged , 0 , 1 );
			_aTimes = [ ];
		}
	
	// -------o public
				
				

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onStaged( _ ) : Void {
			x = Lib.current.stage.stageWidth - WIDTH;
			onRemoved( ).connect( _onRemoved , 0 , 1 );
			_draw( );
			
			Lib.current.stage.onFrame( ).connect( _onUpdate );
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _draw( ) : Void {
			_bmpBack = new Bitmap( new BitmapData( WIDTH , HEIGHT , false , 0x2A2A2A ) );
			addChild( _bmpBack );
			_textFields( );
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _textFields( ) : Void {
			
			//
				_tfFps = new TextField ();
				_tfMs = new TextField ();
				_oFormat = new TextFormat ( null , 14 );
	
			//
				_tfFps.defaultTextFormat = _tfMs.defaultTextFormat = _oFormat;
				_tfFps.width             = _tfMs.width = WIDTH;
				_tfFps.height            = _tfMs.height = 20;
				_tfFps.selectable        = _tfMs.selectable = false;
				_tfFps.textColor         = 0xFFFF00;
				_tfFps.text              = "FPS: ";
				addChild ( _tfFps );
			
			//
				_tfMs.y         = 15;
				_tfMs.textColor = 0x00FF00;
				_tfMs.text      = "MS: ";
				//_tfFps.autoSize = _tfMs.autoSize = TextFieldAutoSize.NONE;
				addChild ( _tfMs );
		
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onUpdate( _ ) : Void {
			
			var now = Timer.stamp();
			_aTimes.push(now);
			
			while( _aTimes[ 0 ] < now - 1)
				_aTimes.shift();
			
			iTimer      = Lib.getTimer();
			_tfFps.text = "FPS: " + _aTimes.length + " / " + stage.frameRate;
			_tfMs.text  = "MS: " + (iTimer - iMs);

			iMs = iTimer;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onRemoved( e : Event = null ) : Void {
			
			Lib.current.stage.onFrame( ).disconnect( _onUpdate );
			onStaged( ).connect( _onStaged , 0 , 1 );
			
		}

	// -------o misc
	
	
}