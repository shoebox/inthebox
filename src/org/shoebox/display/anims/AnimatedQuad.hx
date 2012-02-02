package org.shoebox.display.anims;

import haxe.io.Error;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author shoe[box]
 */

class AnimatedQuad extends Sprite{

	public static inline var CENTER			: String = 'CENTER';
	public static inline var TOP			: String = 'TOP';
	public static inline var TOP_LEFT		: String = 'TOP_LEFT';
	
	public var align ( null , _setAlign ) : String;
	
	private var _oAtlas       : AtlasMaterial;
	private var _oBitmap      : Bitmap;
	private var _bLoop        : Bool;
	private var _bInvalidate  : Bool;
	private var _bPlaying     : Bool;
	private var _iFrameRate   : Float;
	private var _iCycleLen    : Int;
	private var _iFrame       : Int;
	private var _iLoopTime    : Int;
	private var _iPrevFrame   : Int;
	private var _iTimeElapsed : Int;
	private var _sCycle       : String;
	private var _sAlign       : String;
	private var _sPrevCycle   : String;

	// -------o constructor
		
		/**
		* AnimatedQuad constructor
		* 
		* @public
		* @return	void
		*/
		public function new( material : AtlasMaterial , fps : Float = 30 , sAlign : String = null ) {
			super( );
			
			if ( fps == -1 )
				fps = Lib.current.stage.frameRate;
			
			#if flash
			_oBitmap = new Bitmap( );
			addChild( _oBitmap );
			#end
			
			_bPlaying 	= false;
			_iFrame 	= 0;
			_iFrameRate = fps;
			_oAtlas 	= material;
			
			align = sAlign;
			showCycle( material.sDefaultCycle );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function showCycle( s : String , bNoLoop : Bool = false , bPlay : Bool = true ) : Void {
			
			if ( !_oAtlas.hasCycle( s ) ){
				return;
			}
			
			
			if ( bNoLoop )
				_bLoop = false;
			else {
				_bLoop = _oAtlas.getIsLoop( s );
			}
		
			_bPlaying 		= bPlay;
			_bInvalidate 	= true;
			_iCycleLen 		= _oAtlas.getCycleLen( s );
			_sCycle 		= s;
			
			_iFrame 		= 0;
			_iLoopTime 		= Std.int( (_iCycleLen  / _iFrameRate ) * 1000);
			_iTimeElapsed 	= 0;
			
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function play( ) : Void {
			_bPlaying = true;
		}
	
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function gotoAndStop( iFrame : Int , sCycle : String = null ) : Void {
			
			if ( sCycle != null )
				showCycle( sCycle );
			
			_play( iFrame , true , false );
			
			_bInvalidate = false;
			_bPlaying = false;
			_redrawFrame( );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function gotoAndPlay( iFrame : Int ) : Void {
			_play( iFrame , true , true );
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function update( iDelay : Int ) : Void {
			
			//trace('update :: '+iDelay+' - '+_bPlaying+'  '+_bInvalidate);
			if ( _bPlaying || _bInvalidate ) {
				
				_iTimeElapsed += iDelay;
				
				var fRatio : Float = _iTimeElapsed / _iLoopTime;
				if (fRatio >= 1) {
					
					if( _bLoop ){
						fRatio -= Math.floor (fRatio);
					} else {
						_bPlaying = false;
						fRatio = 1;
						if ( hasEventListener( Event.COMPLETE ) )
							dispatchEvent( new Event( Event.COMPLETE ) );
					}
				}
				
				_iFrame = Math.round ( fRatio * (_iCycleLen - 1));
				
				_redrawFrame( );
				_bInvalidate = false;
			}
			
		}

		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function nextFrame( ) : Void {
			var f : Int = _iFrame + 1;
			
			if ( f >= _iCycleLen ){
				if( _bLoop ){
					_iFrame = -1;
				}else{
					_bInvalidate = false;
					if ( hasEventListener( Event.COMPLETE ) )
						dispatchEvent( new Event( Event.COMPLETE ) );
				}
				
			}else{
				_bInvalidate = true;
				_iFrame = f; 
			}
			
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getQuadWidth( ) : Float {
			return _oAtlas.getFrameRec( _sCycle , _iFrame ).width;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getQuadHeight( ) : Float {
			return _oAtlas.getFrameRec( _sCycle , _iFrame ).height;
		}

	// -------o protected
	
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _play( iFrame : Int , bInvalide : Bool , bPlaying : Bool ) : Void {
			_iFrame = iFrame - 1;
			_bInvalidate = bInvalide;
			_bPlaying = bPlaying;
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _redrawFrame( ) : Void {

			if( _iPrevFrame == _iFrame && _sPrevCycle == _sCycle )
				return;

			_iPrevFrame = _iFrame;
			_sPrevCycle = _sCycle;

			#if flash
				_flashRedraw( );
			#else
				_redraw( );
			#end
		}
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _flashRedraw( ) : Void {
			
			_oBitmap.bitmapData = _oAtlas.getBitmapData( _sCycle , _iFrame );
			switch( _sAlign ) {
				
				case CENTER:
					_oBitmap.x = - _oBitmap.width / 2;
					_oBitmap.y = - _oBitmap.height / 2;
				
				case TOP_LEFT:
					_oBitmap.x = 0;
					_oBitmap.y = 0;
				
				case TOP:
					_oBitmap.x = - _oBitmap.width / 2;
					
			}
			
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _redraw( ) : Void {
			
			var dx : Float = 0.0;
			var dy : Float = 0.0;
			var rec : Rectangle = _oAtlas.getFrameRec( _sCycle , _iFrame );
			switch( _sAlign ) {
				
				case CENTER:
					dx = - rec.width / 2;
					dy = - rec.height / 2;
				
				case TOP_LEFT:
					dx = 0;
					dy = 0;
					
				case TOP:
					dx = - rec.width / 2;
			}
			
			#if !flash
			graphics.clear( );
			graphics.drawTiles( _oAtlas , [ dx , dy , _oAtlas.getTileId( _sCycle , _iFrame ) ]  );
			#end
		}
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setAlign( s : String = null ) : String {
			return _sAlign = s;
		}

	// -------o misc
	
}