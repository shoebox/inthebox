package org.shoebox.utils.system.flashevents;

import nme.events.Event;
import nme.display.DisplayObject;
import nme.events.MouseEvent;
import org.shoebox.utils.system.SignalEvent;

/**
 * ...
 * @author shoe[box]
 */

class DisplayObjectEv{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function onFrame( d : DisplayObject ) : SignalEvent {
			return new SignalEvent( d , Event.ENTER_FRAME , false );			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function onMouseDown( d : DisplayObject ) : SignalEvent {
			return new SignalEvent( d , MouseEvent.MOUSE_DOWN , false );
		}

	// -------o protected
		
	// -------o misc
	
}