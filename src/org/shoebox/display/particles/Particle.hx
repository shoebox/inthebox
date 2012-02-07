package org.shoebox.display.particles;

import nme.display.Sprite;
import org.shoebox.core.BoxMath;
import org.shoebox.libs.nevermind.entity.SteeringEntity;

/**
 * ...
 * @author shoe[box]
 */

class Particle extends Sprite{

	public var oEntity : SteeringEntity;
	public var fTimeToLive : Float;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new(  ) {
			super( );
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function init(  dx : Float , dy : Float , fTimeToLive : Float ) : Void {
			oEntity = new SteeringEntity( );
			setPosition( dx , dy );
			this.fTimeToLive = fTimeToLive;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setPosition( dx : Float , dy : Float ) : Void {
			oEntity.position.x = dx;
			oEntity.position.y = dy;	
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function update( fDelay : Float ) : Void {
			
			oEntity.update( );
			x = oEntity.position.x;
			y = oEntity.position.y;
			fTimeToLive -= fDelay;
			
		}

	// -------o protected
	
		

	// -------o misc
	
}