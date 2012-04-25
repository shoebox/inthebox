package org.shoebox.utils.system.flashevents ;

import nme.display.InteractiveObject;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
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
		static public function onStaged( d : InteractiveObject ) : SignalEvent<Event> {
			return _create( d , Event.ADDED_TO_STAGE );			
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

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _create( d : InteractiveObject , s : String ) : SignalEvent<Event>{
			return FlashEventsCache.getInstance( ).get( EvChannels.InteractiveObject , d , s , false );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _mouseEvCreate( d : InteractiveObject , s : String , b : Bool = false ) : Dynamic{
			return FlashEventsCache.getInstance( ).get( EvChannels.InteractiveObject , d , s , b );
		}

	// -------o misc
	
}