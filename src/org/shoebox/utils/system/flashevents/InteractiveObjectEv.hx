package org.shoebox.utils.system.flashevents ;

import nme.display.InteractiveObject;
import nme.events.Event;
import nme.events.MouseEvent;
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
		static public function mouseDown( d : InteractiveObject ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_DOWN );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function mouseMove( d : InteractiveObject ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_MOVE );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function mouseUp( d : InteractiveObject ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_UP );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function mouseWheel( d : InteractiveObject ) : SignalEvent<MouseEvent> {
			return _mouseEvCreate( d , MouseEvent.MOUSE_WHEEL );
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
		static private function _mouseEvCreate<T>( d : InteractiveObject , s : String ) : Dynamic{
			return FlashEventsCache.getInstance( ).get( EvChannels.InteractiveObject , d , s , false );
		}

	// -------o misc
	
}