package org.shoebox.geom;

import org.shoebox.core.BoxMath;
import org.shoebox.geom.FPoint;

/**
 * ...
 * @author shoe[box]
 */

class Circle{

	public var radius : Float;
	public var center : FPoint;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( fx : Float , fy : Float , fRadius : Float ) {
			center = { x : fx , y : fy };
			radius = fRadius;
		}
	
	// -------o public

		/**
		* Collision vs AABB
		* 
		* @public
		* @param 	vs : Test collision with ( AABB )
		* @return	collision position ( FPoint )
		*/
		public function vsAABB( vs : AABB ) : FPoint {
			
			var clone = { 
							x : BoxMath.clamp( center.x , vs.min.x , vs.max.x ), 
							y : BoxMath.clamp( center.y , vs.min.y , vs.max.y ) 
						};

			var diff = { 
							x : clone.x - center.x,
							y : clone.y - center.y
						};

			if( BoxMath.length( diff.x , diff.y ) > radius * radius )
				return null;

			diff.x += center.x;
			diff.y += center.y;
			return diff;
		}

		/**
		* Collision with a line ( infinite line collision )
		* 
		* @public
		* @param 	A : Point on line A ( FPoint )
		* @param 	B : Point on line B ( FPoint )
		* @return	true if collision ( Bool )
		*/
		public function vsLine( A : FPoint , B : FPoint ) : Bool {

			var U = { 
						x : B.x - A.x , 
						y : B.y - A.y 
					};
			var AC = { 
						x : center.x - A.x,
						y : center.y - A.y
					};

			var fNum = U.x * AC.y - U.y * AC.x;
			if ( fNum < 0 )
				fNum = -fNum;

			var fDem = Math.sqrt( U.x * U.x + U.y * U.y );
			var CI = fNum / fDem;
			return CI < radius;

		}

		/**
		* Collision with a line segment
		* 
		* @public
		* @param 	A : Line segment point A ( FPoint )
		* @param 	B : Line segment point B ( FPoint )
		* @return	true if collision ( Bool )
		*/
		public function vsSeg( A : FPoint , B : FPoint ) : Bool {

			if ( !vsLine( A , B ) )
				return false;

			var AB = {
						x : B.x - A.x,
						y : B.y - A.y
					};

			var AC = {
						x : center.x - A.x,
						y : center.y - A.y
					};

			var BC = {
						x : center.x - B.x,
						y : center.y - B.y
					};

			var f1 = AB.x * AC.x + AB.y * AC.y; // Scalar
			var f2 = -AB.x * BC.x + -AB.y * BC.y; // Scalar

			if ( f1 >= 0 && f2 >= 0 )
				return true;

			return ( vsPoint( A.x , A.y ) || vsPoint( B.x , B.y ) );
			
		}

		/**
		* Test if point is contains in the circle radius
		* 
		* @public
		* @param 	fx : Point X position ( Float )
		* @param 	fy : Point Y position ( Float )
		* @return	true if collision ( Bool )
		*/
		public function vsPoint( fx : Float , fy : Float ) : Bool {
			return BoxMath.lengthSq( center.x - fx , center.y - fy ) <= radius;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function vsCircle( c : Circle ) : FPoint {
			
			var fx = c.center.x - center.x;
			var fy = c.center.y - center.y;
			var rad = c.radius + radius;

			if ( BoxMath.length( fx , fy ) > rad * rad )
				return null;

			var res = { 
							x : ( c.center.x * radius + center.x * c.radius ) / ( radius + c.radius ),
							y : ( c.center.y * radius + center.y * c.radius ) / ( radius + c.radius )
						};
			return res;
		}

	// -------o protected
	
	// -------o misc
	
}