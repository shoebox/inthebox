package org.shoebox.signals.flashevents;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Type.ClassType;
import haxe.macro.TypeTools;
import haxe.macro.ExprTools;

/**
 * ...
 * @author shoe[box]
 */
class MacroSignalEvent{

	// -------o constructor
		
	// -------o public
		
		/**
		*
		*
		* @public
		* @return	void
		*/
		@macro static public function create( t : Expr , c : Expr , e : Expr , sField_name : String ) : Array<Field> {
			
			//
				var tType = TPath( { name : ExprTools.toString( c ) , pack : [], params : [] } );
				var sClass_name : String = switch( tType ) {
					
					case TPath( t ):
						t.name;
						
					default:
						null;
				};
			
				
			//
				var aFields = Context.getBuildFields( );
			
			//
				var aArgs : Array<FunctionArg> = [ 
					{ 
						name 	: "d",
						opt 	: false,
						type	: tType
					},
					{ 	
						name 	: "b",
						opt		: true,
						type 	: TPath( { name : "Bool" , pack : [], params : [] } )
					}
				];
					
			//
				var eExpr = macro {
					return getInstance( ).register( $i { "d" } , $ { e } , $i{ "b" } );
				};
					eExpr.pos = Context.currentPos( );
					
			//
				var func : Function = { 
					args : aArgs, 
					expr : eExpr, 
					params : [] , 
					ret : TPath( { 
						name : "SignalEvent", 
						pack : [], 
						params : [TPType( TPath( { pack : [ ], name : ExprTools.toString( t ) , params : [ ] } ) )]
					} ) 					
				};
			
			//
				var fRes : Field = {
									name	: sField_name ,
									doc		: null,
									meta	: [],
									access	: [AStatic,APublic],
									kind	: FFun( func ),
									pos		: Context.currentPos( )
								};
				
			//
				aFields.push( fRes );
			
			return aFields;
		}
	
	// -------o protected
		
	// -------o misc
	
}