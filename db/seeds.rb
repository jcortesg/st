unless User.where(:email => 'admin@social-target.net').exists?
  @user = User.new(email: 'admin@social-target.net', password: 'social123', password_confirmation: 'social123')
  @user.role = 'admin'
  @user.approved = true
  @user.save!
end

if Rails.env == 'development'
  unless User.where(email: 'anunciante@social-target.net').exists?
    @user = User.new(email: 'anunciante@social-target.net', password: 'social123', password_confirmation: 'social123')
    @user.role = 'advertiser'
    @user.approved = true
    @user.save!
    @advertiser = Advertiser.new(company: 'Anunciantes SA', first_name: 'Juan', last_name: 'Perez', phone: '4040-2341')
    @advertiser.can_create_campaigns = true
    @advertiser.user_id = @user.id
    @advertiser.save!
  end

  unless User.where(email: 'afiliado@social-target.net').exists?
    @user = User.new(email: 'afiliado@social-target.net', password: 'social123', password_confirmation: 'social123')
    @user.role = 'affiliate'
    @user.approved = true
    @user.save!
    @affiliate = Affiliate.new(first_name: 'Marcos', last_name: 'Benitez', phone: '3232-3211')
    @affiliate.user_id = @user.id
    @affiliate.save!
  end
end
