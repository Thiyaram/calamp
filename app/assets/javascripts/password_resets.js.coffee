$ ->
  $("#errmsg").hide()
  $("#updatepassword_btn").click ->
    password = $("#password").val()
    confirmpassword = $("#password_confirmation").val()
    if password is ""
      $("#errmsg").show()
      $("#flash_error").html "Enter valid password"
      return false
    unless password is confirmpassword
      $("#errmsg").show()
      $("#flash_error").html "Password confirmation does not match..."
      return false
    $("#errmsg").hide()
    true
