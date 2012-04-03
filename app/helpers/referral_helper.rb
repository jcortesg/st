module ReferralHelper  
  def users_for_select
    User.active.collect { |m| [m.email, m.id] }
  end
end