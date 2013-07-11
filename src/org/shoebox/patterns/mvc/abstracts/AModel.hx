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

	import org.shoebox.patterns.mvc.abstracts.AModel;
	import org.shoebox.patterns.mvc.abstracts.AView;
	import org.shoebox.patterns.mvc.abstracts.AController;
	import org.shoebox.patterns.frontcontroller.FrontController;
	import org.shoebox.patterns.mvc.interfaces.IView;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * ABSTRACT MODEL (MVC PACKAGE)
	* Responsabilities:
	*
	*	===> The model store the datas
	*
	* 	===> The model store the view instance
	*
	* 	===> The model update the view
	* org.shoebox.patterns.mvc2.controller.AModel
	* @date:26 janv. 09
	* @author shoe[box]
	*/
	#if reporterror
	@:autoBuild( ShortCuts.errorReport( ) )
	#end
	class AModel {

		//public var model( _getModel , null ) : AModel;
		//public var view( _getView , null ) : AView;
		//public var controller( _getController , null ) : AController;

		// -------o constructor

			/**
			*
			* @param
			* @return
			*/
			public function new( ){

			}

		// -------o public

			/*
			* Do nothing method, call to intialize the controller
			* (After than the view have been added to the stage)
			*
			* @return void/
			*/
			public function initialize( ):Void{

			}

			/**
			*
			* @param
			* @return
			*/
			public function cancel( ):Void{

			}

			/**
			* runApp function
			* @public
			* @param
			* @return
			*/
			public function startUp( ) : Void {

			}

		// -------o private

		// -------o misc
			public static function trc(arguments:Dynamic) : Void {
				//Logger.log(AModel,arguments);
			}

	}

