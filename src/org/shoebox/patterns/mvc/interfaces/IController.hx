package org.shoebox.patterns.mvc.interfaces; 
	
	/**
	 * @author shoe[box]
	 */
	interface IController implements IInit{
		
		function initialize( ):Void;
		function cancel( ):Void;
		
	}
