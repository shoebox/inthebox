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
package org.shoebox.geom;

import com.eclecticdesignstudio.motion.Actuate;
import nme.geom.Matrix;
import org.shoebox.core.BoxMath;
import org.shoebox.geom.FPoint;


/**
 * ...
 * @author shoe[box]
 */

class Camera2D{

	private var _bInvalidate   : Bool;
	private var _fAngle        : Float;
	private var _fZoom         : Float;
	private var _fViewPort     : FPoint;
	private var _FPoint        : FPoint;
	private var _fHalfViewPort : FPoint;
	private var _fLimits       : FPoint;
	private var _mProj         : Matrix;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			_fViewPort     = { x : 0.0 , y : 0.0 };
			_FPoint     = { x : 0.0 , y : 0.0 };
			_fHalfViewPort = { x : 0.0 , y : 0.0 };
			_fZoom         = 1.0;
			_fAngle        = 0;
			_mProj         = new Matrix() ;
			_bInvalidate   = true;
		}
	
	// -------o public
	
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setViewPort( w : Float , h : Float ) : Void {
			_fViewPort.x     = w;
			_fViewPort.y     = h;	
			_fHalfViewPort.x = w / 2;
			_fHalfViewPort.y = h / 2;
			_bInvalidate = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setPosition( x : Float , y : Float ) : Void {
			_FPoint.x = x;
			_FPoint.y = y;
			//_limits( );
			_bInvalidate = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function move( dx : Float , dy : Float ) : Void {
			setPosition( _FPoint.x + dx , _FPoint.y + dy );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getMatrix( ) : Matrix {
			
			if( !_bInvalidate )
				return _mProj;
			_FPoint.x = _limit( _FPoint.x , _fLimits.x * _fZoom , _fHalfViewPort.x );
			_FPoint.y = _limit( _FPoint.y , _fLimits.y * _fZoom , _fHalfViewPort.y );

			_mProj.identity( );
			_mProj.translate( -_FPoint.x , -_FPoint.y );
			_mProj.rotate( 0 );
			_mProj.scale( _fZoom , _fZoom );
			_mProj.translate( _fHalfViewPort.x , _fHalfViewPort.y );
			
			return _mProj;
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setLimits( fMaxX : Float , fMaxY : Float ) : Void {

			_fLimits = { x : fMaxX , y : fMaxY };
			_bInvalidate = true;

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function zoom( f : Float ) : Void {
			_fZoom *= f;
			_fZoom = BoxMath.clamp( _fZoom , 1 , 10 );
			_bInvalidate = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getZoom( ) : Float {
			return _fZoom;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function appendZoom( f : Float ) : Void {
			_fZoom += _fZoom * f;
			_fZoom = BoxMath.clamp( _fZoom , 1 , 10 );
			_bInvalidate = true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function moveTo( dx : Float , dy : Float , nDur : Float = 1 ) : Void {
			Actuate.tween( _FPoint , 10 , { x : dx , y : dy } , true );
		}

	// -------o protected
		
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _limit( num : Float , all : Float , r : Float ) : Float{
			return BoxMath.clamp( num , r / _fZoom , ( all  - r ) / _fZoom );
		}

	// -------o misc
	
}