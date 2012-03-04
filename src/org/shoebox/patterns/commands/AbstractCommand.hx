package org.shoebox.patterns.commands;

import nme.errors.Error;
import nme.events.Event;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.patterns.frontcontroller.FrontController;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */

class AbstractCommand extends Signal , implements ICommand{

	public var frontController : FrontController;
	public var isRunning : Bool;
	public var cancelable ( default , default )     : Bool; //TODO : Deprecated

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function execute( ?e : Event = null ) : Void {
			
			if( isRunning )
				throw new Error('Error : Command is already running');

			isRunning = true;
			onExecute( e );

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function cancel( ?e : Event = null ) : Void {
			if( !isRunning )
				throw new Error('Error : Command is not running');

			isRunning = false;
			onCancel( e );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function onExecute( ? e : Event = null  ) : Void {
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function onCancel( ?e : Event = null ) : Void {
			
		}

	// -------o protected
	
	// -------o misc
	
}