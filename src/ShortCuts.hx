package ;

import org.shoebox.patterns.injector.InjectMacro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

/**
 * ...
 * @author shoe[box]
 */

class ShortCuts{

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

		#if macro	

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function inject( ) : Array<Field> {
			return InjectMacro.build( );
		}

		#end

	// -------o protected
	
		

	// -------o misc
	
}