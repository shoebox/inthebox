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

	import org.shoebox.libs.nevermind.entity.SteeringEntity;
	import org.shoebox.core.Vector2D;

	/**
	 * org.shoebox.libs.nevermind.behaviors.Wander
	* @author shoebox
	*/
	class Wander extends ABehavior {
		
		private var _fWander : Float;

		// -------o constructor
		
			/**
			* Constructor of the Wander class
			*
			* @public
			* @return	void
			*/
			public function new( f : Float , fPrio : Float = 0.1) : Void {
				super( fPrio );
				_fWander = f;
			}

		// -------o public
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function setValue( f : Float ) : Void {
				_fWander = f;
			}

			/**
			* calculate function
			* @public
			* @param 
			* @return
			*/
			override public function calculate(  ) : Vector2D {
				
				return new Vector2D( Math.random( ) * _fWander - _fWander / 2 , Math.random( ) * _fWander - _fWander / 2 );
				
			}
			
			
		// -------o private

		// -------o misc

	}

