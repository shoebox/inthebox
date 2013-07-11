package org.shoebox.display;

import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.display.Tilesheet;
import org.shoebox.display.AnimatedTilesMap;
import org.shoebox.display.tile.TileDesc;
import org.shoebox.geom.FPoint;
import org.shoebox.geom.IPosition;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */
#if flash
class AnimatedTile extends Sprite{
#else
class AnimatedTile extends TileDesc{
#end

	#if !flash
	public var name( default , default ) : String;
	#end

	public var cycle( default , set_cycle ) : String;
	public var onComplete : Signal;

	private var _aFrame        : Array<Float>;
	private var _bInnvalidate  : Bool;
	private var _bMaxLoopCount : Bool;
	private var _bPlaying      : Bool;
	private var _bmp           : Bitmap;
	private var _fCenter       : FPoint;
	private var _fPosition     : FPoint;
	private var _iCycleLen     : Int;
	private var _iFps          : Int;
	private var _iFrame        : Int;
	private var _fLoopTime     : Float;
	private var _iLoops        : Int;
	private var _iTimeElapsed  : Int;
	private var _refMap        : AnimatedTilesMap;
	private var _sCat          : String;

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
		public function new( refMap : AnimatedTilesMap , sCat : String , fps : Int = 30 ) {

			#if flash
				super( );
			#else
				super( 0 , 0 , 0 );
			#end

			#if flash

				_bmp = new Bitmap( );
				_bmp.smoothing = true;
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

			onComplete = new Signal( );
			_bInnvalidate = true;
			_bPlaying     = true;
			_fCenter      = new FPoint( );//{ x : 0.0 , y : 0.0 };
			_fPosition    = new FPoint( );{ x : 0.0 , y : 0.0 };
			_iCycleLen    = 0;
			_iFrame       = 1;
			_iTimeElapsed = 0;
			_refMap       = refMap;
			_sCat         = sCat;
			_iFps         = fps;
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
		public function gotoAndPlay( frameId : Int , sCycle : String = null , loopCount : Int = -1 ) : Void {
			_bPlaying		= true;
			_iLoops			= loopCount;
			_bMaxLoopCount	= loopCount != -1;
			_gotoAnd		( true , frameId , sCycle );
			_redraw			( );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function gotoAndStop( frameId : Int , sCycle : String = null ) : Void {
			_gotoAnd( false , frameId , sCycle );
			_bPlaying = false;
			_redraw( );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function stop( ) : Void {
			_bPlaying = false;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function play( ) : Void {
			_bPlaying = true;
			_bMaxLoopCount = false;
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

			var bComplete = false;
			_iTimeElapsed += iDelay;
			var len = _iCycleLen - 1;
			var fps = 1000 / _iFps;
			//End of the frame ?
				var iFrames = 0;
				if( _iTimeElapsed >= fps ){

					var diff = Std.int( _iTimeElapsed % fps );
					iFrames = Std.int( ( _iTimeElapsed - diff ) / fps );
					_iTimeElapsed = diff;
				}

				if( iFrames == 0 )
					return;


			//
				if( iFrames > len ){
					var diff = 0;
					if( len != 0 )
						diff = iFrames - ( iFrames % len );
					_iFrame -= diff;
					_iLoops-= Std.int( diff / len );
					_iLoops = Std.int( Math.max( _iLoops , 0 ) );
					if( _iLoops == 0 && _bMaxLoopCount ){
						stop( );
						_iFrame = len;
						bComplete = true;
					}
				}

				_iFrame += iFrames;


				if( _iFrame > ( len ) ){

					if( _bMaxLoopCount ){
						_iLoops--;
						_iLoops = Std.int( Math.max( _iLoops , 0 ) );
						if( _iLoops == 0 ){
							stop( );
							_iFrame = len;
							bComplete = true;
						}else
							_iFrame = _iFrame - _iCycleLen;

					}else
						_iFrame = 0;
				}

			//
				if( bComplete ){
					onComplete.emit( );
					bComplete = false;
				}

			//
				_redraw( );

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setCycle( s : String ) : Void {
			set_cycle( s );
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
		private function set_cycle( s : String ) : String{

			if( s == null )
				throw new flash.errors.Error( );

			if( cycle == s )
				return s;

			cycle         = s;
			_iFrame       = 0;
			_bInnvalidate = true;
			_iCycleLen    = _refMap.getSubCycleLen( _sCat , s );
			_fLoopTime    = ( _iCycleLen  / _iFps ) * 1000;
			return s;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _redraw( ) : Void{

			//
				#if flash
					var pt  = _refMap.getFrameCenter( _sCat , cycle , _iFrame );
					var bmp = _refMap.getBitmapData( _sCat , cycle , _iFrame );
					if( pt != null ){
						_bmp.x  = -pt.x;
						_bmp.y  = -pt.y;
					}
					_bmp.bitmapData = bmp;
				#else
					tileId = _refMap.getSubCycleId( _sCat , cycle , _iFrame );
				#end

		}

	// -------o misc

}