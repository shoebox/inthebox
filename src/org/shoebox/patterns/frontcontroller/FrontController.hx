package org.shoebox.patterns.frontcontroller;

import flash.display.DisplayObjectContainer;
import nme.errors.Error;
import org.shoebox.core.BoxArray;
import org.shoebox.patterns.mvc.abstracts.AModel;
import org.shoebox.patterns.mvc.abstracts.AView;
import org.shoebox.patterns.mvc.abstracts.AController;
import org.shoebox.patterns.mvc.commands.MVCCommand;
import org.shoebox.patterns.mvc.MVCTriad;

/**
 * ...
 * @author shoe[box]
 */

class FrontController{

	public var owner ( default , default ) 		: DisplayObjectContainer;
	public var state ( _getState , _setState ) 	: String;

	private var _hTriads    : Hash<Dynamic>;
	private var _hStatesDesc: Hash<Array<String>>;
	private var _hVariables : Hash<Array<Dynamic>>;
	private var _sState     : String;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			_hTriads     = new Hash<Dynamic>( );
			_hStatesDesc = new Hash<Array<String>>( );
			_hVariables  = new Hash<Array<Dynamic>>( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add<M,V,C>( cM : Class<M> , cV : Class<V> , cC : Class<C> , ?container : DisplayObjectContainer = null) : String {
			
			if( owner == null )
				throw new Error( );

			var s = cM+'|'+cV+'|'+cC;//aCodes.join('|');//haxe.Md5.encode( cM+'-'+cV+'-'+cC );
			var t = MVCTriad.create( cM , cV , cC , container == null ? owner : container );
			
			_hTriads.set( s , t );

			return s;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get<M,V,C>( s : String ) : MVCTriad<Dynamic,Dynamic,Dynamic> {
			var t = _hTriads.get( s );
			return t;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function registerState( aCodes : Array<String> , sCodeName : String = null ) : String {
			
			if( sCodeName == null )
				sCodeName = aCodes.join('|');//haxe.Md5.encode( aCodes.join('-') );

			_hStatesDesc.set( sCodeName , aCodes );

			return sCodeName;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setAppVariables( sAppCode : String , vars : Array<Dynamic> ) : Void {
			_hVariables.set( sAppCode , vars );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getApp( sAppCode : String ) {
			return _hTriads.get( sAppCode );				
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getState( ) : String{
			return _sState;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setState( s : String ) : String{
			_drawState( _hStatesDesc.get( s ) );
			return _sState = s;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _drawState( a : Array<String> ) : Void{
			
			var oTri;
			
			if( _sState != null ){
				
				//
					var aPrev : Array<String> = _hStatesDesc.get( _sState );
					
				// Canceling previous apps
					var aDiff = BoxArray.difference( aPrev , a );
					for( sApp in aDiff ){
						oTri = _hTriads.get( sApp );
						if( oTri.isRunning )
							oTri.cancel( );
						
					}
			}

			// Executing the new apps
				var hDepth : Hash<Int> = new Hash<Int>( );
				var d : Int;
				for( sApp in a ){
					
					//
						oTri = _hTriads.get( sApp );
						oTri.codeName = sApp;
						oTri.frontController = this;
						oTri.setVariables( _hVariables.get( sApp ) );
						if( !oTri.isRunning )
							oTri.execute( );

					//
						d = hDepth.get( oTri.container.name );
						oTri.container.setChildIndex( oTri.view , d++ );

					//
						hDepth.set( oTri.container.name , d );

				}
		}

		

	// -------o misc
	
}
