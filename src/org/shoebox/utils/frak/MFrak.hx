/**
  HomeMade by shoe[box]
 
  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of shoe[box] nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.shoebox.utils.frak;

	import haxe.Log;
	import haxe.PosInfos;
	import org.shoebox.patterns.mvc.abstracts.AModel;
	import org.shoebox.patterns.mvc.interfaces.IModel;

	/**
	* 
	* 
	* @author shoebox
	*/
	class MFrak extends AModel , implements IModel {
		
		private var _aBuffer 			: Array<String>;
		
		private static inline var BUFFER_LENGTH  : Int = 50;

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
			* Model initialization 
			* 
			* @public
			* @return	Void
			*/
			override public function initialize( ) : Void {
				_aBuffer = new Array<String>( );
			}
						
			/**
			* When the model and the triad is canceled
			* 
			* @public
			* @return	void
			*/
			override public function cancel( ) : Void {
						
			}

			/**
			* 
			* 
			* @public
			* @return	void
			*/
			override public function startUp( ) : Void {
				//cast( view , VFrak ).
				traceThis( "Frak is waiting for your frakkin' inputs !" , true );
				Log.trace = _haxeTrace;
			}

			/**
			* 
			* 
			* @public
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
			* 
			* 
			* @public
			* @return	void
			*/
			public function traceThis( s : String , b : Bool = false ) : Void {
				_trace( b ? '<b>'+s+'</b>' : s );
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
				if( _aBuffer.length > BUFFER_LENGTH )
					_aBuffer.shift( );

				cast( view , VFrak ).updateBuffer( _aBuffer.join('\n') );	
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

		// -------o misc

	}