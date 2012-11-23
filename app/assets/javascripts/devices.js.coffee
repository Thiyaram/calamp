$(document).ready ->
  deviceTable = $("#devices-datatable").dataTable
  	sPaginationType: "bootstrap_alt"
  	oLanguage:
  		sLengthMenu: "_MENU_ devices per page"
  		sZeroRecords: "No devices found"
  		sInfo: "Showing _START_ to _END_ of _TOTAL_ devices"
  		sInfoFiltered: "(filtered from _MAX_ total  devices)"
  		sInfoEmpty: ""
  deviceTable.fnSort [[3, "desc"],[1, "asc"]]
$("#create_device").click ->
  imei = undefined
  registered_date = undefined
  imei = $("#device_imei").val()
  registered_date = $("#device_registered_date").val()
  if imei is ""
    $("#flash_error").html "Enter all mandatory fields to continue..."
    $("#errmsg").addClass "alert alert-error"
    $("#flash_error").append "<a class='close' data-dismiss='alert'>&#215;</a>"
    false
  else if registered_date is ""
    $("#flash_error").html "Enter all mandatory fields to continue..."
    $("#errmsg").addClass "alert alert-error"
    $("#flash_error").append "<a class='close' data-dismiss='alert'>&#215;</a>"
    false
  else unless /^[0-9]{15}$/.test(imei)
    $("#flash_error").html "imei is the wrong length (should be 15 characters)"
    $("#errmsg").addClass "alert alert-error"
    $("#flash_error").append "<a class='close' data-dismiss='alert'>&#215;</a>"
    false
  else
    true



