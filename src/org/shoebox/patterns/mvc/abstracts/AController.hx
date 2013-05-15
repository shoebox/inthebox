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
package org.shoebox.patterns.mvc.abstracts;

	import haxe.Timer;
	import nme.errors.Error;
	import org.shoebox.core.BoxObject;
	import org.shoebox.core.interfaces.IDispose;
	import org.shoebox.utils.system.Signal;
	import org.shoebox.patterns.commands.AbstractCommand;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IController;
	import nme.display.DisplayObject;
	import nme.events.Event;
	import nme.events.EventDispatcher;

	/**
	* ABSTRACT CONTROLLER (MVC PACKAGE)
	* Responsabilities:
	*
	*	===> The controller store the model instance and the view instance
	*
	* 	===> The controller update the view / model
	*
	* org.shoebox.patterns.mvc.controller.AController
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	class AController implements IController {

		private var _a_listeners	: Array<Listener>;
		private var _a_timers		: Array<Timer>;

		// -------o constructor

			/**
			*
			* @param
			* @return
			*/
			public function new(){
				_a_listeners = [ ];
			}

		// -------o public

			/**
			*
			* @param
			* @return
			*/
			public function initialize():Void{
			}

			/**
			*
			* @param
			* @return
			*/
			public function cancel( ):Void{
				if( _a_listeners != null )
					for( l in _a_listeners )
						l.dispose( );

				if( _a_timers != null )
					for( t in _a_timers )
						if( t != null )
							t.stop( );

				_a_listeners = null;
				_a_timers = null;
				//org.shoebox.core.BoxObject.purge( this );
			}

			/**
			* runApp function
			* @public
			* @param
			* @return
			*/
			public function startUp() : Void {

			}

			/**
			*
			*
			* @public
			* @return	void
			*/
			public function delay( func : Void->Void , delay : Int ) : Timer {
				if( _a_timers == null )
					_a_timers = [ ];

				var t = Timer.delay( func , delay );
					_a_timers.push( t );
				return t;
			}

			/**
			*
			*
			* @public
			* @return	void
			*/
			public function addListener(
											target				: EventDispatcher,
											type				: String,
											listener			: Dynamic -> Void ,
											b_use_capture		: Bool = false,
											iPrio				: Int = 0,
											useWeakReference	: Bool = false
										) : Void {

				#if debug

					if( target == null )
						throw new nme.errors.Error('error : target is null');

					if( _has_listener( target , type , listener , b_use_capture , iPrio , useWeakReference ) != null )
						throw new nme.errors.Error('Listener already exist');
				#end

				var l = new Listener( target , type , listener , b_use_capture , iPrio , useWeakReference );
				_a_listeners.push( l );
			}

			/**
			*
			*
			* @public
			* @return	void
			*/
			public function remove_listener(
											target				: EventDispatcher,
											type				: String,
											listener			: Dynamic -> Void ,
											b_use_capture		: Bool = false,
											iPrio				: Int = 0,
											useWeakReference	: Bool = false
										) : Void {

				#if debug
					if( _has_listener( target , type , listener , b_use_capture , iPrio , useWeakReference ) == null )
						throw new nme.errors.Error('Listener does not exist');
				#end

				var l = _has_listener( target , type , listener , b_use_capture , iPrio , useWeakReference );
					l.dispose( );
				_a_listeners.remove( l );
			}

		// -------o private

			/**
			*
			*
			* @private
			* @return	void
			*/
			private function _has_listener(
												target				: EventDispatcher,
												type				: String,
												listener			: Dynamic -> Void ,
												b_use_capture		: Bool = false,
												iPrio				: Int = 0,
												useWeakReference	: Bool = false
											) : Listener {

				var res : Listener = null;
				for( l in _a_listeners ){
					if(
						l.target			== target &&
						l.type				== type &&
						l.listener			== listener &&
						l.b_use_capture		== b_use_capture &&
						l.iPrio				== iPrio &&
						l.useWeakReference	== useWeakReference
						){
						res = l;
						break;
					}
				}

				return res;
			}

		// -------o misc
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AController,arguments);
			}
	}


/*
* ...
* @author shoe[box]
*/

class Listener implements IDispose{

	public var b_use_capture	: Bool;
	public var iPrio			: Int;
	public var listener			: Dynamic -> Void ;
	public var target			: EventDispatcher;
	public var type				: String;
	public var useWeakReference	: Bool;

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new(
								target				: EventDispatcher,
								type				: String,
								listener			: Dynamic -> Void ,
								b_use_capture		: Bool = false,
								iPrio				: Int = 0,
								useWeakReference	: Bool = false
								) {

			this.target				= target;
			this.type				= type;
			this.listener			= listener;
			this.b_use_capture		= b_use_capture;
			this.iPrio				= iPrio;
			this.useWeakReference	= useWeakReference;
			init( );
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function init( ) : Void {
			target.addEventListener( type , listener , b_use_capture , iPrio , useWeakReference );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function dispose( ) : Void {
			target.removeEventListener( type , listener , b_use_capture );
			this.target				= null;
			this.type				= null;
			this.listener			= null;
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function toString( ) : String {
			return Std.format( 'Listener ::: target : $target | type : $type | listener : $listener' );
		}

	// -------o protected



	// -------o misc

}