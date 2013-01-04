package org.shoebox.patterns.frontController;


import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author shoe[box]
 */

class InjectorMacro{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		private function new() {
			
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@:macro static public function generate( ) {
			haxe.macro.Context.onGenerate(
				function(types){
					
					for( t in types ){
						
						switch( t ){

							case TInst( c , _ ):
								var ref = c.get( );
								var fields = ref.fields.get( );
								for( field in fields ){
									
									var metas = field.meta.get( );
									var b = false;
									for( m in metas ){
										if( m.name == 'inject'){
											b = true;
											break;
										}
									}

									if( !b )
										continue;

									switch( field.type ){

										case TInst( t , params ):
												field.meta.add("variableType", [Context.parse('"' + t.get( ).module + '"', ref.pos)], ref.pos);

										default:

									}

								}

							default:
						}
					}

				}
			);

			return macro Void;
		}			

	// -------o protected
	
		

	// -------o misc
	
}