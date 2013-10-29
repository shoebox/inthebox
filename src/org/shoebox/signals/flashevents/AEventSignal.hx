package org.shoebox.signals.flashevents;
import flash.events.EventDispatcher;
import flash.events.Event;
import org.shoebox.signals.flashevents.AEventSignal.SignalEntry;
import org.shoebox.signals.flashevents.AEventSignal.SignalEvent;
import org.shoebox.signals.Signal.Signal;

/**
 * ...
 * @author shoe[box]
 */
class AEventSignal<T:EventDispatcher,E:Event>{ 

	private var _aCache : Array<SignalEntry<T,E>>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			_aCache = [ ];
		}
	
	// -------o public
				
		/**
		* Register a listener for the Event
		*
		* @public
		* @return	void
		*/
		public function register( target : T , sEvent_name : String , b : Bool = false ) : SignalEvent<E> { 
			
			//Already exists ?
				var e : SignalEntry<T,E> = _get( target , sEvent_name , b );
				if ( e != null && e.listener != null ) {
					return e.listener.signal;
				}
			
			//The cache item
				e = new SignalEntry<T,E>( target , sEvent_name , b );
				e.listener = new Listener<E>( target , sEvent_name , b );
				
			//Adding to the cache
				_aCache.push( e );
			
			return e.listener.signal;
		}	

	// -------o protected
	
		/**
		* Retrieve a cached <code>SignalEntry</code> if exists with those parameters
		*
		* @private
		* @params 	t : Signal Type 		( T )
		* @params 	b : Bubbling or not		( Bool )
		* @return	entry ( SignalEntry<T,E> )
		*/
		private function _get( t : T , s : String , b : Bool ) : SignalEntry<T,E> {
			
			//
				var res : SignalEntry<T,E> = null;			
				
			//
				for ( e in _aCache ) {					
					if ( e.target == t && e.sEvent_name == s && e.bBubbling == b ){
						trace("found");
						res = e;
						break;
					}					
				}
				
			//
				return res;
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */
class SignalEntry<T,E:Event>{
	
	public var target : T;
	public var sEvent_name : String;
	public var bBubbling : Bool;
	public var listener : Listener<E>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( t : T , s : String , b : Bool ) {
			this.target = t;
			this.sEvent_name = s;
			this.bBubbling = b;
		}
	
	// -------o public
	
	// -------o protected
	
	// -------o misc
	
}


/**
 * ...
 * @author shoe[box]
 */
class Listener<E:Event>{
	
	public var enabled( default , set ) : Bool;
	
	public var target : EventDispatcher;
	public var sEvent_name : String;
	public var iPrio : Int;
	public var bBubbling : Bool;
	
	public var signal : SignalEvent<E>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( t : EventDispatcher , s : String , b : Bool = false , p : Int = 1 ) {
			this.target = t;
			this.sEvent_name = s;			
			this.bBubbling = b;
			this.iPrio = p;
			signal = new SignalEvent<E>( );
			enabled = true;
		}
	
	// -------o public
				
				

	// -------o protected
	
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function set_enabled( b : Bool ) : Bool {
			if( b )
				target.addEventListener( sEvent_name , _onCallback , bBubbling , iPrio );
			else
				target.removeEventListener( sEvent_name , _onCallback , bBubbling );
			return this.enabled = b;
		}
		
		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onCallback( e : E ) : Void {
			signal.emit( e );
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */
class SignalEvent<E:Event> extends Signal<E->Void>{

}