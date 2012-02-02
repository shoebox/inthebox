/**
* This is about <code>fr.hyperfiction.touchsandbox.core.Delayer</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/
package org.shoebox.events.seq;

	import nme.events.EventDispatcher;
	import nme.events.Event;

	/**
	* fr.hyperfiction.touchsandbox.core.Delayer
	* @author shoebox
	*/
	class SeqEvent extends EventDispatcher ,  implements ISeq{
		
		public static inline var DONE	: String = 'SeqEvent_DONE';
		
		public var sType				: String;
		public var target				: EventDispatcher;
		
		private var _bBubble			: Bool;
		
		// -------o constructor
		
			/**
			* Constructor of the Delayer class
			*
			* @public
			* @return	void
			*/
			public function new( target : EventDispatcher , sType : String , bBubble : Bool = false ) : Void {
				super( );
				
				_bBubble = bBubble;
				
				this.target = target;
				this.sType 	= sType;
			}

		// -------o public
			
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function start( ) : Void{
				target.addEventListener( sType , _onEvent , _bBubble );
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function cancel( ) : Void{
				target.removeEventListener( sType , _onEvent , _bBubble );
			}
			
		// -------o protected


			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _onEvent( e : Event ) : Void{
				var eCustom : CustomEvent = new CustomEvent( DONE , false , true , e );
				dispatchEvent( eCustom );
			}

		// -------o misc

	}
