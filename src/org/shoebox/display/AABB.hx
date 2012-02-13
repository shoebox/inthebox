package org.shoebox.display;

import nme.display.Graphics;

/**
 * ...
 * @author shoe[box]
 */

class AABB{

	public var min : Pos;
	public var max : Pos;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( l : Float = 0.0 , t : Float = 0.0 , r : Float = 0.0 , b : Float = 0.0 ) {
			min = { x : l , y : t };
			max = { x : r , y : b };
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function intersect( aabb : AABB ) : Bool {
		
			if( min.x >= aabb.max.x || max.x <= aabb.min.x ) return false;
			if( min.y >= aabb.max.y || max.y <= aabb.min.y ) return false;
           
			return true;
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function containPoint( dx : Float , dy : Float ) : Bool {
			return ( dx >= min.x && dx <= max.x && dy >= min.y && dy <= max.y );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function fromRec( x : Float , y : Float , w : Float , h : Float ) : Void {
			min = { x : x , y : y };
			max = { x : x + w , y : y + h };
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return '[ AABB > [ min : '+min.x+' '+min.y+' | max '+max.x+' '+max.y+' ]]';
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function debug( g : Graphics ) : Void {
			g.drawRect( min.x , min.y , max.x - min.x , max.y - min.y );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function containAABB( aabb : AABB ) : Bool {
			return ( aabb.max.x <= max.x && aabb.max.y <= max.y && aabb.min.x >= min.x && aabb.min.y >= min.y );
		}

	// -------o protected
	
	// -------o misc
	
}

private typedef Pos={
	public var x : Float;
	public var y : Float;
}