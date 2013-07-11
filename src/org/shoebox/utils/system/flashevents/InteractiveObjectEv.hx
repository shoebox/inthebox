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
package org.shoebox.utils.system.flashevents ;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import org.shoebox.utils.system.SignalEvent;
import org.shoebox.utils.system.flashevents.EvChannels;
import org.shoebox.utils.system.flashevents.InteractiveObjectEv;

/**
 * ...
 * @author shoe[box]
 */

class InteractiveObjectEv{

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {

		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function onKeyDown( d : InteractiveObject ) : SignalEvent<KeyboardEvent> {
			return _keyboardCreate( d , KeyboardEvent.KEY_DOWN );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function onKeyUp( d : InteractiveObject ) : SignalEvent<KeyboardEvent> {
			return _keyboardCreate( d , KeyboardEvent.KEY_UP );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function onStaged( d : InteractiveObject ) : SignalEvent<Event> {
			return _create( d , Event.ADDED_TO_STAGE );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function onResize( d : InteractiveObject ) : SignalEvent<Event> {
			return _create( flash.Lib.current.stage , Event.RESIZE );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function onRemoved( d : InteractiveObject ) : SignalEvent<Event> {
			return _create( d , Event.REMOVED_FROM_STAGE );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function onFrame( d : InteractiveObject ) : SignalEvent<Event> {
			return _create( d , Event.ENTER_FRAME );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function onClick( d : InteractiveObject , b : Bool = false ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.CLICK );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function mouseDown( d : InteractiveObject , b : Bool = false ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_DOWN , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function mouseMove( d : InteractiveObject , b : Bool = false ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_MOVE , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function mouseUp( d : InteractiveObject , b : Bool = false) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_UP , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function rollOut( d : InteractiveObject , ?b : Bool ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.ROLL_OUT , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function rollOver( d : InteractiveObject , ?b : Bool ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.ROLL_OVER , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function mouseOver( d : InteractiveObject , b : Bool = false) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_OVER , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function mouseOut( d : InteractiveObject , b : Bool = false) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_OUT , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function mouseWheel( d : InteractiveObject , b : Bool = false ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_WHEEL , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function touchBegin( d : InteractiveObject , b : Bool = false ) : SignalEvent<TouchEvent>{
			return _mouseEvCreate( d , TouchEvent.TOUCH_BEGIN , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function touchMove( d : InteractiveObject , b : Bool = false) : SignalEvent<TouchEvent>{
			return _mouseEvCreate( d , TouchEvent.TOUCH_MOVE , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function touchEnd( d : InteractiveObject , b : Bool = false) : SignalEvent<TouchEvent>{
			return _mouseEvCreate( d , TouchEvent.TOUCH_END , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function touchTap( d : InteractiveObject , b : Bool = false) : SignalEvent<TouchEvent>{
			//TOUCH_TAP
			return _mouseEvCreate( d , TouchEvent.TOUCH_END , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function removeAll( d : InteractiveObject ) : Void {
			FlashEventsCache.getInstance( ).purgeTarget( EvChannels.InteractiveObject , d );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function focusIn( d : InteractiveObject , ?b :  Bool ) : SignalEvent<Dynamic> {
			return FlashEventsCache.getInstance( ).get( FocusEvent , EvChannels.InteractiveObject , d , FocusEvent.FOCUS_IN , b );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function focusOut( d : InteractiveObject , ?b :  Bool ) : SignalEvent<Dynamic> {
			return FlashEventsCache.getInstance( ).get( FocusEvent , EvChannels.InteractiveObject , d , FocusEvent.FOCUS_OUT , b );
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		static private function _create( d : InteractiveObject , s : String ) : SignalEvent<Event>{
			return FlashEventsCache.getInstance( ).get( Event , EvChannels.InteractiveObject , d , s , false );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		static private function _mouseEvCreate( d : InteractiveObject , s : String , b : Bool = false ) : Dynamic{
			return FlashEventsCache.getInstance( ).get( MouseEvent , EvChannels.InteractiveObject , d , s , b );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		static private function _keyboardCreate( d : InteractiveObject , s : String , b : Bool = false ) : Dynamic{
			return FlashEventsCache.getInstance( ).get( KeyboardEvent , EvChannels.InteractiveObject , d , s , b );
		}

	// -------o misc

}