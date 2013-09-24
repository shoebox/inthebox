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

	public var x( default , _setXPosition ) : Float;
	public var y( default , _setYPosition ) : Float;
	public var zoom( default , _setZoom )   : Float;
	public var minZoom( default , default ) : Float;
	public var maxZoom( default , default ) : Float;

	private var _bInvalidate   : Bool;
	private var _fCanvasSize   : FPoint;
	private var _fHalfViewport : FPoint;
	private var _fViewport     : FPoint;
	private var _mMatrix       : Matrix;
	private var _mMatrixProj   : Matrix;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {
			trace('constructor');
			_bInvalidate   = true;
			_fCanvasSize   = new FPoint( ); //{ x : 0.0 , y : 0.0 };
			_fHalfViewport = new FPoint( ); //{ x : 0.0 , y : 0.0 };
			_fViewport     = new FPoint( ); //{ x : 0.0 , y : 0.0 };
			_mMatrix       = new Matrix( );
			_mMatrixProj   = new Matrix( );
			this.zoom      = 1.0;
			this.minZoom   = 1.0;
			this.maxZoom   = 5.0;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setViewport( w : Float , h : Float ) : Void {
			_fViewport.x = w;
			_fViewport.y = h;
			_fHalfViewport.x = w / 2;
			_fHalfViewport.y = h / 2;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setCanvasSize( w : Float , h : Float ) : Void {
			_fCanvasSize.x = w;
			_fCanvasSize.y = h;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function getMatrix( ) : Matrix {
			if( _bInvalidate )
				_invalidate( );
			return _mMatrix;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function setPosition( fx : Float , fy : Float ) : Void {
			this.x = fx;
			this.y = fy;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function prependZoom( f : Float ) : Void {
			zoom *= f;
			_bInvalidate = true;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function appendZoom( f : Float ) : Void {
			trace('appendZoom ::: '+f+' - '+zoom);
			zoom += zoom * f;
			//_fZoom = BoxMath.clamp( _fZoom , 1 , 10 );
			trace('_fZoom ::: '+zoom);
			_bInvalidate = true;
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _invalidate( ) : Void{
			_mMatrixProj.identity( );
			_mMatrixProj.translate( -x , -y );// - _fHalfViewport.x , -y - _fHalfViewport.y );
			_mMatrixProj.scale( zoom , zoom );
			_mMatrixProj.translate( _fHalfViewport.x , _fHalfViewport.y );

			_mMatrix.identity( );
			_mMatrix.concat( _mMatrixProj );
			_bInvalidate = false;

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _setXPosition( f : Float ) : Float{
			_bInvalidate = true;
			return this.x = BoxMath.clamp( f , _fHalfViewport.x / zoom , _fCanvasSize.x - _fHalfViewport.x / zoom );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _setYPosition( f : Float ) : Float{
			_bInvalidate = true;
			return this.y = BoxMath.clamp( f , _fHalfViewport.y / zoom , _fCanvasSize.y - _fHalfViewport.y / zoom );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _setZoom( f : Float ) : Float{
			trace('setZoom ::: '+f);
			_bInvalidate = true;
			_setXPosition( this.x );
			_setYPosition( this.y );
			return this.zoom = BoxMath.clamp( f , minZoom , maxZoom );
		}

	// -------o misc

}