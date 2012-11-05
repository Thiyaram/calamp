$(document).ready ->
  deviceTable = $("#devices-datatable").dataTable
  	sPaginationType: "bootstrap_alt"
  	oLanguage:
  		sLengthMenu: "_MENU_ devices per page"
  		sZeroRecords: "No devices found"
  		sInfo: "Showing _START_ to _END_ of _TOTAL_ devices"
  		sInfoFiltered: "(filtered from _MAX_ total  devices)"
  		sInfoEmpty: ""
  deviceTable.fnSort [[1, "asc"]]

