package org.shoebox.display.tile;

import haxe.Json;
import flash.display.BitmapData;
import flash.errors.Error;
import flash.geom.Point;
import flash.geom.Rectangle;
import org.shoebox.core.BoxMath;
import org.shoebox.display.tile.TilesMap;

/**
 * ...
 * @author shoe[box]
 */

class TilesMapAnimated extends TilesMap{

	private var _hCycles : Map<String,Int>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( bmp : BitmapData ) {
			super( bmp );
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function parse( content : String , format : Format  ) : Void {

			_hCycles		= new Map<String,Int>( );
			_hContent		= new Map<String,Int>( );
			_iIncContent	= 0;
			var p = _getParser( format );
				p.parse( content , this );
		}	

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add_frame_to_cycle( sCycle : String ) : Void {
			
			var i = -1;
			if( !_hCycles.exists( sCycle ) )
				i = 0;
			else
				i = _hCycles.get( sCycle );
				i++;

			_hCycles.set( sCycle , i );

		}	

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get_cycle_length( sCycle : String ) : Int {
				
			if( !_hCycles.exists( sCycle ) )
				throw new Error( Std.format( 'The cycle $sCycle is unknow' ) );

			return _hCycles.get( sCycle );		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get_cycle_frame_id( sCycle : String , iFrame : Int ) : Int {
			return 	get_TileId_by_name( sCycle+'/'+BoxMath.toIndice( iFrame , 4 ) );
		}		

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		override private function _getParser( format : Format ) : IFormat{

			var parser : IFormat = null;
			switch( format ){

				case JSON_ARRAY:
					parser = new AnimsJSONArrayParser( );

			}

			return parser;
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class AnimsJSONArrayParser extends JSONArrayParser implements IFormat{

	public var map ( default , default ) : TilesMapAnimated;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function parse( content : Dynamic , map : TilesMap ) : Void {
			
			var b = cast( map , TilesMapAnimated );
			
			var a : Array<JSONArrayEntry> = Json.parse( content ).frames;
			var r : Rectangle;
			var t : Array<String>;
			for( sub in a ){
				t = sub.filename.split('/');
				b.add_frame_to_cycle( t[ 0 ] );
			}

			super.parse( content , map );
		}	

	// -------o protected
	
	// -------o misc
	
}
