package org.shoebox.utils.frak;

import nme.display.Sprite;
import nme.events.Event;
import org.shoebox.patterns.mvc.abstracts.AApplication;
import org.shoebox.patterns.mvc.commands.MVCCommand;

/**
 * ...
 * @author shoe[box]
 */

class Frak extends AApplication{

	private var _oComm : MVCCommand;

	private static var __instance 		: Frak;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( e : SingletonEnforcer = null ) {
			
			super( );
			
			if( e == null )
				throw new nme.errors.Error( );
			
			_oComm = new MVCCommand( MFrak , VFrak , CFrak , this , null );
			_oComm.prepare( );
			_oComm.execute( );
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function registerAlias( sAlias : String , o : Dynamic , sHelp : String , b : Bool = false ) : Void {
			return _getModel( ).registerAlias( sAlias , o , sHelp , b );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function unRegisterAlias( sAlias : String , o : Dynamic ) : Bool {
			return _getModel( ).unRegisterAlias( sAlias , o );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function registerVariable( s : String , target : Dynamic , prop : String ) : Bool {
			return _getModel( ).registerVariable( s , target , prop );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function unRegisterVariable( s : String ) : Bool {
			return _getModel( ).unRegisterVariable( s );
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _getModel( ) : MFrak{
			return cast( getInstance( )._oComm.model , MFrak );
		}

	// -------o misc
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		inline static public function getInstance( ) : Frak {
			
			if( __instance == null )
				__instance = new Frak( new SingletonEnforcer( ) );

			return __instance;
		}

}

class SingletonEnforcer{
	
	public function new():Void{}

}