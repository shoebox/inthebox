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
package org.shoebox.ui.gestures;

import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.system.Capabilities;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.geom.FPoint;

/**
 * ...
 * @author shoe[box]
 */
class GestureBase extends AbstractCommand  implements ICommand{

	public var MIN_MOVE : Float;

	#if debug
	public var gDebug( default , default ) : Graphics;
	#end

	private var _iCount   : Int;
	private var _fCentral : FPoint;
	private var _hPoints  : IntMap<String,TouchPoint2>;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {
			super( );
			_hPoints = new IntMap<String,TouchPoint2>( );
			MIN_MOVE = 50 / 254 * Capabilities.screenDPI;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function onExecute( ) : Void {

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function onCancel( ) : Void {

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function addTouchPoint( id : Int , fx : Float , fy : Float , time : Int ) : Void {
			_hPoints.set( id , { id : id , x : fx , y : fy , time : time } );
			_iCount++;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function updateTouchPoint( id : Int , fx : Float , fy : Float , time : Int ) : Void {
			var pt = _hPoints.get( id );
				pt.x = fx;
				pt.y = fy;
				pt.time = time;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function removeTouchPoint( id : Int ) : Void {
			_hPoints.remove( id );
			_iCount--;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function updateCenter( ) : FPoint {

			_fCentral = { x : 0.0 , y : 0.0 };

			var i : Int = 0;
			for( val in _hPoints ){
				_fCentral.x += val.x;
				_fCentral.y += val.y;
				i++;
			}
			_fCentral.x /= i;
			_fCentral.y /= i;
			return _fCentral;
		}

		#if debug

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _debug( ) : Void{
			if( gDebug == null )
				return;

			_clearDebug( );
			gDebug.lineStyle( 0.2 , 0xFFFFFF );
			for( val in _hPoints ){
				gDebug.drawCircle( val.x , val.y , 40 );
			}
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _clearDebug( ) : Void{
			if( gDebug == null )
				return;

			gDebug.clear( );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _debug_drawCenter( ) : Void{

			if( gDebug == null )
				return;

			if( _fCentral == null )
				return;

			gDebug.moveTo( _fCentral.x - 10 , _fCentral.y );
			gDebug.lineTo( _fCentral.x + 10 , _fCentral.y );
			gDebug.moveTo( _fCentral.x , _fCentral.y - 10 );
			gDebug.lineTo( _fCentral.x , _fCentral.y + 10 );
		}

		#end


	// -------o protected

	// -------o misc

}

typedef FPoint={
	public var x : Float;
	public var y : Float;
}

typedef TouchPoint2={
	> FPoint,
	public var id   : Int;
	public var time : Int;
}

