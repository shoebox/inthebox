package org.shoebox.signals;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Type.ClassType;
import haxe.macro.TypeTools;

/**
 * ...
 * @author shoe[box]
 */
class MacroEmit{

	// -------o constructor
		
	// -------o public
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		@macro public static function create( ) : Array<Field> {
			
			//Creations the arguments Array
				var pType = Context.getLocalClass( ).get( ).superClass.params[ 0 ];
				var aTypes = [ ];
				var aArgs : Array<FunctionArg> = [ ];
				var inc = 0;
				switch( pType ) {
					
					case TFun( a , r ):
						for ( t in a ) {
							aArgs.push( 
								{
									name : "arg" + inc++,
									opt : false,
									type : TypeTools.toComplexType( t.t ),
									value : null
								}
							);
						}
	
						
					default:
				}
				
			//the call arguments
				var l = aArgs.length;
				var aNames : Array<Expr> = [ for( a in aArgs ) macro $i{ a.name } ];
				var eExpr = macro {
					
					//Empty canal ?
						if ( aList.length == 0 )
							return;
					
					//Calling all the listeners
						for ( l in aList.iterator( ) ) {
							l.fListener( $a { aNames } );
							emitted( l );
						}

				};	
					eExpr.pos = Context.currentPos( );
			
			//the method definition
				var fFunc : Function = {
					args 	: aArgs,
					expr 	: eExpr,
					params 	: [ ],
					ret		: TPath({ name : "Void" , pack : [], params : [] })
				};
			
			//The new "emit" field				
				var f : Field = {
					name	: "emit" ,
					doc		: null,
					meta	: [],
					access	: [APublic],
					kind	: FFun( fFunc ),
					pos		: Context.currentPos( )
				};
				
			//Pushing the new field
				var aFields = Context.getBuildFields( ); 
					aFields.push( f );			
					
			return aFields;
		}
		
	// -------o protected
	
		

	// -------o misc
	
}