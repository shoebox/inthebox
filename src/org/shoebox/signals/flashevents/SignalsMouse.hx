package org.shoebox.signals.flashevents;

import org.shoebox.signals.flashevents.AEventSignal;

import flash.display.InteractiveObject;
import flash.events.MouseEvent;

/**
 * ...
 * @author shoe[box]
 */
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.CLICK         , "onClic" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.DOUBLE_CLICK  , "onDouble_clic" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.MOUSE_DOWN    , "onMouse_down" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.MOUSE_MOVE    , "onMouse_move" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.MOUSE_OUT     , "onMouse_out" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.MOUSE_OVER    , "onMouse_over" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.MOUSE_UP      , "onMouse_up" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.MOUSE_WHEEL   , "onMouse_wheel" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.ROLL_OUT      , "onRoll_out" ))
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( MouseEvent , InteractiveObject , MouseEvent.ROLL_OVER     , "onRoll_over" ))
class SignalsMouse extends AEventSignal<InteractiveObject,MouseEvent>{

	// -------o constructor

	// -------o public

	// -------o protected

	// -------o misc

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function getInstance( ) : SignalsMouse {

			if ( __instance == null )
				__instance = new SignalsMouse( );
			return __instance;
		}

		private static var __instance : SignalsMouse = null;
}

