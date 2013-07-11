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
package org.shoebox.ui;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.Capabilities;
#if mobile
import flash.events.TouchEvent;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
#end
import org.shoebox.core.BoxMath;
import org.shoebox.geom.FPoint;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.utils.system.Signal2;

using org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */

class MouseDrag extends AbstractCommand  implements ICommand{

	public var startPosition( _getStart , never ) : FPoint;

	public static inline var START : String = 'MouseDrag_START';
	public static inline var STOP  : String = 'MouseDrag_STOP';

	public var MIN_MOVE   : Float;
	public var signalMove : Signal2<Float,Float>;

	private var _fStart  : FPoint;
	private var _fPrev   : FPoint;
	private var _oTarget : InteractiveObject;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( target : InteractiveObject , bTouchEnabled : Bool = true ) {
			super( );
			_oTarget   = target;
			signalMove = new Signal2<Float,Float>( );
			MIN_MOVE = 20 / 254 * Capabilities.screenDPI;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function onExecute( ) : Void {

			_fStart = new FPoint( );//{ x : 0.0 , y : 0.0 };
			_fPrev  = new FPoint( );//{ x : 0.0 , y : 0.0 };

			#if mobile
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				_oTarget.touchBegin( ).connect( _touchBegin );
			#else
				_oTarget.mouseDown( ).connect( _mouseBegin );
			#end
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		override public function onCancel( ) : Void {

			if( _oTarget == null )
				return;

			#if mobile
			_oTarget.touchBegin( ).disconnect( _touchBegin );
			_oTarget.touchMove( ).disconnect( _touchMove );
			_oTarget.touchEnd( ).disconnect( _touchEnd );
			#else
			_oTarget.mouseDown( ).disconnect( _mouseBegin );
			_oTarget.mouseMove( ).disconnect( _mouseMove );
			_oTarget.mouseUp( ).disconnect( _mouseEnd );
			#end
		}

	// -------o protected

		#if mobile

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _touchBegin( e : TouchEvent ) : Void{
			_start( e.stageX , e.stageY );
			_oTarget.touchMove( ).connect( _touchMove );
			_oTarget.touchEnd( ).connect( _touchEnd );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _touchMove( e : TouchEvent ) : Void{
			_move( e.stageX , e.stageY );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _touchEnd( e : TouchEvent ) : Void{
			_oTarget.touchMove( ).disconnect( _touchMove );
			_oTarget.touchEnd( ).disconnect( _touchEnd );
		}

		#else

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _mouseBegin( e : MouseEvent ) : Void{
			_start( e.stageX , e.stageY );
			_oTarget.mouseMove( ).connect( _mouseMove );
			_oTarget.mouseUp( ).connect( _mouseEnd );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _mouseMove( e : MouseEvent ) : Void{
			_move( e.stageX , e.stageY );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _mouseEnd( e : MouseEvent ) : Void{
			_oTarget.mouseMove( ).disconnect( _mouseMove );
			_oTarget.mouseUp( ).disconnect( _mouseEnd );
		}

		#end

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _start( fx : Float , fy : Float ) : Void{
			_fStart.x = fx;
			_fStart.y = fy;
			_fPrev.x  = fx;
			_fPrev.y  = fy;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _move( fx : Float , fy : Float ) : Void{

			var len = BoxMath.length( fx - _fPrev.x , fy - _fPrev.y );
			if( len > MIN_MOVE ){
				signalMove.emit( fx - _fStart.x , fy - _fStart.y );
				_fStart.x = fx;
				_fStart.y = fy;
			}
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _getStart( ) : FPoint{
			return _fStart;
		}

	// -------o misc

}