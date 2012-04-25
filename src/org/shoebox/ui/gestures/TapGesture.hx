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

import nme.Lib;
import nme.display.Graphics;
import nme.display.InteractiveObject;
import nme.events.Event;
import nme.events.TouchEvent;
import nme.system.Capabilities;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;

import org.shoebox.core.BoxMath;
import org.shoebox.geom.FPoint;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.utils.system.Signal1;

using org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */
class TapGesture extends GestureBase , implements ICommand{
	
	public var onTap : Signal1<TouchEvent>;

	private var _bActive    : Bool;
	private var _bBubbing   : Bool;
	private var _bMoved     : Bool;
	private var _iStartTime : Int;
	private var _oTarget    : InteractiveObject;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( target : InteractiveObject , ?b : Bool = false ) {
			super( );
			_oTarget  = target;
			_bBubbing = b;
			_bMoved   = false;
			onTap     = new Signal1<TouchEvent>( );			
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ?e : Event = null ) : Void {
			trace('onExecute');

			#if !mobile
				trace('SwipeGesture is Mobile mode only');
			#else
				if( Multitouch.inputMode != MultitouchInputMode.TOUCH_POINT )
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

				_oTarget.touchBegin( ).connect( _onTouchBegin );
				_oTarget.touchMove( ).connect( _onTouchMove );
				_oTarget.touchEnd( ).connect( _onTouchEnd );
			#end
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ?e : Event = null ) : Void {
			#if mobile
				_oTarget.touchBegin( ).disconnect( _onTouchBegin );
				_oTarget.touchMove( ).disconnect( _onTouchMove );
				_oTarget.touchEnd( ).disconnect( _onTouchEnd );			
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
		private function _onTouchBegin( e : TouchEvent ) : Void{
			addTouchPoint( e.touchPointID , e.stageX , e.stageY , Lib.getTimer( ) );
			_testActive( );		
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchMove( e : TouchEvent ) : Void{
			if( _bActive ){
				var prev = _hPoints.get( e.touchPointID );
				var len = BoxMath.length( e.stageX - prev.x , e.stageY - prev.y );
				_bMoved = ( len > MIN_MOVE );
			}
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTouchEnd( e : TouchEvent ) : Void{

			removeTouchPoint( e.touchPointID );
			_testActive( );
			if( !_bMoved && ( Lib.getTimer( ) - _iStartTime ) < 150 )
				onTap.emit( e );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _testActive( ) : Void{
			_bActive = _iCount == 1;
			if( _bActive ){
				_bMoved = false;
				_iStartTime = Lib.getTimer( );
			}
		}

		#end
		
	// -------o misc
	
}