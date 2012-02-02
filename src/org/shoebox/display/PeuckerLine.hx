/**
  HomeMade by shoe[box]
  IN THE BOX PACKAGE (http://code.google.com/p/inthebox/)
   
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

package org.shoebox.display;

	import org.shoebox.core.Vector2D;
	
	/**
	* org.shoebox.display.PeuckerLine
	* @author shoebox
	*/
	class PeuckerLine {
		
		private var _vPoints					: Array<Vector2D>;
		private var _vTmp						: Array<Bool>;
		private var _nTolerance					: Float;
		private var _nTolerance2				: Float;
		
		// -------o constructor
		
			/**
			* Constructor of the PeuckerLine class
			*
			* @public
			* @return	void
			*/
			public function new() : Void {
				setTolerance( 10 );
			}

		// -------o public
			
			/**
			* set tolerance function
			* @public
			* @param 
			* @return
			*/
			public function setTolerance( n : Float ) : Void {
				_nTolerance = n;
				_nTolerance2 = n * n;
			}
			
			/**
			* optimize function
			* @public
			* @param 
			* @return
			*/
			public function optimize( v : Array<Vector2D> , vOutput : Array<Vector2D> = null ) : Array<Vector2D> {
				
				if( vOutput == null )
					vOutput = new Array<Vector2D>( );
				
				var l : Int = v.length;
				var iLast : Int = l - 1;
				
				//
					_vPoints = v;
					_vTmp = new Array<Bool>( );
					_vTmp[ 0 ] = true;
					_vTmp[ iLast ] = true;
			
				//
					_optimize( 0 , iLast );
				
				//
					var i : Int = 0;
					while( i <= iLast ){
						
						if( _vTmp[i] )
							vOutput.push(v[i]);
						i ++;
					}
				
				return vOutput;
				
				
			}
			
		// -------o private
		
			/**
			* 
			*
			* @param 
			* @return
			*/
			private function _optimize( iStart : Int , iEnd : Int ) : Void {
				
				if (iEnd <= iStart + 1)
					return;
	
				var iMaxi : Int = iStart;
				var nMax2 : Float = 0;
				var dv2 : Float;
				var ls : LineSegment = new LineSegment ( _vPoints[iStart] , _vPoints[iEnd] );
	
				var i : Int = iStart + 1;
	
				while( i < iEnd ){
					
					dv2 = ls.distanceToSeg ( _vPoints[i] );
					if (dv2 > nMax2) {
						iMaxi = i;
						nMax2 = dv2;
					}
					i++;
				}
	
				if (nMax2 > _nTolerance2) {
					_vTmp[iMaxi] = true;
					_optimize ( iStart , iMaxi );
					_optimize ( iMaxi , iEnd );
				}
			}
				
		// -------o misc

	}


	import org.shoebox.core.Vector2D;
	
	/**
	* org.shoebox.display.line.LineSegment
	* @author shoebox
	*/
	class LineSegment {
		
		public var v1 : Vector2D ;
		public var v2 : Vector2D ;
		
		// -------o constructor
		
			/**
			* Constructor of the LineSegment class
			*
			* @public
			* @return	void
			*/
			public function new( v1 : Vector2D , v2 : Vector2D ) : Void {
				this.v1 = v1;
				this.v2 = v2;
			}

		// -------o public
			
			/**
			* distanceToSeg function
			* @public
			* @param 
			* @return
			*/
			public function distanceToSeg( vSeg : Vector2D ) : Float {
				
				var v : Vector2D = v2.sub( v1 );
				var w : Vector2D = vSeg.sub( v1 );
				var c1 : Float = w.dotProd( v );
				if( c1 <= 0 )
					return w.lengthSQ;
					
				var c2 : Float = v.dotProd( v );
				if( c2 <= c1 )
					return vSeg.sub( v2 ).length;
					
				var b : Float = c1 / c2;
				var r : Vector2D = new Vector2D( v1.x + b * v.x , v1.y + b * v.y );
				return vSeg.sub( r ).lengthSQ;
			}
					
		// -------o private

		// -------o misc
		
	}


