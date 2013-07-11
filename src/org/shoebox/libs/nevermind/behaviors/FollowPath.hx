/**
  HomeMade by shoe[box]
 
  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of shoe[box] nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.shoebox.libs.nevermind.behaviors;

	import org.shoebox.core.Vector2D;
	import flash.Vector;

	/**
	 * org.shoebox.libs.nevermind.behaviors.FollowPath
	* @author shoebox
	*/
	class FollowPath extends ABehavior{
		
		public var bArrive					: Bool;
		public var bLoop					: Bool;
		public var fPathComplete			: Dynamic;
		public var nDistance				: Float ;
		
		private var _iPath				: Int;
		private var _iLen				: Int;
		private var vPath				: Array<Vector2D>;
		
		// -------o constructor
		
			/**
			* Constructor of the FollowPath class
			*
			* @public
			* @return	void
			*/
			public function new( bArrive : Bool , v : Array<Vector2D> , nDistance : Float = 50 , bLoop : Bool = false , fPathComplete : Dynamic = null ) : Void {
				
				this.bArrive			= bArrive;
				this.bLoop 				= bLoop;
				this.nDistance 			= nDistance;
				this.fPathComplete 		= fPathComplete;
				
				_iPath = 0;
				_iLen = v.length;
				vPath = v;
				super( .1 );
			}

		// -------o public
			
			/**
			* calculate function
			* @public
			* @param 
			* @return
			*/
			override public function calculate() : Vector2D {
 				
				if( vPath[ _iPath ].dist( entity.position ) < nDistance ){
			 		_iPath++;
			 		if( _iPath >= _iLen )
						if( bLoop ){
			 				_iPath = 0;
						}else{
							entity.removeBehavior( this );
							if( fPathComplete != null )
								fPathComplete( );
								
							return new Vector2D( );
						}
			 	}
				
				if( _iPath == _iLen-1 && !bLoop && bArrive ){
					return Arrive.calc( entity, vPath[ _iPath ]  );
				}else if( _iPath < _iLen ){
					return Seek.calc( entity, vPath[ _iPath ]  );
				}
				
				return new Vector2D( );
				
			}
			
		// -------o private

		// -------o misc

			
	}

