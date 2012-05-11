/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice, 
*   this list of conditions and the following disclaimer.
*  
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the 
*    documentation and/or other materials provided with the distribution.
*  
* Neither the name of shoe[box] nor the names of its 
* contributors may be used to endorse or promote products derived from 
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.shoebox.libs.nevermind.entity;

	import org.shoebox.core.BoxArray;
	import org.shoebox.core.Vector2D;
	import org.shoebox.libs.nevermind.behaviors.ABehavior;
	
	/**
	 * org.shoebox.libs.nevermind.entity.SteeringEntity
	* @author shoebox
	*/
	class SteeringEntity extends MovingEntity {
		
		public var maxForce	( getMaxForce 	, setMaxForce ) 	: Float;
		public var steer	( getSteer 		, setSteer ) 		: Vector2D;
		
		private var _vSteer			: Vector2D;
		private var _nMaxForce		: Float;
		private var _aBehaviors		: Array<ABehavior>;
		
		// -------o constructor
		
			/**
			* Constructor of the SteeringEntity class
			*
			* @public
			* @return	void
			*/
			public function new( ) : Void {
				_nMaxForce = 10;
				_vSteer = new Vector2D();
				_aBehaviors = new Array<ABehavior>();
				super();
			}

		// -------o public
			
			/**
			* set maxForce function
			* 
			* @public
			* @param 
			* @return
			*/
			public function setMaxForce( n : Float ) : Float {
				return _nMaxForce = n;
			}
			
			/**
			* get maxForce function
			* 
			* @public
			* @param 
			* @return
			*/
			public function getMaxForce() : Float {
				return _nMaxForce;
			}
			
			/**
			* set steer function
			* @public
			* @param 
			* @return
			*/
			public function setSteer( v : Vector2D ) : Vector2D {
				return _vSteer = v;
			}
			
			/**
			* get steer function
			* @public
			* @param 
			* @return
			*/
			public function getSteer( ) : Vector2D {
				return _vSteer;
			}
			
			/**
			* update function
			* 
			* @public
			* @param 
			* @return
			*/
			override public function update( ) : Void {
				
				_vSteer.truncate( _nMaxForce );
				_vSteer.divideBy( _nMass );
				
				var o : ABehavior;
				var v : Vector2D;
				
				for ( o in _aBehaviors ) {
					
					v = o.calculate( );
					v = v.scaleBy(o.nWeight );
					_vSteer.incrementBy( v );
				}
				
				if ( _nFactor != -1 ) {
					_vSteer.scaleBy( _nFactor );
				}
				
				velocity.incrementBy( _vSteer );
				
				
				
				//trace( _vVELOCITY );
				_vSteer.reset();

				super.update();
			}
			
			/**
			* set behavior function
			* @public
			* @param 
			* @return
			*/
			public function setBehaviors( v : Array<ABehavior> ) : Void {
				_aBehaviors = v;
			}

			/**
			* addBehavior function
			* @public
			* @param 
			* @return
			*/
			public function addBehavior( o : ABehavior ) : Void {
				o.entity = this;
				_aBehaviors.push( o );
			}
			
			/**
			* removeBehavior function
			* @public
			* @param 
			* @return
			*/
			public function removeBehavior( o : ABehavior ) : Void {
				_aBehaviors.remove( o );
				o.entity = null;
			}
			
			public function removeBehaviors( ) : Void {
				_aBehaviors = new Array<ABehavior>();
			}
			
		// -------o private

		// -------o misc

	}

