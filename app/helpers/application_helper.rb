module ApplicationHelper
  def javascript(*files)
    content_for(:loginjs) { javascript_include_tag(*files) }
  end

  def role_list
		Role.all.collect {|i| [i.name, i.id]}
  end

  def role_list_based_on_current_user
    if current_user.role.name == User::SUPER_ADMIN_ROLE
      Role.where(:name =>[User::ADMIN_ROLE, User::USER_ROLE]).collect {|x| [x.name, x.id]}
    else
      Role.where(:name =>[User::USER_ROLE]).collect {|x| [x.name, x.id]}
    end
  end

end
