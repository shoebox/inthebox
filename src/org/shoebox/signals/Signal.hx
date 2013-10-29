package org.shoebox.signals;

import org.shoebox.collections.PriorityQueue;
import org.shoebox.collections.PriorityQueue.PriorityQueueIterator;
import org.shoebox.signals.Signal.SignalListener;

/**
 * ...
 * @author shoe[box]
 */
@:autoBuild( org.shoebox.signals.MacroEmit.create( ) )
class Signal<T> extends PriorityQueue<SignalListener<T>>{
	
	public var testVar : String;
	
	public var aList : PriorityQueue<SignalListener<T>>;
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
			aList = new PriorityQueue<SignalListener<T>>( );
		}
	
	// -------o public
				
		/**
		* Connect a listener to the Signal
		*
		* @public
		* @return	void
		*/
		public function connect( f : T , iPrio : Int = 1 , iCount : Int = -1 ) : Void {
			if( _listenerExists( f , iPrio ) )
				return;

			aList.add( new SignalListener<T>( f , iCount , iPrio ) , iPrio );
		}
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function connectOnce( f : T , iPrio : Int = 1 ) : Void {
			if( _listenerExists( f , iPrio ) )
				return;

			connect( f , iPrio , 1 );
		}
		
		/**
		* Disconnect a listener
		*
		* @public
		* @return	void
		*/
		public function disconnect( f : T , iPrio : Int = 1 ) : Void {
			
			for ( o in aList.iterator( ) ) {
				if ( o.fListener == f && o.iPrio == iPrio ) {
					aList.remove( o );
					break;
				}
			}
			
		}
		
		/**
		* When a listener receive Signal checking if the signal must "die"
		*
		* @public
		* @return	void
		*/
		public function emitted( l : SignalListener<T> ) : Void {
			
			//If no limit
				if ( l.iCount == -1 )
					return;
					
			//Emit count--
				l.iCount --;
				
			//If count == 0 we remove the listener
				if ( l.iCount == 0 ) 
					disconnect( l.fListener , l.iPrio );
		}

	// -------o protected
		
		/**
		* Test if a listener with those parameters already exists
		*
		* @private
		* @return	void
		*/
		private function _listenerExists( f : T , prio : Int = 0 ) : Bool{
			var b : Bool = false;
			var content = aList.getContent( );
			for( o in content ){
				if( o.content.fListener == f && o.prio == prio ){
					b = true;
					break;
				}
			}
			return b;
		}
	

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class SignalListener<T>{

	public var fListener : T;
	public var iCount    : Int;
	public var iPrio     : Int;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( f : T , iCount : Int , iPrio : Int ) {
			this.fListener = f;
			this.iCount    = iCount;
			this.iPrio     = iPrio;
		}

	// -------o public
	
		/**
		*
		*
		* @public
		* @return	void
		*/
		public function check( ) : Void {
				
		}
	
	// -------o protected
	
	// -------o misc

}