module UsersHelper
  def user_scope(scope, user)
    if user.role == 'admin'
      scope
    end
  end
end
