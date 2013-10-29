package org.shoebox.signals.flashevents;

import org.shoebox.signals.flashevents.AEventSignal;

import flash.events.Event;
import flash.display.Stage;
import flash.display.DisplayObject;

/**
 * ...
 * @author shoe[box]
 */
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( Event , DisplayObject , Event.RESIZE 				, "onResize") )
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( Event , DisplayObject , Event.ADDED_TO_STAGE 		, "onStaged") )
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( Event , DisplayObject , Event.REMOVED_FROM_STAGE 	, "onRemoved") )
#if flash
@:build( org.shoebox.signals.flashevents.MacroSignalEvent.create( Event , DisplayObject , Event.FULLSCREEN 			, "onFull_screen") )
#end
class SignalsStage extends AEventSignal<DisplayObject,Event>{
	
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
		static public function getInstance( ) : SignalsStage {
			
			if ( __instance == null )
				__instance = new SignalsStage( );
			return __instance;			
		}
		
		private static var __instance : SignalsStage = null;
}

