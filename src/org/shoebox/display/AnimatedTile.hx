package org.shoebox.display;

import org.shoebox.display.AnimatedTilesMap;
import org.shoebox.geom.FPoint;

/**
 * ...
 * @author shoe[box]
 */

class AnimatedTile{

	public var cycle( default , _setCycle ) : String;

	private var _aFrame       : Array<Float>;
	private var _refMap       : AnimatedTilesMap;
	private var _bLoop        : Bool;
	private var _bPlaying     : Bool;
	private var _bInnvalidate : Bool;
	private var _fCenter      : FPoint;
	private var _fPosition    : FPoint;
	private var _iCycleLen    : Int;
	private var _iFrame       : Int;
	private var _iTimeElapsed : Int;
	private var _iLoopTime    : Int;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( refMap : AnimatedTilesMap , fps : Int = 30 ) {
			_refMap       = refMap;
			_iFrame       = 0;
			_iTimeElapsed = 0;
			_bInnvalidate = true;
			_bPlaying     = true;
			_bLoop        = true;
			_fPosition    = { x : 0.0 , y : 0.0 };
			_fCenter      = { x : 0.0 , y : 0.0 };
			_iCycleLen    = 0;
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
		public function getFrameArray( ) : Array<Float> {
			
			if( _bInnvalidate ){
				_aFrame = [ _fPosition.x , _fPosition.y , _refMap.getCycleId( cycle , _iFrame ) , 1 ];
				_bInnvalidate = false;
			}

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
				//trace( _iFrame+' - '+_iCycleLen );

			/*
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
			*/

		}


	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _gotoAnd( bPlay : Bool , frameId : Int , sCycle : String = null ) : Void{
			cycle         = sCycle;
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
				return cycle;

			if( cycle == s )
				return s;

			cycle         = s;
			_iFrame       = 0;
			_bInnvalidate = true;
			_iCycleLen    = _refMap.getCycleLen( s );
			_iLoopTime 		= Std.int( (_iCycleLen  / 30 ) * 1000);
			return s;
		}

	// -------o misc
	
}