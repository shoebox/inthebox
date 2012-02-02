package org.shoebox.core;

/**
 * ...
 * @author shoe[box]
 */

class BoxArray 
{

	public static function index( a : Array<Dynamic> , what : Dynamic ) : Int {
		
		for ( o in a.iterator( ) ) {
			trace( 'o : ' + o );
		}
		
		return -1;		
	}
	
}