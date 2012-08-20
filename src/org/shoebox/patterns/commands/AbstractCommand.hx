package org.shoebox.patterns.commands;

import nme.errors.Error;
import nme.events.Event;
import nme.events.EventDispatcher;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.patterns.frontcontroller.FrontController;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */

class AbstractCommand implements ICommand{

	public var frontController : FrontController;
	public var isRunning : Bool;
	
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
		public function execute( ) : Void {
			
			if( isRunning )
				throw new Error('Error : Command is already running');

			isRunning = true;
			onExecute( );

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function cancel( ) : Void {
			if( !isRunning )
				throw new Error('Error : Command is not running');

			isRunning = false;
			onCancel( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function onExecute( ) : Void {
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function onCancel( ) : Void {
			
		}

	// -------o protected
	
	// -------o misc
	
}