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

import haxe.rtti.Meta;
import org.shoebox.patterns.frontController.InjectorMacro;


/**
 * ...
 * @author shoe[box]
 */

class Injector{

	private var _aDependencies: Array<Dependency<Dynamic>>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			trace('constructor');
			_aDependencies = [ ];
			InjectorMacro.generate( );
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function register_dependency<T>( for_type : Class<T> , ?value : T , ?optional_name : String ) : Void {
			var d = new Dependency<T>( for_type , value , optional_name );
			_aDependencies.push( d );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function inject_dependencies_on<T>( instance : T , ?typ : Class<T> ) : Void {
			
			//Retrieve the class type
				if( typ == null )
					typ = Type.getClass( instance );
					
			//
				var meta : Dynamic;
				var metas = Meta.getFields( typ );
				
				var inject;
				var optional_name : String = null;		
				var dep;		
				var field;
				var sType;
				for( v in Reflect.fields( metas ) ){
					
					meta = Reflect.field( metas , v );
					inject = Reflect.hasField( meta , "inject" );					
					
					if( !inject )
						continue;
	
					optional_name = null;
					if( meta.inject != null )
						optional_name = meta.inject[ 0 ];
					
					sType = Reflect.field( meta , "variableType" )[0];
					dep = get_dependency( Type.resolveClass( sType ) , optional_name );
					if( dep == null ){
						throw new nme.errors.Error( Std.format( 'The dependency of type : $sType with optional_name : $optional_name is not registered'));
						continue;
					}	

					var val = dep.value;
					if( val == null ){
						val = dep.getValue( );
						inject_dependencies_on( val , dep.type );
					}

					Reflect.setField( instance , v , val );
				}
						
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function get_dependency( for_type : Class<Dynamic> , ?optional_name : String ) : Dependency<Dynamic> {
			
			var res = null;
			var dep = null;
			for( d in _aDependencies ){
				
				if( d.type == for_type && d.name == optional_name ){
					dep = d;
					break;
				}
			}
			return dep;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function set_dependency_value<T>( for_type : Class<T> , value : T , ?optional_name : String ) : Void {
			inject_dependencies_on( value , for_type );
			var dep = get_dependency( for_type , optional_name );
				dep.value = value;
		}

	// -------o protected
	
		

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class Dependency<T>{

	public var value : T;
	public var name : String;
	public var type : Class<T>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( for_type : Class<T> , ?value : T , ?optional_name : String ) {
			this.type  = for_type;
			this.value = value;
			this.name  = optional_name;
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getValue( ) : T {

			if( value == null ){
				value = Type.createInstance( type , [ ] );
			}

			return value;
		}

	// -------o protected
		

	// -------o misc
	
}