/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice, 
*   this list of conditions and the following disclaimer.
*  
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the 
*    documentation and/or other materials provided with the distribution.
*  
* Neither the name of shoe[box] nor the names of its 
* contributors may be used to endorse or promote products derived from 
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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
		public function update( iDelay : Int , bRedraw : Bool = true ) : Void {
			
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
				if( bRedraw )
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

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getFrameArray( flags : Int = 0 , fx : Float = 0 , fy : Float = 0 ) : Array<Float> {
			
			var dx : Float = 0.0;
			var dy : Float = 0.0;
			var rec : Rectangle = _oAtlas.getFrameRec( _sCycle , _iFrame );
			switch( _sAlign ) {
				
				case null:
					dx = - rec.width / 2;
					dy = - rec.height / 2;
				
				case StageAlign.TOP_LEFT:
					dx = 0;
					dy = 0;
					
				case StageAlign.TOP:
					dx = - rec.width / 2;

				case StageAlign.BOTTOM:
					dx = - rec.width / 2;
					dy = - rec.height;
			}

			var useScale = (flags & Tilesheet.TILE_SCALE) > 0;
			
			if( useScale )
				return [ dx + fx , dy + fy , _oAtlas.getTileId( _sCycle , _iFrame ) , 1 ];
			
			return [ dx + fx , dy + fy , _oAtlas.getTileId( _sCycle , _iFrame ) ];

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