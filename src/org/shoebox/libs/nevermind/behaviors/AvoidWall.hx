package org.shoebox.libs.nevermind.behaviors;

import fr.hyperfiction.caos.core.Variables;
import flash.display.Graphics;
import flash.geom.Vector3D;
import flash.Lib;
import flash.display.Sprite;
import flash.Vector;
import org.shoebox.core.BoxLine;
import org.shoebox.core.BoxMath;
import org.shoebox.core.Vector2D;
import org.shoebox.libs.nevermind.behaviors.ABehavior;

/**
 * ...
 * @author shoe[box]
 */

class AvoidWall extends ABehavior{

	private var _aFeelers					: Array<Vector2D>;
	private var _aWalls						: Array<BoxLine>;
	private var _iFeelerLen					: Float;
	
	// -------o constructor
		
		/**
		* FrontController constructor method
		* 
		* @public
		* @param	container : optional container reference	( DisplayObjectContainer ) 
		* @return	void
		*/
		public function new() {
			super( 0.5 );
			_iFeelerLen = 50;
			_aFeelers = new Array<Vector2D>( );
			_aWalls = new Array<BoxLine>( );
			
		}
	
	// -------o public
	
		public function draw( g : Graphics ) : Void {
			
			g.lineStyle( 1 , 0x5ab6f3 );
			for ( w in _aWalls ) {
				g.moveTo( w.a.x , w.a.y );
				g.lineTo( w.b.x , w.b.y );
			}
			
		}
	
		public function addWall( dx1 : Float , dy1 : Float , dx2 : Float , dy2 : Float ) : Void {
			_aWalls.push( new BoxLine( dx1 , dy1 , dx2 , dy2 ) );
		}
		
		/**
		* calculate function
		* @public
		* @param 
		* @return
		*/
		override public function calculate() : Vector2D {
			
			if ( entity == null )
				return new Vector2D( );
			
			//
				_createFeelers( );
			
			//
				
				var DistToThisIP 	: Float 	= 0.0;
				var DistToClosestIP : Float 	= Math.POSITIVE_INFINITY;
				var ClosetWall 		: BoxLine	= null;
				
			//
				var intersection	: Dynamic;
				var res 			: Vector2D = new Vector2D( );
				var SteeringForce 	: Vector2D = new Vector2D( );
				var point 			: Vector2D = new Vector2D( );
				var ClosestPoint	: Vector2D = new Vector2D( );
				
			//
				for ( feeler in _aFeelers ) {
					
					for ( wall in _aWalls ) {
						
						intersection = BoxMath.lineIntersection2D( entity.position , feeler , wall.a , wall.b );
						if ( intersection != null ) {
							
							//dist / point
							if ( intersection.dist < DistToClosestIP ) {
								DistToClosestIP	= intersection.dist;
								ClosetWall		= wall;
								ClosestPoint	= intersection.point;
							}
							
						}
					}
					
					if ( ClosetWall != null ) {
						
						var OverShoot 	: Vector2D = feeler.sub( ClosestPoint );
						var closest		: Vector2D = Vector2D.getNormalValue( ClosestPoint );
						
						res = res.add( closest.scaleBy( OverShoot.length ) );
						
						if ( entity.velocity.x < 0 && res.y > 0 )
							res.y *= -1;
						
						if ( entity.velocity.x > 0 && res.y > 0 )
							res.y *= -1;
						
						if ( BoxMath.distance( entity.position.x , entity.position.y , ClosestPoint.x , ClosestPoint.y ) <= _iFeelerLen ) {
							var helper : Vector2D = res;
								helper = helper.truncate( entity.maxForce );
							entity.position.add( helper );
						}
						
						break;
					}
					
				}
				
			//
				return res;
		}

	// -------o protected
	
		private function _createFeelers( ) : Void {
			
			var l : Int = 6;
			var vVel : Vector2D;
			for ( i in 0...l ) {
				vVel = entity.velocity.clone( );
				vVel.angle -= BoxMath.DEG_TO_RAD * ( entity.velocity.angle - 30 + i * 10 ) ;
				_aFeelers[ i ] = entity.position.add( vVel.normalize( ).scaleBy( _iFeelerLen ) );
			}
			/*
			#if flash
			Variables.DEBUB_GFX.lineStyle( 0.5 , 0x00FF00 , 0.5 );
			for( f in _aFeelers ){
				Variables.DEBUB_GFX.moveTo( entity.position.x , entity.position.y );
				Variables.DEBUB_GFX.lineTo( f.x , f.y );
			}
			#end
			*/
		}

	// -------o misc
	
	
}

class Wall extends BoxLine{
	
}