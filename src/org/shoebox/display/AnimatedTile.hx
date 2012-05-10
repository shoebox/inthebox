package org.shoebox.display;

import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.Tilesheet;
import org.shoebox.display.AnimatedTilesMap;
import org.shoebox.display.tile.TileDesc;
import org.shoebox.geom.FPoint;
import org.shoebox.geom.IPosition;

/**
 * ...
 * @author shoe[box]
 */
#if flash
class AnimatedTile extends Sprite{
#else
class AnimatedTile extends TileDesc{
#end

	public var cycle( default , _setCycle ) : String;

	private var _aFrame       : Array<Float>;
	private var _bInnvalidate : Bool;
	private var _bLoop        : Bool;
	private var _bPlaying     : Bool;
	private var _bmp          : Bitmap;
	private var _fCenter      : FPoint;
	private var _fPosition    : FPoint;
	private var _iCycleLen    : Int;
	private var _iFrame       : Int;
	private var _iLoopTime    : Int;
	private var _iTimeElapsed : Int;
	private var _refMap       : AnimatedTilesMap;
	private var _sCat         : String;

	#if flash
	private var _tileDesc     : TileDesc;
	#end
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( refMap : AnimatedTilesMap , sCat : String , fps : Int = 12 ) {
			
			#if flash
				super( );
			#else
				super( 0 , 0 , 0 );
			#end

			#if flash

				_bmp = new Bitmap( );
				addChild( _bmp );
			
				#if debug
					var spDebug = new Sprite( );
						spDebug.graphics.lineStyle( 0.1 , 0 );
						spDebug.graphics.moveTo( -10 , 0 );
						spDebug.graphics.lineTo( 10 , 0 );
						spDebug.graphics.moveTo( 0 , -10 );
						spDebug.graphics.lineTo( 0 , 10 );
					addChild( spDebug );
				#end

			#end

			_bInnvalidate = true;
			_bLoop        = true;
			_bPlaying     = true;
			_fCenter      = { x : 0.0 , y : 0.0 };
			_fPosition    = { x : 0.0 , y : 0.0 };
			_iCycleLen    = 0;
			_iFrame       = 0;
			_iTimeElapsed = 0;
			_refMap       = refMap;
			_sCat         = sCat;
			#if flash
			_tileDesc     = new TileDesc( 0 , 0 , 0 );
			#end
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			_refMap.dispose( );
			#if flash
			_tileDesc = null;	
			#end
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function gotoAndPlay( frameId : Int , sCycle : String = null ) : Void {
			_gotoAnd( true , frameId , sCycle );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function gotoAndStop( frameId : Int , sCycle : String = null ) : Void {
			_gotoAnd( false , frameId , sCycle );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setPosition( fx : Float , fy : Float ) : Void {

			if( _fPosition.x == fx && _fPosition.y == fy )
				return;

			x = _fPosition.x = fx;
			y = _fPosition.y = fy;
			_bInnvalidate = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setCenter( fx : Float , fy : Float ) : Void {
			_fCenter.x = fx;
			_fCenter.y = fy;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function update( iDelay : Int ) : Void {
			
			if( !_bPlaying )
				return;

			_iTimeElapsed += iDelay;
			if( _iTimeElapsed > _iLoopTime ){
				_iFrame++;
				if( _iFrame >= _iCycleLen )
					_iFrame = 0;
				_iTimeElapsed -= _iLoopTime;
			}
			
			//
				var fRatio : Float = _iTimeElapsed / _iLoopTime;
				if (fRatio >= 1) {
					
					if( _bLoop ){
						fRatio -= Math.floor (fRatio);
					} else {
						_bPlaying = false;
						fRatio = 1;
					}
				}

			//
				_iFrame = Math.round ( fRatio * ( _iCycleLen - 1) );
			
			//
				#if flash
					var pt = _refMap.getFrameCenter(  _sCat , cycle , _iFrame );
					var bmp = _refMap.getBitmapData( _sCat , cycle , _iFrame );
					_bmp.x = -pt.x;
					_bmp.y = -pt.y;
					_bmp.bitmapData = bmp;
				#end
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setCycle( s : String ) : Void {
			_setCycle( s );
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _gotoAnd( bPlay : Bool , frameId : Int , sCycle : String = null ) : Void{
			
			if( sCycle != null )
				cycle = sCycle;

			_bPlaying     = bPlay;
			_iFrame       = frameId;
			_bInnvalidate = true;			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setCycle( s : String ) : String{

			if( s == null )
				throw new nme.errors.Error( );

			if( cycle == s )
				return s;

			cycle         = s;
			_iFrame       = 0;
			_bInnvalidate = true;
			_iCycleLen    = _refMap.getSubCycleLen( _sCat , s );
			_iLoopTime    = Std.int( (_iCycleLen  / 30 ) * 1000);
			
			return s;
		}

	// -------o misc
	
}