package org.shoebox.patterns.mvc.abstracts; 

import nme.events.EventDispatcher;
import org.shoebox.patterns.frontcontroller.FrontController;

/**
 * ...
 * @author shoe[box]
 */

class ABase extends EventDispatcher{

	public var codeName : String;
	public var frontController : FrontController;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			super( );
		}
	
	// -------o public
		
	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getModel( ){
			return frontController.getApp( codeName ).mod;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getView( ){
			return frontController.getApp( codeName ).view;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _getController( ){
			return frontController.getApp( codeName ).controller;
		}

	// -------o misc
	
}