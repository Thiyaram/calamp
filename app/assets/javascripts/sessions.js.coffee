$ ->
  $("#errmsg").hide()

	
	
	$("#login_btn").click ->
	  a = undefined
	  password = undefined
	  a = $("#email").val()
	  password = $("#password").val()
	  unless /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.test(a)
	    $("#errmsg").show()
	    $("#flash_error").html "Enter valid email to continue..."
	    return false
	  if password is ""
	    $("#errmsg").show()
	    $("#flash_error").html "Enter password to continue..."
	    return false
	  $("#errmsg").hide()
	  true