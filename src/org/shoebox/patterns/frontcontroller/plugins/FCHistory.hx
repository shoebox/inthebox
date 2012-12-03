package org.shoebox.patterns.frontcontroller.plugins;

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
					throw new nme.errors.Error( Std.format( "The state $sState is already ignored"));
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

			if( _a_history == null || _a_history.length == 0 )
				return false;

			//
				trace('go_back');
				var s = _a_history.pop( );
				trace('s ::: '+s);

			//
				fc_instance.onStateChange.disconnect( _on_state_change );
				fc_instance.state = s;
				fc_instance.onStateChange.connect( _on_state_change );

			return true;
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		override private function _set_fc_instance( fc : FrontController ) : FrontController{

			//
				fc.onStateChange.connect( _on_state_change );

			return super._set_fc_instance( fc );
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
			for( s in _a_ignore ){
				if( sToTest == s ){
					bRes = true;
					break;
				}
			}

			return bRes;
		}	

	// -------o misc
	
}