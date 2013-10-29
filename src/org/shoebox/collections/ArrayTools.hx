package org.shoebox.collections;

/**
 * ...
 * @author shoe[box]
 */
class ArrayTools{

	// -------o constructor
	
	// -------o public
		
		/**
		*
		*
		//* @public
		* @return	void
		*/
		static public function randomize<T>( a : Array<T> ) : Array<T> {
			var l = a.length - 1;
			var r;
			var t : T;
			for (it in 0...l) {
				r = Math.round(Math.random() * l);
				t = a[it];
				a[it] = a[r];
				a[r] = t;
			}
			return a;
		}
	
	// -------o protected
	
	// -------o misc
	
}