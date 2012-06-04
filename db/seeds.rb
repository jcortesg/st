unless User.where(:email => 'admin@borwin.net').exists?
  @user = User.new(email: 'admin@borwin.net', password: '221181', password_confirmation: '221181')
  @user.role = 'admin'
  @user.approved = true
  @user.save!
end

if Rails.env == 'development'
  unless User.where(email: 'anunciante@borwin.net').exists?
    @user = User.new(email: 'anunciante@borwin.net', password: '221181', password_confirmation: '221181')
    @user.role = 'advertiser'
    @user.approved = true
    @user.save!
    @advertiser = Advertiser.new(company: 'Anunciantes SA', first_name: 'Juan', last_name: 'Perez', phone: '4040-2341')
    @advertiser.user_id = @user.id
    @advertiser.save!
  end

  unless User.where(email: 'afiliado@borwin.net').exists?
    @user = User.new(email: 'afiliado@borwin.net', password: '221181', password_confirmation: '221181')
    @user.role = 'affiliate'
    @user.approved = true
    @user.save!
    @affiliate = Affiliate.new(first_name: 'Marcos', last_name: 'Benitez', phone: '3232-3211')
    @affiliate.user_id = @user.id
    @affiliate.save!
  end
end
