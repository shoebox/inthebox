package org.shoebox.net;

import haxe.Json;

/**
 * ...
 * @author shoe[box]
 */

class Paths{
	
	static public var domain : String;

	static private var _aConstants : Array<Constant>;
	static private var _aDomains   : Array<Domain>;
	static private var _aPaths     : Array<Path>;
	static private var _hPaths     : Map<String,String>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		private function new() {
			trace('constructor');		
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @param 	s : Json string ( String )
		* @return	true if sucessfull ( Bool )
		*/
		static public function init( s : String ) : Bool {
			
			var oDesc = Json.parse( s );
			_aConstants = oDesc.constants;
			_aDomains = oDesc.domains;
			_test( );
			
			return true;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function tracePaths( ) : String {
			
			var s = '\n###################\nPaths for domain : '+domain+'\n\n';
				s+='CONSTANTS __________________________________________________________________\n';
			for( c in _aConstants )
				s+='\t' + c.name + ' \t\t= ' + c.value+'\n';
				s+='\n';
				s+='PATHS LIST __________________________________________________________________\n';
			for( p in _aPaths )
				s+= '\t' + p.name+' \t\t= '+p.value+'\n';

			return s;
		}

		/**
		* Get a path URL for the given path code name
		* example : getPath( 'scripts')
		* return : http://localhost/scripts/
		* 
		* @public
		* @param 	sName : Path code name ( String )
		* @return	path ( String )
		*/
		static public function get( sName : String ) : String {

			if( !_hPaths.exists( sName ) )
				throw new flash.errors.Error('The path '+sName+' is not defined for the current domain : '+domain);

			return _hPaths.get( sName );
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _test( ) : Void{
			#if flash
			var sUrl = flash.Lib.current.stage.loaderInfo.url;
			#else
			var sUrl = 'DEFAULT';
			#end
			
			if( !_testDomain( sUrl ) ){
				_testDomain('DEFAULT');	
			}

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _testDomain( sUrl : String ) : Bool{
			
			var reg : EReg;
			for( dom in _aDomains ){
				reg = new EReg( dom.domain , 'gi' );
				if( reg.match( sUrl ) ){

					// Parsing paths linked to the domains
						_aPaths = dom.paths;
						_hPaths = new Map<String,String>( );
						for( p in _aPaths ){
							_hPaths.set( p.name , p.value );
						}

					// The current domain
						domain = dom.domain;

					return true;
				}
			}


			return false;
		}
		

	// -------o misc
	

}

typedef Constant={
	public var name  : String;
	public var value : Dynamic;
}

typedef Domain = {
	public var domain : String;
	public var paths  : Array<Path>;
}

typedef Path = {
	public var name  : String;
	public var value : String;
}