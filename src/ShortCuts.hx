package ;

import org.shoebox.patterns.injector.InjectMacro;
import org.shoebox.utils.NativeMirror;

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

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function mirrors( ) : Array<Field> {
			return NativeMirror.build( );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function errorReport( ) : Array<Field> {
			return MacroErrReport.build( );
		}

		#end

	// -------o protected



	// -------o misc

}