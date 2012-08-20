package org.shoebox.utils.system.sequence;

import haxe.Timer;
import nme.events.Event;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;
import org.shoebox.utils.system.Signal1;

/**
 * ...
 * @author shoe[box]
 */

class SignalSequence extends AbstractCommand , implements ICommand{

	public var onComplete : Signal1<Event>;
	
	private var _aContent : Array<SeqDef>;
	private var _lastEv   : Event;
	private var _iCurrent : Int;
	private var _iMax     : Int;
	private var _oCurrent : SeqDef;
	private var _oDelayer : SeqDef;
	private var _tDelayer : Timer;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( bEmit_lastEvent : Bool = false ) {
			super( );
			trace('constructor');
			_aContent = [ ];
			onComplete = new Signal1<Event>( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add<T>( o : SeqDef ) : Void {
			_aContent.push( o );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ) : Void {
			_run( );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ) : Void {
			if( _oCurrent != null )
				_disconnect( _oCurrent );
			_resetDelayer( );
			_lastEv    = null;
			onComplete = null;
			_aContent  = null;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function reset( ) : Void {
			if( _oCurrent != null )
				_disconnect( _oCurrent );
			_lastEv = null;
			_resetDelayer( );
			_run( );			
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _run( ) : Void{
			_iCurrent = 0;
			_next( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _next( ) : Void{
			
			if( _iCurrent >= _aContent.length ){
				onComplete.emit( _lastEv );
				reset( );
				return;
			}

			_oCurrent = _aContent[ _iCurrent ];
			
			var b : Bool = false;
			switch( _oCurrent ){
				
				case Sig1( sig ):
					sig.connect( _onSig1  );

				case SeqDelayer( delay ):
					_oDelayer = _oCurrent;
					_tDelayer = Timer.delay( _onDelayed , delay );
					b = true;
			}
			
			_iCurrent++;
			if( b )
				_next( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _disconnect( o : SeqDef ) : Void{

			switch( o ){
				
				case Sig1( sig ):
					sig.disconnect( _onSig1 );

				case SeqDelayer( delay ):
					_tDelayer.stop( );
					_tDelayer = null;
					_oDelayer = null;

			}

			if( _oDelayer != null )
				_disconnect( _oDelayer );
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onDelayed( ) : Void{
			_disconnect( _oCurrent );
			_oCurrent = null;
			reset( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSig( ) : Void{
			_afterSignal( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSig1( e : Event ) : Void{
			_lastEv = e;
			_afterSignal( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _afterSignal( ) : Void{
			_disconnect( _oCurrent );
			_resetDelayer( );
			_next( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _resetDelayer( ) : Void{
			if( _tDelayer != null ){
				trace('_resetDelayer');
				_tDelayer.stop( );
				_tDelayer = null;
			}
		}

	// -------o misc
	
}

enum SeqDef{
	Sig1( target : Signal1<Dynamic> );
	SeqDelayer( duration : Int );
}
