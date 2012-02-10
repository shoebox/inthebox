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
package org.shoebox.libs.nevermind.behaviors;

	import nme.events.Event;
	import org.shoebox.core.Vector2D;
	import org.shoebox.libs.nevermind.entity.SteeringEntity;
	
	/**
	 * org.shoebox.libs.nevermind.behaviors.Arrive
	* @author shoebox
	*/
	class Arrive extends ABehavior {
		
		private var _vTargetPos			: Vector2D;
		
		// -------o constructor
		
			/**
			* Constructor of the Arrive class
			*
			* @public
			* @return	void
			*/
			public function new() : Void {
				super( .02 );
			}

		// -------o public
			
			/**
			* toPosition function
			* @public
			* @param 
			* @return
			*/
			public function toPosition( v : Vector2D ) : Void {
				_vTargetPos = v;
			}
		
			/**
			* calculate function
			* @public
			* @param 
			* @return
			*/
			override public function calculate(  ) : Vector2D {
				
				if ( entity == null )
					return new Vector2D( );
				
				var 	vVel : Vector2D = _vTargetPos.sub( entity.position );
				
				var		nDis : Float = vVel.length;
				
				if ( nDis > 0.5 ) {
					vVel.scaleBy( .1 );
					vVel.decrementBy( entity.velocity );
					return vVel;
				}else if ( fComplete != null ) {
					fComplete( );
				}
				return new Vector2D( );
			}
			
			/**
			* calc function
			* @public
			* @param 
			* @return
			*/
			static public function calc( from : SteeringEntity , to : Vector2D ) : Vector2D {
				
				var 	vVel : Vector2D = to.sub(from.position);
				var 	nDis : Float = vVel.length;
				
				if( nDis > .01 ){
					vVel.scaleBy( .1 );
					vVel.decrementBy( from.velocity );
					return vVel;
				}
					
				return new Vector2D();
				
			}
			
		// -------o protected

		// -------o misc

	}

