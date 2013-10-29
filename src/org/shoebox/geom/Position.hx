package org.shoebox.geom;
/**
 * ...
 * @author shoe[box]
 */
class Position<T:Float>{

	public var x : T;
	public var y : T;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( x : T , y : T ) {
			this.x = x;
			this.y = y;
		}
	
	// -------o public
			
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function translate( fx : T , fy : T ) : Void {
			this.x += fx;
			this.y += fy;
		}
	
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return '[Position : $x | $y]';
		}

	// -------o protected
	
		

	// -------o misc
	
}