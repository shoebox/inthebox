package org.shoebox.patterns.injector;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * ...
 * @author shoe[box]
 */

class InjectMacro{

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
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public function build( ) : Array<Field> {
			
			var a = haxe.macro.Context.getBuildFields( );
			var b = false;
			var meta;

			var aNew : Array<Field> = [ ];
			var aRem : Array<Field> = [ ];

			for( f in a ){
				
				//Meta ?
					b = false;
					for( m in f.meta ){
						if( m.name == "inject" ){
							meta = m;
							b = true;
							break;
						}
					}

				//Pas de meta
					if( !b )
						continue;
					
					// Sys.println("[Inject] Variable : "+_getFull_class_name( haxe.macro.Context.getLocalClass( ).get( ) )+"\t\t"+f.name);

				//MetaDatas Expr
					var bRW : Bool = false;
					var sOptionalName : String = null;
					
					for( p in meta.params ){
						
						switch( p.expr ){

							case EConst( const ):
								switch( const ){

									case CString( s ):
										sOptionalName = s;

									case CIdent( b ):
										bRW = b == "true";

									default:

								}

							default:

						}

					}
	
				//New Methods names
					var sGet : String = "_injector_get_"+f.name;
					var sSet : String = "_injector_set_"+f.name;

				//Response type
					var oType : ComplexType = _getComplexType( f.kind );
					var sKind : String = _getType( f.kind )+"";
					var rKind = macro $(sKind);



					var sModule : String = switch( sKind ){

												case "Int":
													sKind;

												case "String":
													sKind;

												default:
													switch( Context.getType( sKind ) ){

													case TInst( t , p ) : 
															switch( t ){

																default:
																	t.get( ).module;
															}
															
														default : 
															null;
													}
										}

					//var test : Expr = { expr:EConst(CIdent(sKind)), pos:Context.currentPos( ) };
				
				//The new Getter func
					var funcGet : Function = { args : [] , expr : null , params : [] , ret : oType };
						funcGet.expr = macro { 
												return org.shoebox.patterns.injector.Injector.getInstance( ).get( 
																															Type.resolveClass( $(sModule) ),
																															$(sOptionalName) 
																														); 
											};

					var fGet : Field = { 
											name : sGet ,  
											doc : null, 
											meta : [], 
											access : [APublic], 
											kind : FFun( funcGet ),
											pos : haxe.macro.Context.currentPos() 
										};
					aNew.push( fGet );
					
				//The new Setter func
					if( bRW ){
						
						var arg : FunctionArg = { name : "arg", type : oType , opt : false, value : null };
						var rArg = rv("arg");
						
						var funcSet : Function = { args : [ arg ] , expr : null , params : [] , ret : oType };
							funcSet.expr = macro { 
													return org.shoebox.patterns.injector.Injector.getInstance( ).set( 
																																$rArg ,
																																Type.resolveClass( $(sModule) ),
																																$(sOptionalName) 
																															); 	
												};

						var fSets : Field = { 
												name : sSet ,  
												doc : null, 
												meta : [], 
												access : [APublic], 
												kind : FFun( funcSet ),
												pos : haxe.macro.Context.currentPos() 
											};
						aNew.push( fSets );
						
						
					}else
						sSet = "never";


				//		
					if( sKind == null )
						continue;
					aRem.push( f );
					aNew.push( _inject_field( f , sKind+"" , sGet+"" , sSet+"" ));
				
			}
			for( f in aNew )
				a.push( f );

			for( f in aRem )
				a.remove( f );

			return a;

		}

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _getComplexType( t : FieldType ) : ComplexType{

			return switch( t ){

				case FVar( t , e ):
					t;

				default:
					null;

			}

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _getType( t : FieldType ) : String{
			
			var s = switch( t ){

				case FFun( f ):

				case FProp( get , set , t , e ):

				case FVar( t , e ):
					switch( t ){

						case TPath( p ):
							p.name;

						default:

					}

			}
			return s;			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _inject_field( f : Field , sKind : String , sFieldGet : String , sFieldSet : String = "never" ) : Field{

			var eName = rv( f.name );

			var type : FieldType = FProp( sFieldGet , sFieldSet , TPath({ name : sKind, pack : [], params : [], sub : null }) );

			var newField : Field = { 	name : f.name ,  
										doc : null, 
										meta : [], 
										access : [APublic], 
										kind : type, 
										pos : haxe.macro.Context.currentPos() 
									};
									

			return newField;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static function rv(variable_name:String) : Expr{
			 return { expr: EConst(CIdent(variable_name)), pos: Context.currentPos() };
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		static private function _getFull_class_name( ofClass : ClassType ) : String{
			return ofClass.pack.join(".")+((ofClass.pack.length == 0) ? "" : ".")+ofClass.module;
		}

	// -------o misc
	
}