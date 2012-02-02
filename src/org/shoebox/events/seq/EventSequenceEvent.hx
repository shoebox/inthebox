package org.shoebox.events.seq;

	import nme.events.Event;
	
	class EventSequenceEvent extends Event{
		
		public var lastEvent		: Event ;
		
		public static var DONE	: String = 'EventSequenceEvent_DONE';
		
		public function new( s : String , lastEvent : Event = null ) : Void{
			super( s );
			this.lastEvent = lastEvent;
		}
		
	}