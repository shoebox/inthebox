package org.shoebox.patterns.commands; 

	import nme.events.Event;
	import nme.events.IEventDispatcher;
	
	/**
	 * @author shoe[box]
	 */
	interface ICommand implements IEventDispatcher{
		
		function onExecute( ?e : Event = null ) : Void;

		function onCancel( ?e : Event = null ) : Void;
		
	}
