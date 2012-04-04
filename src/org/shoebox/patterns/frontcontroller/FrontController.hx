/**
*  HomeMade by shoe[box]
*
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are
*  met:
*
* Redistributions of source code must retain the above copyright notice, 
*   this list of conditions and the following disclaimer.
*  
* Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the 
*    documentation and/or other materials provided with the distribution.
*  
* Neither the name of shoe[box] nor the names of its 
* contributors may be used to endorse or promote products derived from 
* this software without specific prior written permission.
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
* IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package org.shoebox.patterns.frontcontroller;

import flash.display.DisplayObjectContainer;
import nme.errors.Error;
import org.shoebox.core.BoxArray;
import org.shoebox.patterns.mvc.abstracts.AModel;
import org.shoebox.patterns.mvc.abstracts.AView;
import org.shoebox.patterns.mvc.abstracts.AController;
import org.shoebox.patterns.mvc.MVCTriad;
import org.shoebox.utils.system.Signal1;

/**
 * ...
 * @author shoe[box]
 */

class FrontController {

	static inline public var CHANGE_STATE : String = 'CHANGE_STATE';

	public var owner ( default , default ) 		: DisplayObjectContainer;
	public var state ( _getState , _setState ) 	: String;

	public var stateChanged : Signal1<String>;

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
			stateChanged = new Signal1( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add<M,V,C>( 
										?cM        : Class<M> , 
										?cV        : Class<V> , 
										?cC        : Class<C> , 
										?container: DisplayObjectContainer = null
									) : String {
			
			if( owner == null )
				throw new Error( );

			var s = haxe.Md5.encode( cM+'-'+cV+'-'+cC );
			var s = cM+'-'+cV+'-'+cC;
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
				sCodeName = haxe.Md5.encode( aCodes.join('-') );

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
			//trace('setState ::: '+s);

			if( !_hStatesDesc.exists( s ) )
				throw new Error('State '+s+' is not registered');

			if( _sState == s )
				return s;

			_drawState( _hStatesDesc.get( s ) );
			//emit( CHANGE_STATE , [ s ] );
			stateChanged.emit( s );
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

			nme.system.System.gc( );
			
			// Executing the new apps
				var hDepth : Hash<Int> = new Hash<Int>( );
				var d : Int;
				for( sApp in a ){
					
					//
						oTri = _hTriads.get( sApp );
						oTri.codeName = sApp;
						oTri.frontController = this;
						if( _hVariables.exists( sApp ) ){
							oTri.setVariables( _hVariables.get( sApp ) );
							_hVariables.remove( sApp );
						}
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
