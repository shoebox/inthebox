package org.shoebox.patterns.mvc;

import flash.display.DisplayObjectContainer;
import nme.display.DisplayObject;
import nme.events.Event;
import org.shoebox.patterns.frontcontroller.FrontController;
import org.shoebox.patterns.mvc.abstracts.AModel;
import org.shoebox.patterns.mvc.abstracts.AView;
import org.shoebox.patterns.mvc.abstracts.AController;
import org.shoebox.patterns.commands.AbstractCommand;
import org.shoebox.patterns.commands.ICommand;

/**
 * ...
 * @author shoe[box]
 */

class MVCTriad<M,V,C> extends AbstractCommand , implements ICommand{

	public var container      : DisplayObjectContainer;
	public var codeName       : String;
	public var mod            : M;
	public var view           : V;
	public var controller     : C;
	public var cModel         : Class<M>;
	public var cView          : Class<V>;
	public var cController    : Class<C>;

	private var _aVariables : Array<Dynamic>;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( 
								?cModel     : Class<M> = null , 
								?cView      : Class<V> = null , 
								?cController: Class<C> = null ,
								?container  : DisplayObjectContainer = null
							) {
			super( );

			cancelable = false;
			
			this.cModel      = cModel;
			this.cView       = cView;
			this.cController = cController;
			this.container   = container;
			
			_aVariables = [ ];
		}
	
	// -------o public
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function setVariables( a : Array<Dynamic> ) : Void {
			_aVariables = a;		
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onExecute( ? e : Event = null ) : Void {
			
			//
				mod = cModel == null ? null : Type.createInstance( cModel , _aVariables == null ? [ ] : _aVariables );

				view = cView == null ? null : Type.createInstance( cView , [ ] );
				
				controller = cController == null ? null : Type.createInstance( cController , [ ] );

				_aVariables = null;

			//
				var oMod = mod != null ? cast( mod , AModel ) : null;
				var oView = view != null ? cast( view , AView ) : null ;
				var oCtrl = controller != null ? cast( controller , AController ) : null;
				if( mod != null ){
					oMod.codeName = codeName;
					oMod.frontController = frontController;
				}

				if( view != null ){
					oView = cast( view , AView );
					oView.initialize( );
				}

				if( controller != null ){
					oCtrl.codeName = codeName;
					oCtrl.frontController = frontController;
					oCtrl.initialize( );
				}

			//
				if( oMod != null )
					oMod.initialize( );

				if( oView != null )
					oView.initialize( );

				if( oCtrl != null )
					oCtrl.initialize( );

			//
				if( oMod != null )
					oMod.startUp( );

				if( oView != null )
					oView.startUp( );

				if( oCtrl != null )
					oCtrl.startUp( );

			container.addChild( cast( view , DisplayObject ) );
			
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function onCancel( ?e : Event = null ) : Void {
			
			
			//
				if( mod != null )
					cast( mod , AModel ).cancel( );
					mod = null;

			// 
				if( view != null ){
					cast( view , AView ).cancel( );
					if( container != null )
						container.removeChild( cast( view , DisplayObject ) );
					view = null;
				}

			//
				if( controller != null )
					cast( controller , AController ).cancel( );
					controller = null;



		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function create<M,V,C>( ?m : Class<M> , ?v : Class<V> , ?c : Class<C> , ?container : DisplayObjectContainer = null ) : MVCTriad<M,V,C> {
			return new MVCTriad<M,V,C>( m , v , c , container );
		}	

	// -------o protected
	
		

	// -------o misc
	
}