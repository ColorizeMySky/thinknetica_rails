module ApplicationHelper
  def current_user_owner_of?(resource)
    user_signed_in? && current_user.owner_of?(resource)
  end
end
