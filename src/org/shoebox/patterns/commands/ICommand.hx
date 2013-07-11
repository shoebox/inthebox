package org.shoebox.patterns.commands;

	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * @author shoe[box]
	 */
	interface ICommand extends IEventDispatcher{

		function onExecute( ) : Void;

		function onCancel( ) : Void;

	}
