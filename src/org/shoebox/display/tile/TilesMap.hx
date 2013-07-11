package org.shoebox.display.tile;

import haxe.Json;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import openfl.display.Tilesheet;

/**
 * ...
 * @author shoe[box]
 */

class TilesMap extends Tilesheet{

	private var _hContent		: Map<String,Int>;
	private var _iIncContent	: Int;

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
		public function parse( content : String , format : Format  ) : Void {
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
		public function parseCustom( content : String , parser : IFormat ) : Void {
			_hContent		= new Map<String,Int>( );
			_iIncContent	= 0;
			parser.parse( content , this );		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function addNamedTileRect( name : String , rect : Rectangle , ptCenter : Point = null ) : Void {
			if( ptCenter == null )
				ptCenter = new Point( );
			addTileRect( rect , ptCenter );
			_hContent.set( name , _iIncContent++ );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get_TileId_by_name( s : String ) : Int {
			if( !_hContent.exists( s ) )
				throw new flash.errors.Error( Std.format('Tile name $s is unknow') );
			return _hContent.get( s );
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getParser( format : Format ) : IFormat{

			var parser : IFormat = null;
			switch( format ){

				case JSON_ARRAY:
					parser = new JSONArrayParser( );

			}

			return parser;
		}

	// -------o misc
	
}

typedef TileEntry = {
	public var name : String;
	public var id : Int;
}

/**
 * ...
 * @author shoe[box]
 */

class JSONArrayParser implements IFormat{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function parse( content : Dynamic , map : TilesMap ) : Void {
			var a : Array<JSONArrayEntry> = Json.parse( content ).frames;
			var r : Rectangle;
			var ptCenter : Point = new Point( );
			for( sub in a ){

				//ptCenter.x = sub.spriteSourceSize.w - sub.sourceSize.w;
				//ptCenter.y = sub.spriteSourceSize.h - sub.sourceSize.h;
				
				if( sub.trimmed ){
					ptCenter.x = sub.sourceSize.w / 2 - sub.spriteSourceSize.x;
					ptCenter.y = sub.sourceSize.w / 2 - sub.spriteSourceSize.y;
				}else
					ptCenter.x = ptCenter.y = 0;

				r = new Rectangle( sub.frame.x , sub.frame.y , sub.frame.w , sub.frame.h );
				map.addNamedTileRect( sub.filename , r , ptCenter.clone( ) );
			}
		}

	// -------o protected
	
		

	// -------o misc
	
}

interface IFormat{
	function parse( content : Dynamic , map : TilesMap ) : Void;
}

enum Format{
	JSON_ARRAY;
}

//
typedef JSONArrayEntry={
	public var filename : String;
	public var frame : JSONArrayRec;
	public var rotated : Bool;
	public var trimmed : Bool;
	public var spriteSourceSize : JSONArrayRec;
	public var sourceSize : JSONArraySize;
}
typedef JSONArrayRec={
	public var x : Int;
	public var y : Int;
	public var w : Int;
	public var h : Int;
}
typedef JSONArraySize={
	public var w : Int;
	public var h : Int;
}