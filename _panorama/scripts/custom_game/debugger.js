function test( table_name, key, data )
{
	$.Msg( "here"); 
}

function btnClick()
{
	$.Msg("clicked"); 
}

(function()
{
	CustomNetTables.SubscribeNetTableListener( "game", test );
})();

