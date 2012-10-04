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
import nme.display.DisplayObjectContainer;
import org.shoebox.core.BoxArray;
import org.shoebox.core.BoxObject;
import org.shoebox.core.interfaces.IDispose;
import org.shoebox.patterns.frontcontroller.Injector;
import org.shoebox.patterns.mvc.abstracts.AController;
import org.shoebox.patterns.mvc.abstracts.AModel;
import org.shoebox.patterns.mvc.abstracts.AView;
import org.shoebox.patterns.mvc.interfaces.IController;
import org.shoebox.patterns.mvc.interfaces.IInit;
import org.shoebox.patterns.mvc.interfaces.IModel;
import org.shoebox.patterns.mvc.interfaces.IView;

/**
 * ...
 * @author shoe[box]
 */

class FrontController{

	public var owner ( default , default ) : DisplayObjectContainer;
	public var state ( default , _setState) : String;

	private var _aCurrent: Array<String>;
	private var _hStates : Hash<Array<String>>;
	private var _hTriads : Hash<MVCTriad>;
	private var _injector: Injector;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			_aCurrent      = [ ];
			_injector = new Injector( );
			_hStates       = new Hash<Array<String>>( );
			_hTriads       = new Hash<MVCTriad>( );
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add( 
								cMod        : Class<IModel>,
								cView       : Class<IView>,
								cController : Class<IController>
							) : String {
			
			if( owner == null )
				throw new nme.errors.Error('DisplayObjectContainer is not defined');

			var s = cMod + '|' + cView + ' - '+cController;

			var t = new MVCTriad( );
				t.classModel      = cMod;
				t.classView       = cView;
				t.classController = cController;
				t.container = owner;
			_hTriads.set( s , t );

			return s;
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

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function registerState( aCodes : Array<String> ) : String {
			
			var sCode = aCodes.join('|');
			_hStates.set( sCode , aCodes );
			return sCode;

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function register_dependency<T>( for_type : Class<T> , ?value : T , ?optional_name : String ) : Void {
			_injector.register_dependency( for_type , value , optional_name );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function inject_dependencies_on<T>( instance : T , ?typ : Class<T> ) : Void {
			_injector.inject_dependencies_on( instance , typ );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function set_dependency_value<T>( for_type : Class<T> , value : T , ?optional_name : String ) : Void {
			_injector.set_dependency_value( for_type , value , optional_name );					
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setAppVariables( target_app_name : String , variables : Array<Dynamic> ) : Void {			
			getApp( target_app_name ).variables = variables;
		}

	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _setState( s : String ) : String{

			if( this.state == s || !_hStates.exists( s ) )
				return s;

			_drawState( _hStates.get( s ) );
			return this.state = s;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _drawState( a : Array<String> ) : Void{
			
			if( _aCurrent != null )
				_cancelPrevious( a );
			
			var tri : MVCTriad;
			var d = 0;
			for( s in a ){
				tri = _getTriad( s );
				tri.create( this );
				if( owner != null )
					owner.setChildIndex( cast( tri.instance.view , DisplayObjectContainer ) , d++ );
			}

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _cancelPrevious( a : Array<String> ) : Void{
			
			var tri : MVCTriad;
			for( s in _aCurrent ){

				if( Lambda.has( a , s ) )
					continue;

				tri = _getTriad( s );
				tri.cancel( );
				
			}

			_aCurrent = a;
			#if cpp
			cpp.vm.Gc.run( true );
			#else
			nme.system.System.gc( );
			#end

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getTriad( s : String ) : MVCTriad{
			return _hTriads.get( s );
		}

	// -------o misc
	
}

import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;

/**
 * ...
 * @author shoe[box]
 */

class MVCTriad{

	public var classController: Class<IController>;
	public var classModel     : Class<IModel>;
	public var classView      : Class<IView>;
	public var container      : DisplayObjectContainer;
	public var frontController: FrontController;
	public var instance       : MVCTriadInstance;
	public var variables      : Array<Dynamic>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function add_runtime_variable( value : Dynamic ) : Void {
			if( variables == null )
				variables.push( value );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function create( fc : FrontController ) : Void {
		
			//
				if( instance != null )
					return;

			//
				instance        = new MVCTriadInstance( );
				frontController = fc;

			//
				if( classModel != null ){
					instance.model = Type.createInstance( classModel , variables == null ? [ ] : variables );
					fc.inject_dependencies_on( instance.model , classModel );
				}

				if ( classView != null ){
					instance.view = Type.createInstance( classView , [ ] );
					fc.inject_dependencies_on( instance.view , classView );
				}
				
				if ( classController != null ){
					instance.controller = Type.createInstance( classController , [ ] );
					fc.inject_dependencies_on( instance.controller , classController );
				}

				variables = null;

			//
				_inject_triad_class_metas_on( fc , classModel , instance.model );
				_inject_triad_class_metas_on( fc , classController , instance.controller );

			//
				_initialize_instance( instance.model );
				_initialize_instance( instance.view );
				_initialize_instance( instance.controller );

			//
				if( instance.model != null )
					cast( instance.model , AModel ).startUp( );

				if( instance.view != null )
					cast( instance.view , AView).startUp( );

				if( instance.controller != null )
					cast( instance.controller , AController ).startUp( );
			
			//
				if( instance.view != null )
					container.addChild( cast( instance.view , AView ) );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function cancel( ) : Void {
			instance.dispose( );
			instance = null;
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _initialize_instance( val : IInit = null ) : Void{
			if( val != null )
				val.initialize( );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _inject_triad_class_metas_on( fc : FrontController , c : Class<Dynamic> , onwhat : Dynamic ) : Void{
			
			if( c == null || onwhat == null )
				return;

			var meta = Meta.getFields( c );
			var m;
			var metaname;
			var varname;
			for( v in Reflect.fields( meta ) ){
				m = Reflect.field( meta , v );
				metaname = Reflect.fields( m )[ 0 ];
				varname = Std.string( v );
				
				switch( metaname ){

					case 'model':
						Reflect.setField( onwhat , varname , instance.model );
						
					case 'view':
						Reflect.setField( onwhat , varname , instance.view );

					case 'controller':
						Reflect.setField( onwhat , varname , instance.controller );
						
					case 'frontcontroller':
						Reflect.setField( onwhat , varname , fc );
				}
				
			}


			//
				var csuper = Type.getSuperClass( c );				
				if( csuper != null )
					_inject_triad_class_metas_on( fc , csuper , onwhat );
			
		}

	// -------o misc
	
}

/**
 * ...
 * @author shoe[box]
 */

class MVCTriadInstance implements IDispose{

	public var model     : IModel;
	public var view      : IView;
	public var controller: IController;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {

			if( model != null )
				model.cancel( );


			if( controller != null )
				controller.cancel( );
				

			if( view != null ){
				view.cancel( );
				var v = cast( view , AView );
					v.onCancel( );

				if( v != null && v.parent !=null )
					v.parent.removeChild( v );

				//
					while( v.numChildren > 0 ){
						v.removeChildAt( 0 );
					}
			}

			haxe.Timer.delay( function( ){
											_purge( model );
											_purge( view );
											_purge( controller );

											model = null;
											view = null;
											controller = null;
											},100);
		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _purge( o : Dynamic = null ) : Void{
			BoxObject.purge( o );
		}

	// -------o misc
	
}

