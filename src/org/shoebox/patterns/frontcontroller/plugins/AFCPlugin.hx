package org.shoebox.patterns.frontcontroller.plugins;

import org.shoebox.patterns.frontcontroller.FrontController;

/**
 * ...
 * @author shoe[box]
 */

class AFCPlugin{

	public var fc_instance ( default , _set_fc_instance ) : FrontController;

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
	
	// -------o protected
	
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_fc_instance( fc : FrontController ) : FrontController{
			return this.fc_instance = fc;
		}	

	// -------o misc
	
}