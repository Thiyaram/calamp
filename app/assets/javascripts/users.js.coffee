$(document).ready ->

  userTable = $("#users-datatable").dataTable
    sPaginationType: "bootstrap_alt"
    oLanguage:
      sLengthMenu: "_MENU_ users per page"
      sZeroRecords: "No users found"
      sInfoFiltered: "(filtered from _MAX_ total users)",
      sInfo: "Showing _START_ to _END_ of _TOTAL_ users"
      sInfoEmpty: ""
  userTable.fnSort [[4, "desc"],[1, "asc"]]

  email = undefined
  x = undefined
  x = 0
  email = /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  $(".error_div").hide();
  $(".close").click ->
  	$(".error_div").hide();

  $("form").submit	 ->
  	if $.trim($("#u_name").val()) is ""
  		$(".error_div").show()
  		$(".msg").text "Name is Mandatory field"
  		false
  	else if $.trim($("#u_email").val()) is ""
  		$(".error_div").show()
  		$(".msg").text "Email is Mandatory field"
  		false
  	else unless email.test($("#u_email").val())
  		$(".error_div").show()
  		$(".msg").text "Enater valid email"
  		false
  	else if	$(".u_sub").val() is "Create User" && $.trim($("#u_password").val()) is ""
  		$(".error_div").show()
  		$(".msg").text "Password is Mandatory field"
  		false
  	else if	$(".u_sub").val() is "Create User" && $.trim($("#u_password").val().length) < 6
  		$(".error_div").show()
  		$(".msg").text "Password should have minimum 6 character length"
  		false
  	else if	$.trim($("#u_password").val()) isnt "" && $.trim($("#u_password").val().length) < 6
  		$(".error_div").show()
  		$(".msg").text "Password should have minimum 6 character length"
  		false
  	else if $.trim($("#u_password").val()) isnt $("#u_con").val()
  		$(".error_div").show()
  		$(".msg").text "Password is not matching"
  		false
  	else
  		$("form").submit()

