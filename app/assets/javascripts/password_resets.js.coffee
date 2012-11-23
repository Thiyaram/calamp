$ ->
  $("#errmsg").hide()
 
  
  $("#updatepassword_btn").click ->
    password = $("#user_new_password").val()
    confirmpassword = $("#user_new_password_confirmation").val()
    if password is ""
      $("#errmsg").show()
      $("#flash_error").html "Enter valid password to continue ..."
      return false
    unless password is confirmpassword
      $("#errmsg").show()
      $("#flash_error").html "Password confirmation does not match..."
      return false
    $("#errmsg").hide()
    true
