package org.shoebox.utils;

import haxe.Timer;
import flash.Assets;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.Lib;
import flash.display.Sprite;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
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
	private var _tfFps      : TextField;
	private var _oFormat    : TextFormat;
	
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
		
			//
				_tfFps.autoSize          = flash.text.TextFieldAutoSize.LEFT;
				#if( android || ios )
				_tfFps.defaultTextFormat = new TextFormat(null,12,0xFFFFFF);
				#else
				_tfFps.defaultTextFormat = new TextFormat('Consolas',12,0xFFFFFF);
				#end
				_tfFps.width             = WIDTH;
				_tfFps.wordWrap          = true;
				_tfFps.selectable        = false;
				_tfFps.textColor         = 0xFFFF00;
				addChild ( _tfFps );
			
		
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
			
			var mem : Float = flash.system.System.totalMemory;
				mem = Math.round( mem * 0.000000954 * 1000 ) / 1000;


			iTimer      = Lib.getTimer();
			_tfFps.text = "FPS: " + _aTimes.length + " / " + stage.frameRate+'\nMEM:'+mem+'\n'+"MS: " + (iTimer - iMs);


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