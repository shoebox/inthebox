package org.shoebox.utils.frak;

import nme.display.Sprite;
import nme.events.Event;
import org.shoebox.patterns.mvc.abstracts.AApplication;
import org.shoebox.patterns.mvc.commands.MVCCommand;

/**
 * ...
 * @author shoe[box]
 */

class Frak extends AApplication{

	private var _oComm : MVCCommand;

	private static var __instance 		: Frak;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( e : SingletonEnforcer = null ) {
			super( );
			
			if( e == null )
				throw new nme.errors.Error( );
			
			addEventListener( Event.ADDED_TO_STAGE , _onStaged , false );	
		}
	
	// -------o public
				
				

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onStaged( e : Event ) : Void{
			
			//
				removeEventListener( Event.ADDED_TO_STAGE , _onStaged , false );	
				addEventListener( Event.REMOVED_FROM_STAGE , _onRemoved , false );
			
			//
				_oComm = new MVCCommand( MFrak , VFrak , CFrak , this , null );
				_oComm.prepare( );
				_oComm.execute( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onRemoved( e : Event ) : Void{
			removeEventListener( Event.REMOVED_FROM_STAGE , _onRemoved , false );	
			addEventListener( Event.ADDED_TO_STAGE , _onStaged , false );
		}

	// -------o misc
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline static public function getInstance( ) : Frak {
			
			if( __instance == null )
				__instance = new Frak( new SingletonEnforcer( ) );

			return __instance;
		}

}

class SingletonEnforcer{
	
	public function new():Void{}

}