package org.shoebox.display.tile;

import org.shoebox.display.tile.TilesMapAnimated;
import org.shoebox.display.tile.TileDesc;

/**
 * ...
 * @author shoe[box]
 */
class TileClip extends TileDesc{

	public var material ( default , default ) : TilesMapAnimated;
	public var cycle( default , default ) : String;
	public var loopTime( default , default ) : Int;

	private var _bPlaying		: Bool;
	private var _iFrame			: Int;
	private var _iTimeElapsed	: Int;
	private var _sCycle			: String;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			super( );
			_bInvalidate = true;
			_iTimeElapsed = 0;
			loopTime = Std.int( 1000 / nme.Lib.current.stage.frameRate );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function gotoAndPlay( sCycle : String , iFrame : Int = 1 ) : Void {
			_sCycle		= sCycle;
			_iFrame		= iFrame;	
			_bPlaying	= true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function gotoAndStop( sCycle : String , iFrame : Int = 1 ) : Void {
			_iFrame = iFrame;	
			_bPlaying = false;	
			tileId = material.get_cycle_frame_id( _sCycle , iFrame );	
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
			if( _iTimeElapsed > loopTime ){
				var f = _iFrame + 1;
				if( f >= material.get_cycle_length( _sCycle ) )
					f = 0;
				
				tileId = material.get_cycle_frame_id( _sCycle , f );
				_iFrame = f;
				_iTimeElapsed -= loopTime;
			}
		}

	// -------o protected
		
	// -------o misc
	
}


