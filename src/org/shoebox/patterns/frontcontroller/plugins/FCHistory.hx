package org.shoebox.patterns.frontcontroller.plugins;

import flash.events.KeyboardEvent;
import org.shoebox.patterns.frontcontroller.FrontController;
import org.shoebox.patterns.frontcontroller.plugins.AFCPlugin;

/**
 * ...
 * @author shoe[box]
 */

class FCHistory extends AFCPlugin{

	public var enabled ( default , default ) : Bool;

	private var _a_ignore : Array<String>;
	private var _a_history : Array<String>;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new( bAuto : Bool = false ) {
			super( );
			trace("constructor");
			if( bAuto )
				_init( );
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function clear_history( ) : Void {
			if( _a_history != null )
				_a_history.splice( 0 , _a_history.length );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function ignore( sState : String ) : Void {

			#if debug
				if( _a_ignore != null && Lambda.has( _a_ignore , sState ) )
					throw new flash.errors.Error( 'The state $sState is already ignored' );
			#end

			//
				if( _a_ignore == null )
					_a_ignore = [ ];
					_a_ignore.push( sState );

		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function go_back( ) : Bool {

			var b = can_go_back( );
			trace("go_back ::: "+b);
			if( !b )
				return false;

			if( _a_history == null || _a_history.length == 0 )
				return false;

			//
				var s = _a_history.pop( );
				trace("s ::: "+s);

			//
				fc_instance.onStateChange.disconnect( _on_state_change );
				fc_instance.state = s;
				fc_instance.onStateChange.connect( _on_state_change );

			return true;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function can_go_back( ) : Bool {
			return true;
		}

	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _init( ) : Void{
			flash.Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP , _onKey_up , false );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onKey_up( e : KeyboardEvent ) : Void{

			if( e.keyCode == 8 || e.keyCode == 27 ){
				e.stopImmediatePropagation();
				e.stopPropagation();
				#if flash
				e.preventDefault( );
				#end
				go_back( );
			}


		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		override private function set_fc_instance( fc : FrontController ) : FrontController{
			fc.onStateChange.connect( _on_state_change );
			return super.set_fc_instance( fc );
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _on_state_change( sPrev : String , sNew : String ) : Void{
			if( sPrev != null && !_is_ignored( sPrev ) ){
				if( _a_history == null )
					_a_history = [ ];
					_a_history.push( sPrev );
			}
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		inline private function _is_ignored( sToTest : String ) : Bool{

			var bRes = false;
			if( _a_ignore != null )
				bRes = Lambda.has( _a_ignore , sToTest );

			return bRes;
		}

	// -------o misc

}