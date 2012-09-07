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

	import nme.display.Bitmap;
	import nme.display.DisplayObject;
	import nme.display.DisplayObjectContainer;
	import nme.display.Loader;
	import nme.display.MovieClip;
	import nme.events.Event;
	import org.shoebox.core.BoxObject;
	import org.shoebox.core.interfaces.IDispose;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IView;

	/**
	 * ABSTRACT VIEW (MVC PACKAGE)
	* Responsabilities:
	* 
	*	===> The view receive update notification from the model
	* 	
	* 	===> The view can be modified by the controller
	* 	
	* 	===> The view send input events to the controller
	* 	
	* 	===> The view store the model instance and the controller instance
	* 	
	* org.shoebox.patterns.mvc2.controller.AView
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	class AView extends MovieClip, implements IView {
		
		public var container : DisplayObjectContainer;
		
		private var _vDisplayObjects	: Array<DisplayObject>;
		
		
		// -------o constructor
			
			/**
			* 
			* @param
			* @return
			*/
			public function new(){
				super( );
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
				container = null;
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
			* register function
			* @public
			* @param 
			* @return
			*/
			public function registerAsset( d : DisplayObject ) : DisplayObject {
				
				if( _vDisplayObjects == null )
					_vDisplayObjects = new Array<DisplayObject>( );
				
				_vDisplayObjects.push( d );
				return d;
			}
			
			
			/**
			* onCancel function
			* @public
			* @param 
			* @return
			*/
			public function onCancel( ?e : Event = null ) : Void {
				
				if( _vDisplayObjects == null ){
					cancel( );
					return;
				}
				
				for( d in _vDisplayObjects ){
						if( d == null )
							continue;
						
						if( Std.is( d , IDispose ) ){
							cast( d , IDispose ).dispose( );
						}

						if( Std.is( d, Bitmap) ){
							if( ( cast( d, Bitmap) ).bitmapData != null ){
								( cast( d, Bitmap) ).bitmapData.dispose( );
								( cast( d, Bitmap) ).bitmapData = null;
							}
							
						}else if( Std.is( d, Loader) ){
							#if (flash || mobile )
							( cast( d, Loader) ).unload( );
							#end
						}
						
						if( Std.is( d, MovieClip) ){
							( cast( d, MovieClip) ).stop( );
						}
					try{

						if( d.parent != null )
							d.parent.removeChild( d );
							
						BoxObject.purge( d );
						d = null;

					}catch( e : nme.errors.Error ){

					}
				}
				
				_vDisplayObjects = null;
				cancel( );
			
			}
			
		// -------o private
			

		// -------o misc
		
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AView,arguments);
			}
	}
