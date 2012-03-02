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

	import nme.errors.Error;
	import org.shoebox.core.BoxObject;
	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.mvc.abstracts.AController;
	import org.shoebox.patterns.mvc.abstracts.AModel;
	import org.shoebox.patterns.mvc.abstracts.AView;
	import org.shoebox.patterns.mvc.commands.MVCCommand;
	import org.shoebox.utils.system.Signal;
	import nme.display.DisplayObject;
	import nme.display.DisplayObjectContainer;
	import nme.display.Sprite;
	import nme.errors.Error;
	import nme.events.Event;
	import nme.system.System;
	

	/**
	 * org.shoebox.patterns.frontcontroller.FrontController
	* @author shoebox
	*/
	class FrontController extends Signal {
		
		public var state(_getState, _setState) : String ;
		
		public var owner: DisplayObjectContainer;
		
		private var _aHistory			: Array<Dynamic>;
		private var _aExcludeHistory	: Array<Dynamic>;
		private var _hStates			: Hash<Array<String>>;
		private var _hTriads			: Hash<MVCCommand>;
		private var _hVariables			: Hash<Hash<Dynamic>>;
		private var _hVariables2		: Hash<Array<Dynamic>>;
		private var _sState				: String;

		public static inline var CHANGE_STATE : String = 'CHANGE_STATE';
		
		// -------o constructor
		
			/**
			* FrontController constructor method
			* 
			* @public
			* @param	container : optional container reference	( DisplayObjectContainer ) 
			* @return	void
			*/
			public function new( ?owner : DisplayObjectContainer = null ) {
				super( );
				this.owner 			= owner;
				_aHistory   		= new Array<Dynamic>( );
				_aExcludeHistory 	= new Array<Dynamic>( );
				_hStates 			= new Hash<Array<String>>( );
				_hStates 			= new Hash<Array<String>>( );
				_hVariables			= new Hash<Hash<Dynamic>>( );
				_hVariables2		= new Hash<Array<Dynamic>>( );
				_hTriads   			= new Hash<MVCCommand>( );
			}

		// -------o public
			
			/**
			* Register an MVC triad
			* 
			* @public
			* @param	sName	: Triad code name		( String ) 
			* @param	m 	: Model ref			( Class ) 
			* @param	v 	: View ref				( Class ) 
			* @param	c 	: Controller ref		( Class ) 
			* @return	true if success				( Boolean )
			*/
			public function registerTriad( 
											sName		: String , 
											m 			: Class<AModel> 			= null , 
											v	 		: Class<AView> 				= null , 
											c 			: Class<AController> 		= null ,
											?container	: DisplayObjectContainer 	= null
										) : Bool {
			
				if( _hTriads.exists( sName ) )
					throw new Error('A triad with the code name '+sName+' is already registered');
				
				var com : MVCCommand = new MVCCommand( );
					com.init( m , v , c , container,  this );

				_hTriads.set( sName , com );
				
				return true; 
				
			}
			
			/**
			* Get a triad command by his code name
			* 
			* @public
			* @param	sName	: Triad code name		( String ) 
			* @return	void
			*/
			public function getTriad( sName : String ) : MVCCommand {
				return _hTriads.get( sName ); 
			}
			
			/**
			* Register a state which is a combinaison of triads
			* 
			* @public
			* @param 	sName		: State code name		( String )
			* @param 	codes		: Triad codes list		( Array<String> )
 			* @return	true if success					( Boolean )
			*/
			public function registerState( sName : String , codes : Array<String> = null ) : Bool {
				
				_hStates.set( sName , codes );
				return true;
				
			}
			
			/**
			* getStateContent function
			* @public
			* @param 
			* @return
			*/
			public function getStateContent( s : String ) : Array<String> {
				return _hStates.get( s );
			}
			
			/**
			* UnRegister a state
			* 
			* @public
			* @param 	sName		: State code name		( String )
			* @return	true if success					( Boolean )
			*/
			public function unRegisterState( sName : String ) : Bool {
				
				if( !_hStates.exists( sName ))
					throw new Error( 'The state '+sName+' is not registered' );
				
				_hStates.remove( sName );
				return true;
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			public function setState( sName : String , bHistory : Bool = true ) : Void {
				
				if ( !_hStates.exists( sName ) )
					throw new Error('The state ' + sName + ' is unknow');
					
				if ( _sState == sName )
					throw new Error('The state ' + sName + ' is already the current state');
				
				if ( bHistory ) {
					_queueHistory( _sState );
				}
					
				_drawState( sName );
			}
			
			/**
			* execTriad function
			* @public
			* @param 
			* @return
			*/
			public function execTriad( s : String ) : Void {
				_executeTriad( s , 0 );
			}
			
			/**
			* setAppVariable function
			* @public
			* @param 
			* @return
			*/
			public function setAppVariable( appCode : String , sVarName : String , oVarVal : Dynamic ) : Void {
				
				var o : Hash<Dynamic> = null;
				
				if( _hVariables.exists( appCode ) )
					o = _hVariables.get( appCode );
				else
					o = new Hash( );
					o.set( sVarName , oVarVal );
					
				_hVariables.set( appCode , o );
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function setAppVariables( appCode : String  , vars : Array<Dynamic> ) : Void {
				_hVariables2.set( appCode , vars );	
			}
			
			/**
			* exec function
			* @public
			* @param 
			* @return
			*/
			public function exec( c : AbstractCommand , ?b : Bool = true ) : Void {
				
				c.frontController = this;
				if( b )
					_aHistory.push( c );
				c.execute( );
				
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function goBack( ) : Void {
				
				if ( _aHistory.length > 0 ) {
					
					var prev : Dynamic = _aHistory.pop( );
					if ( Std.is( prev , AbstractCommand ) ) {
						
						var cPrev : AbstractCommand = cast( prev , AbstractCommand );
						if ( cPrev.isRunning )
							cPrev.cancel( );
						else
							cPrev.execute( );
							
					}else if ( Std.is( prev , String ) ) {
						
						var sPrev : String = cast( prev , String );
						if ( _sState != sPrev ) 
							setState( sPrev , false );
						
					}
				}
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function getHistory( ) : Array<Dynamic> {
				return _aHistory;
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function clearHistory( ) : Void {
				_aHistory = new Array<Dynamic>( );
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function clearPrevious( ) : Dynamic {
				
				if ( _aHistory.length == 0 )
					return null;
				
				return _aHistory.pop( );
			}
			
			/**
			* 
			* 
			* @public
			* @return	void
			*/
			public function excludeFromHistory( o : Dynamic ) : Void {
				
				if ( _aExcludeHistory!= null )
					_aExcludeHistory = new Array<Dynamic>( );
					_aExcludeHistory.push( o );
			}

		// -------o protected
			
			private function _queueHistory( s : String = null ) : Void {
				
				if ( s == null )
					return;
				
				//trace('queueHistory ::: '+s);
				if ( !_aExcludeHistory.copy().remove( s )) {
					//trace('queue ::: ' + s);
					_aHistory.push( s );
					if ( _aHistory.length > 15 )
						_aHistory.shift( );
				}
				
				//trace('queuehistory ::: ' + s + ' - ' + _aHistory);
			}
		
			private function _getState( ) : String {
				return _sState;
			}
			
			private function _setState( s : String ) : String {
				_queueHistory( _sState );
				_drawState( s );
				return _sState;
			}
			
			private function _drawState( s : String ) : Void {
				
				if ( _sState == s )
					return;
				//
					if ( !_aExcludeHistory.copy( ).remove( s ) ) {
						
						if ( _aHistory.length > 15 )
							_aHistory.shift( );
						
					}
					
				//
					var aCodes : Array<String> = _hStates.get( s );
				
				//
					if ( _sState != null ) {
						
						var aPrev : Array<String> = _hStates.get( _sState );
						
						for ( s in aPrev ) {
							
							if ( !aCodes.copy( ).remove( s ) ) {
								_cancelTriad( s );
							}
						}
					}
					
				// Execute triads
					if( aCodes != null ){
						var d : Int = 0;
						for ( s in aCodes ) {
							if( _executeTriad( s , d ) )
								d++;
						}
					}
				
				_sState = s;
				emit( CHANGE_STATE , [ _sState ] );
			}
			
			private function _executeTriad( sCodeName : String , d : Int = -1 ) : Bool {
			
				//
					if( !_hTriads.exists( sCodeName ) )
						throw new Error('The triad '+sCodeName+' is not registered');
				
				//
					var oTriad : MVCCommand = _hTriads.get( sCodeName );
						oTriad.frontController = this;
					if ( oTriad.isRunning )
						return oTriad.defaultContainer;
						
				//
					var mc : DisplayObjectContainer = oTriad.container;
					if ( mc == null ) {
						mc = new Sprite( );
						mc.name = sCodeName;
						oTriad.container = mc;
						oTriad.defaultContainer = true;
					}
					
				//
					if ( !owner.contains( mc ) )
						owner.addChild( mc );

					if( d != -1 && owner.numChildren > 0 )
						owner.setChildIndex( mc , d );
						
				//
					//if( _hVariables.exists( sCodeName )) 
					//	oTriad.setVars( _hVariables.get( sCodeName ) );
						
					oTriad.prepare( _hVariables2.get( sCodeName ) );
					oTriad.view.name = sCodeName;
			
				//
					
					if ( oTriad.model != null && _hVariables.exists( sCodeName ) ) {
						var o : Hash<Dynamic> = _hVariables.get( sCodeName );
						for( prop in o.keys( ) ){
							Reflect.setField( oTriad.model , prop , o.get( prop ) );
						}
						
						_hVariables.remove( sCodeName );
					}
					
					oTriad.execute( );
					//_dChannels.remove( sCodeName );
				
				//
					_hTriads.set( sCodeName , oTriad );
					return oTriad.defaultContainer;
			}
			
			private function _cancelTriad( sCodeName : String ) : Void {
				
				//
					var oTriad : MVCCommand = _hTriads.get( sCodeName );
						if( oTriad.isRunning )
							oTriad.cancel( );
					
				//
					if( owner.getChildByName( sCodeName )!= null)
						owner.removeChild( owner.getChildByName( sCodeName ) );
						
				//
					//_hTriads.remove( sCodeName );
			}
		
		// -------o misc

			public static function trc(args:Array<Dynamic>) : Void {
				
			}
			
	}
	