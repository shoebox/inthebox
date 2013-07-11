package org.shoebox.patterns.mvc.interfaces;

import org.shoebox.patterns.mvc.interfaces.IInit;

	/**
	 * @author shoe[box]
	 */
	interface IController extends IInit{

		function initialize( ):Void;
		function cancel( ):Void;

	}
