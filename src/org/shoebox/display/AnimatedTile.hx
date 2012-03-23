package org.shoebox.display;

import nme.display.Tilesheet;
import org.shoebox.display.AnimatedTilesMap;
import org.shoebox.geom.FPoint;
import org.shoebox.geom.IPosition;

/**
 * ...
 * @author shoe[box]
 */

class AnimatedTile{

	public var cycle( default , _setCycle ) : String;

	private var _aFrame       : Array<Float>;
	private var _bInnvalidate : Bool;
	private var _bLoop        : Bool;
	private var _bPlaying     : Bool;
	private var _fCenter      : FPoint;
	private var _fPosition    : FPoint;
	private var _iCycleLen    : Int;
	private var _iFrame       : Int;
	private var _iLoopTime    : Int;
	private var _iSize        : IPosition;
	private var _iTimeElapsed : Int;
	private var _refMap       : AnimatedTilesMap;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( width : Int , height : Int , refMap : AnimatedTilesMap , fps : Int = 30 ) {
			_bInnvalidate = true;
			_bLoop        = true;
			_bPlaying     = true;
			_fCenter      = { x : 0.0 , y : 0.0 };
			_fPosition    = { x : 0.0 , y : 0.0 };
			_iCycleLen    = 0;
			_iFrame       = 0;
			_iSize        = { x : width , y : height };
			_iTimeElapsed = 0;
			_refMap       = refMap;
		}
	
	// -------o public
		
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
		public function getFrameArray( iFlag : Int = Tilesheet.TILE_SCALE ) : Array<Float> {
			
			//if( _bInnvalidate ){

				var id = _refMap.getCycleId( cycle , _iFrame );
				var bounds = _refMap.getRectById( id );

				//x, y, tile ID, scale, rotation, red, green, blue, alpha

				switch( iFlag ){

					case Tilesheet.TILE_SCALE:						
						_aFrame = [ _fPosition.x , _fPosition.y , id , 1 ];

					case Tilesheet.TILE_ROTATION:	
						_aFrame = [ _fPosition.x , _fPosition.y , id , 1 , 0 ];					

					case Tilesheet.TILE_RGB:
						_aFrame = [ _fPosition.x , _fPosition.y , id , 1 , 0 , 0 , 0 , 0 ];					

					case Tilesheet.TILE_ALPHA:
						_aFrame = [ _fPosition.x , _fPosition.y , id , 1 , 0 , 1 , 1 , 1 , 1 ];			

					default:
						_aFrame = [ _fPosition.x , _fPosition.y , id ];			
				}

				_bInnvalidate = false;

			//}

			return _aFrame;						
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

			_fPosition.x  = fx;
			_fPosition.y  = fy;
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
			_iCycleLen    = _refMap.getCycleLen( s );
			_iLoopTime    = Std.int( (_iCycleLen  / 30 ) * 1000);
			
			return s;
		}

	// -------o misc
	
}