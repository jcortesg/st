unless User.where(:email => 'admin@socialtarget.net').exists?
  @user = User.new(email: 'admin@socialtarget.net', password: 'social123', password_confirmation: 'social123')
  @user.role = 'admin'
  @user.approved = true
  @user.save!
end

if Rails.env == 'development'
  unless User.where(email: 'anunciante@socialtarget.net').exists?
    @user = User.new(email: 'anunciante@socialtarget.net', password: 'social123', password_confirmation: 'social123')
    @user.role = 'advertiser'
    @user.approved = true
    @user.save!
    @advertiser = Advertiser.new(company: 'Anunciantes SA', first_name: 'Juan', last_name: 'Perez', phone: '4040-2341')
    @advertiser.can_create_campaigns = true
    @advertiser.user_id = @user.id
    @advertiser.save!
  end

  unless User.where(email: 'afiliado@socialtarget.net').exists?
    @user = User.new(email: 'afiliado@socialtarget.net', password: 'social123', password_confirmation: 'social123')
    @user.role = 'affiliate'
    @user.approved = true
    @user.save!
    @affiliate = Affiliate.new(first_name: 'Marcos', last_name: 'Benitez', phone: '3232-3211')
    @affiliate.user_id = @user.id
    @affiliate.save!
  end
end
