package org.shoebox.patterns.commands;

import flash.errors.Error;
import flash.events.EventDispatcher;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.patterns.frontcontroller.FrontController;
import org.shoebox.utils.system.Signal;

/**
 * ...
 * @author shoe[box]
 */

class AbstractCommand extends EventDispatcher  implements ICommand{

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
		public function execute(  ) : Void {
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