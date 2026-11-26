var oDataTable;

function vmLogServerData( source )
{
    var minimum = {if isset($options.defaults.server_side.pagination.log.min_search_str)}{$options.defaults.server_side.pagination.log.min_search_str}{elseif isset($options.defaults.server_side.pagination.min_search_str)}{$options.defaults.server_side.pagination.min_search_str}{else}3{/if};
    return vmDataTableServerData( source, minimum );
}


vmReady(function()
{
    {if !isset($options.defaults.server_side.pagination.log.enable) || $options.defaults.server_side.pagination.log.enable }
    /* Server-side processing: the (unbounded) log table is paged/sorted/searched
       through /log/list-data, fetching only the visible page. Cells are escaped
       (DataTables inserts cell data as raw HTML; Smarty escaped the inline rows). */
    oDataTable = new DataTable('#list_table', {
        'processing': true,
        'serverSide': true,
        'serverMethod': 'GET',
        'ajax': vmLogServerData( "{genUrl controller='log' action='list-data'}" ),
        'pageLength': vmDataTablePageLength( {if isset( $options.defaults.table.entries )}{$options.defaults.table.entries}{else}10{/if} ),
        'order': [[ {if !isset( $domain ) || !$domain}4{else}3{/if}, 'desc' ]],
        'language': { 'processing': 'Loading…', 'emptyTable': 'No log entries.', 'search': 'Search (prefix * to match anywhere):' },
        'drawCallback': vmDataTableRememberPageLength,
        'autoWidth': false,
        'columns': [
            { 'data': 'action',    'width': '125px', 'render': DataTable.render.text() },
            { 'data': 'data',      'orderable': false, 'render': DataTable.render.text() },
            { 'data': 'admin',     'width': '190px', 'render': DataTable.render.text() },
            {if !isset( $domain ) || !$domain}
            { 'data': 'domain',    'width': '155px', 'render': DataTable.render.text() },
            {/if}
            { 'data': 'timestamp', 'width': '175px', 'render': DataTable.render.text() }
        ]
    });
    {else}
    oDataTable = new DataTable('#list_table', {
        'drawCallback': vmDataTableRememberPageLength,
        'pageLength': vmDataTablePageLength( {if isset( $options.defaults.table.entries )}{$options.defaults.table.entries}{else}10{/if} ),
        'order': [[4, 'desc']]
    });
    {/if}
}); // document onready
