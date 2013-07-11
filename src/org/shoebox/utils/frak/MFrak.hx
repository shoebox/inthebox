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
package org.shoebox.utils.frak;

	import haxe.Log;
	import haxe.PosInfos;
	import flash.Lib;
	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.mvc.abstracts.AModel;
	import org.shoebox.patterns.mvc.interfaces.IModel;
	import org.shoebox.utils.frak.VFrak;
	import org.shoebox.utils.Perf;

	/**
	* 
	* 
	* @author shoebox
	*/
	class MFrak extends AModel  implements IModel {
		
		@view
		public var view : VFrak;

		private var _aBuffer    : Array<String>;
		private var _hAlias     : Map<String,Alias>;
		private var _hVariables : Map<String,Variable>;		
		
		private static inline var BUFFER_LENGTH  : Int = 150;

		// -------o constructor
		
			/**
			* Constructor of the model class
			*
			* @public
			* @return	void
			*/
			public function new() : Void {
				super( );
			}

		// -------o public
			
			/**
			* Frak model initialisation
			* 
			* @return	Void
			*/
			override public function initialize( ) : Void {

				_aBuffer    = new Array<String>( );
				_hAlias     = new Map<String,Alias>( );
				_hVariables = new Map<String,Variable>( );

				registerAlias( 'setfps' , _setFps 		, 'Change the stage frameRate' , true );
				registerAlias( 'perf' 	, _perf 		, 'Add / Remove the perf monitor' , true );
				registerAlias( 'set' 	, _setVar 		, 'Set variable value - ( ex : set toto 10 )' , true );
				registerAlias( 'vars' 	, _traceVars 	, 'Trace all the registered variables' , true );
				registerAlias( 'help' 	, _help 		, 'Help !' , true );

			}
						
			/**
			* When model is canceled
			* 
			* @public
			* @return	Void
			*/
			override public function cancel( ) : Void {
						
			}

			/**
			* Model startUp 
			* 
			* @public
			* @return	void
			*/
			override public function startUp( ) : Void {
				traceThis( "Frak is waiting for your frakkin' inputs !" , true );
				//#if !flash
				Log.trace = _haxeTrace;
				//#end
			}

			/**
			* Log a message
			*  
			* @public
			* @param 	s : Message to log			( String )
			* @param 	b : Bold or not				( Bool )
			* @return	void
			*/
			public function log( s : String , b : Bool = false ) : Void {
				
				var sTmp : String = '[LOG] - '+ (b ? '<b>'+s+'</b>' : s);
				_aBuffer.push( sTmp );
				if( _aBuffer.length > BUFFER_LENGTH )
					_aBuffer.shift( );

				cast( view , VFrak ).updateBuffer( _aBuffer.join('\n') );
				
			}

			/**
			* Simple trace
			* 
			* @public
			* @param	s : Trace message			( String )
			* @param 	b : Bold or not				( Bool )
			* @return	void
			*/
			public function traceThis( s : String , b : Bool = false ) : Void {
				_trace( b ? '<b>'+s+'</b>' : s );
			}

			/**
			* Register an alias link with the specified Function / Command...
			* 
			* @public
			* @param	sAlias 	: Alias code name 			( String )
			* @param	o 		: Target 					( Dynamic )
			* @param	sHelp	: Help text					( String )
			* @param	sAlias 	: Alias code name 			( String )
			* @param 	bCustom : Custom alias or default 	( Bool )
			* @return	Void
			*/
			public function registerAlias( sAlias : String , o : Dynamic , sHelp : String , b : Bool = false ) : Void {
			
				_hAlias.set( sAlias , { 
											sAlias : sAlias ,
											oTarget : o,
											sHelp : sHelp ,
											bCustom : b
										});

			}

			/**
			* Register an alias
			* 
			* @public
			* @param	sAlias 	: Alias code name 			( String )
			* @param	o 		: Target 					( Dynamic )
			* @return	Void
			*/
			public function unRegisterAlias( sAlias : String , o : Dynamic ) : Bool {
				
				if( !_hAlias.exists( sAlias ) )
					return false;
				
				_hAlias.remove( sAlias );
				
				return true;
			}

			/**
			* Parse the content of the input field and generate the actions
			* 
			* @public	
			* @return	void
			*/
			public function send( ) : Void {
				var s : String = cast( view , VFrak ).tfInput.text;
				
				//
					traceThis( '\n' + s );

				//
					var r = ~/(?<name>[a-zA-Z0-9.]*)/;
						r.match( s );

					var sComm : String = r.matched( 0 );
					if( !_hAlias.exists( sComm ) ){
						traceThis( '\n-Frak : Alias "' + sComm + '" not found.<br>Verify your syntax or if the command is registered.' , true );
						return;
					}
				
				//
					var aArgs : Array<String> = s.split(' ' );
						aArgs.shift( );
				
				//
					var oAlias : Alias = _hAlias.get( sComm );
					if( Reflect.isFunction( oAlias.oTarget ) ){
						Reflect.callMethod( this , oAlias.oTarget , aArgs );
						return;
					}

				//
					if( Std.is( oAlias.oTarget , Class ) ){
						var o : Dynamic = Type.createInstance( oAlias.oTarget , [ ] );
						if( Std.is( o , AbstractCommand ) ){
							var com : AbstractCommand = cast( o , AbstractCommand );
								com.execute( );
						}
					}
					
			}

			/**
			* Register a variable to be watch by Frak
			* 
			* @public
			* @param 	sVarName 	: Variable Name 	( String )
			* @param 	target 		: Target object 	( Dynamic )
			* @param 	prop 		: Target prop name 	( String )
			* @return	Void
			*/
			public function registerVariable( sVarName : String , target : Dynamic , prop : String) : Bool {
				
				if( _hVariables.exists( sVarName ) )
					return false;
				
				_hVariables.set( sVarName , { sVarName : sVarName , target : target , prop : prop } );
				return true;
			}

			/**
			* Unregister a variable watched by Frak
			* 
			* @public
			* @param 	sVarName 	: Variable Name 	( String )
			* @return	Void
			*/
			public function unRegisterVariable( sVarName : String ) : Bool {

				if( !_hVariables.exists( sVarName ) )
					return false;

				_hVariables.remove( sVarName );
				return true;
			}
			
		// -------o protected
			
			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _trace( s : String ) : Void{
				
				_aBuffer.push( s );

				if( _aBuffer.length > BUFFER_LENGTH ){
					_aBuffer.shift( );
					view.updateBuffer( _aBuffer.join('\n') , false );	
				}else 
					view.updateBuffer( s , true );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _haxeTrace( v : Dynamic, ?infos : PosInfos ) : Void{
				var s : String = '';
				if( infos != null )
					traceThis( infos.fileName+' / '+infos.methodName+' at ( '+infos.lineNumber+' ) : '+Std.string( v ) );
				else
					traceThis( Std.string( v ) , true );
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _setFps( i : Int ) : Void{
				traceThis('-Frak set fps to '+i,true);
				Lib.current.stage.frameRate = i;
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _help( ) : Void{

				traceThis('-Frak -commands reference',true);
				for ( a in _hAlias ){
					traceThis( '\t'+a.sAlias+' \t\t = '+a.sHelp );
				}

			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _perf( ) : Void{
				
				if( cast( view , VFrak ).addRemovePerf( ) )
					traceThis('-Frak : Perf module is not active' , true );
				else
					traceThis('-Frak : Perf module is not inactive' , true );


			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _setVar( sVarName : String , value : Dynamic ) : Bool{

				if( !_hVariables.exists( sVarName ) ){
					traceThis( '\n-Frak : Variable "' + sVarName + '" is not registered.' , true );
					return false;
				}
				
				var v : Variable = _hVariables.get( sVarName );	
				Reflect.setField( v.target , v.prop , value );
				return true;
			}

			/**
			* 
			* 
			* @private
			* @return	void
			*/
			private function _traceVars( ) : Void{

				for( v in _hVariables ){
					traceThis( '\tVariable : <b>'+v.sVarName+'</b> \t = \t '+Reflect.field( v.target , v.prop ) );
				}

			}

		// -------o misc

	}

	typedef Alias={
		
		var bCustom : Bool;
		var oTarget : Dynamic;
		var sAlias  : String;
		var sHelp   : String;

	}

	typedef Variable={
		var target   : Dynamic;
		var sVarName : String;
		var prop     : String;
	}
