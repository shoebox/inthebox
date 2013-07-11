package org.shoebox.patterns.frontcontroller.plugins;

import org.shoebox.patterns.frontcontroller.FrontController;

/**
 * ...
 * @author shoe[box]
 */

class AFCPlugin{

	public var fc_instance ( default , set_fc_instance ) : FrontController;

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
		private function set_fc_instance( fc : FrontController ) : FrontController{
			trace("_set_fc_instance ::: "+fc);
			return this.fc_instance = fc;
		}

	// -------o misc

}