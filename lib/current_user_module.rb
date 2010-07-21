module CurrentUserModule
  def current_user=(current_user)
    Thread.current["current_user"] = current_user
  end
  def current_user
    Thread.current["current_user"]
  end
end