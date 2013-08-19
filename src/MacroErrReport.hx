package ;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author shoe[box]
 */

class MacroErrReport{

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
		#if macro

		/**
		*
		*
		* @public
		* @return	void
		*/
		static public function build( ) : Array<Field> {
			var a = Context.getBuildFields( );
			var sModule = Context.makeExpr( Context.getLocalClass( ).get( ).module , Context.currentPos( ) );
			var eName : Expr;
			//
				for( f in a ){

					switch( f.kind ){

						case FFun( func ):

							//
								//sFunc = Context.makeExpr( f.name , Context.currentPos( ) );
								var eRet : Expr = null;
								if( func.ret != null ){

									switch( func.ret ){

										case TPath( t ):
											switch( t.name ){

												case "Void":

												case "Float":
													eRet = macro return -1;

												case "Int":
													eRet = macro return -1;

												case "Bool":
													eRet = macro return false;

												default:
													eRet = macro return null;

											}

										default:
											eRet = null;
									}
								}

							//
							var 	expr : Expr = func.expr;
								expr = macro {
									trace("call ::: "+$sModule);
									try{
										$expr;
									}catch( e : nme.errors.ArgumentError ){
										trace("ArgumentError");
										fr.hyperfiction.HypSystem.reportError( $sModule , e.toString( ), haxe.Stack.toString( haxe.Stack.exceptionStack( ) )+"\n"+haxe.Stack.toString( haxe.Stack.callStack( ) ) );
									}catch( e : nme.errors.TypeError ){
										trace("TypeError");
										fr.hyperfiction.HypSystem.reportError( $sModule , e.toString( ), haxe.Stack.toString( haxe.Stack.exceptionStack( ) )+"\n"+haxe.Stack.toString( haxe.Stack.callStack( ) ) );
									}catch( e : nme.errors.Error ){
										trace("Error");
										fr.hyperfiction.HypSystem.reportError( $sModule , e.toString( ), haxe.Stack.toString( haxe.Stack.exceptionStack( ) )+"\n"+haxe.Stack.toString( haxe.Stack.callStack( ) ) );
									}catch( unknown : Dynamic ) {
										fr.hyperfiction.HypSystem.reportError(
											$sModule ,
											"Unknown exception : "+Std.string(unknown) ,
											haxe.Stack.toString( haxe.Stack.exceptionStack( ) )+"\n"+haxe.Stack.toString( haxe.Stack.callStack( ) )
										);
										trace("Unknow error ::: "+$sModule);
										trace( unknown );
										trace( haxe.Stack.exceptionStack( ) );
										trace( haxe.Stack.toString( haxe.Stack.callStack( ) ) );
										fr.hyperfiction.HypSystem.reportError( $sModule , "Unknown exception : "+Std.string(unknown) , haxe.Stack.toString( haxe.Stack.exceptionStack( ) )+"\n"+haxe.Stack.toString( haxe.Stack.callStack( ) ) );
									}

								};

								if( eRet != null ){
									expr = macro {
										$expr;
										$eRet;
									}
								}

							func.expr = expr;
							/*
							var e = macro {
								try{
									$(expr);
								}catch( e : nme.errors.Error ){
									trace("errror ::: "+e);
								}
							};
							*/
						default:

					}
				}

			return a;
		}
		#end


	// -------o protected



	// -------o misc

}