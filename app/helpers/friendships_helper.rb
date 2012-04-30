module FriendshipsHelper
  def bookshelf_id(user)
    if user.username.blank?
      user.id
    else
      user.username
    end
  end
end
