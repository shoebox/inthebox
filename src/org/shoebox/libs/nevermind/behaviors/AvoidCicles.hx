package org.shoebox.libs.nevermind.behaviors;

import fr.hyperfiction.caos.core.Variables;
import nme.display.Graphics;
import nme.geom.Vector3D;
import nme.Lib;
import nme.display.Sprite;
import nme.Vector;
import org.shoebox.core.Vector2D;
import org.shoebox.libs.nevermind.behaviors.ABehavior;

/**
 * ...
 * @author shoe[box]
 */

class AvoidCicles extends ABehavior{

	public static var AVOID_BUFFER			: Int = 25;
	
	private var _vCircles			: Vector<Circle>;
	
	// -------o constructor
		
		/**
		* FrontController constructor method
		* 
		* @public
		* @param	container : optional container reference	( DisplayObjectContainer ) 
		* @return	void
		*/
		public function new() {
			trace('constructor');
			super( 1 );
			_vCircles = new Vector<Circle>( );
		}
	
	// -------o public
	
		public function draw( g : Graphics ) : Void {
			g.lineStyle( 1 , 0x5ab6f3 );
			for ( c in _vCircles ) {
				g.drawCircle( c.position.x , c.position.y , c.radius );
			}
		}
	
		public function addCircle( dx : Float , dy : Float , radius : Float ) : Void {
			_vCircles.push( new Circle( dx , dy , radius ) );
		}
		
		/**
		* calculate function
		* @public
		* @param 
		* @return
		*/
		override public function calculate() : Vector2D {
			
			var heading : Vector2D;
			var difference : Vector2D;
			var dotProd : Float;
			var feeler : Vector2D;
			var projection : Vector2D;
			var dist : Float;
			var force : Vector2D;
			var res : Vector2D = new Vector2D( );
			for ( c in _vCircles ) {
				
				heading = entity.velocity.clone( ).normalize( );
				difference = c.position.sub( entity.position );
				dotProd = difference.dotProd( heading );
				
				//front ?
				if ( dotProd > 0 ) {
					
					feeler = heading.mul( c.radius );
					projection = heading.mul( dotProd );
					dist = projection.sub( difference ).length;
					
					if ( dist < ( c.radius + AVOID_BUFFER ) && projection.length < feeler.length ) {
						
						force = heading.mul( entity.maxSpeed );
						force.angle += difference.sign( entity.velocity ) * Math.PI / 2;
						force = force.mul( 1.0 - projection.length / feeler.length );
						
						res = res.add( force );
					}
				}
			}
			
			
			return res;
		}

	// -------o protected
	
		

	// -------o misc
	
	
}

class Circle {
	
	public var position : Vector2D;
	public var radius : Float;
	
	public function new( dx : Float , dy : Float , radius : Float ) : Void {
		position = new Vector2D( dx , dy );
		this.radius = radius;
	}
}