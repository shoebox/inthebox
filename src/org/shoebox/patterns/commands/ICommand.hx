package org.shoebox.patterns.commands; 
	
	import org.shoebox.patterns.frontcontroller.FrontController;
	import nme.events.IEventDispatcher;
	
	/**
	 * @author shoe[box]
	 */
	interface ICommand{
		
		function execute( ) : Void;
		function cancel( ) : Void;

		function onExecute( ) : Void;
		function onCancel( ) : Void;

		var frontController : FrontController;
		var isRunning : Bool;
		
	}
