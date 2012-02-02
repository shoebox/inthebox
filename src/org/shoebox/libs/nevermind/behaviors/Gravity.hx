/**
* This is about <code>org.shoebox.libs.nevermind.behaviors.Gravity</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/

package org.shoebox.libs.nevermind.behaviors ;

	import flash.geom.Vector3D;
	import org.shoebox.core.Vector2D;
	
	/**
	* org.shoebox.libs.nevermind.behaviors.Gravity
	* @author shoebox
	*/
	class Gravity extends ABehavior{
		
		private var _vGravity			: Vector2D;
		
		// -------o constructor
		
			/**
			* Constructor of the Gravity class
			*
			* @public
			* @return	void
			*/
			public function new( n : Float = 1 , nGrav : Float = 0.981 ) : Void {
				super( n );
				_vGravity = new Vector2D( 0 , nGrav );
			}

		// -------o public
			
			/**
			* calculate function
			* @public
			* @param 
			* @return
			*/
			override public function calculate() : Vector2D {
				return _vGravity;
			}
			
		// -------o protected

		// -------o misc

	}