package org.shoebox.geom;
import flash.display.Graphics;
import flash.geom.Rectangle;

/**
 * ...
 * @author shoe[box]
 */
class AABB<T:Float>{
	
	public var width ( get , never ) : T;
	public var height ( get , never ) : T;
	
	public var min : Position<T>;
	public var max : Position<T>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ?l : T , ?t : T , ?r : T , ?b : T ) {
			//trace('constructor $l | $t | $r | $b');
			min = new Position<T>( l , t );
			max = new Position<T>( r , b );
		}
	
	// -------o static
	
		/**
		* Create a AABB from the provided rectangle
		*
		* @public
		* @return	void
		*/
		static public function fromRect( r : Rectangle ) : AABB<Float> {
			return new AABB<Float>( 
				r.topLeft.x , r.topLeft.y,
				r.bottomRight.x , r.bottomRight.y
			);
		}
	
	// -------o public
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function draw( g : Graphics ) : Void {
			g.drawRect( min.x , min.y , width , height );
		}
	
		/**
		* Translate
		*
		* @public
		* @return	void
		*/
		public function translate( x : T , y : T ) : Void {
			min.translate( x , y );
			max.translate( x , y );
		}
	
		/**
		* Does the AABB intersect the other
		*
		* @public
		* @return	void
		*/
		public function intersect( aabb : AABB<T> ) : Bool {
			
			if( min.x >= aabb.max.x || max.x <= aabb.min.x ) 
				return false;
			else if( min.y >= aabb.max.y || max.y <= aabb.min.y ) 
				return false;
           
			return true;
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function intersection( aabb : AABB<T> , ?r : AABB<T> ) : AABB<T> {
			
			if( !intersect( aabb ) )
				return null;
				
			if ( r == null )
				r = new AABB<T>( );
				r.min.x = aabb.min.x > min.x ? aabb.min.x : min.x;
				r.max.x = aabb.max.x < max.x ? aabb.max.x : max.x;
				r.min.y = aabb.min.y > min.y ? aabb.min.y : min.y;
				r.max.y = aabb.max.y < max.y ? aabb.max.y : max.y;
			return r;
		}
		
		/**
		* Does the AABB contains the Point ?
		*
		* @public
		* @param 	dx : X position to test ( T )
		* @param 	dx : Y position to test ( T )
		* @return	boolean
		*/
		public function containsPoint( dx : T , dy : T ) : Bool {
			return ( dx >= min.x && dx <= max.x && dy >= min.y && dy <= max.y );
		}
		
		/**
		* Does the AABB contains the other AABB ?
		*
		* @public
		* @param 	aabb : AABB to be test ( AABB<T> )
		* @return	boolean
		*/
		public function contains( aabb : AABB<T> ) : Bool {
			return ( aabb.max.x <= max.x && aabb.max.y <= max.y && aabb.min.x >= min.x && aabb.min.y >= min.y );
		}
	
		/**
		* Return a clone instance of the AABB
		*
		* @public
		* @return	new instance ( AABB<T> )
		*/
		public function clone( ) : AABB<T> {			
			return new AABB<T>( min.x , min.y , max.x , max.y );			
		}
	
		/**
		* toString( )
		*
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return '[AABB min : $min | max : $max]';
		}

	// -------o protected
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function get_width( ) : T {
			return max.x - min.x;
		}
		
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function get_height( ) : T {
			return max.y - min.y;
		}

	// -------o misc
	
}