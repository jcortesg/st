unless User.where(:email => 'admin@borwin.com.ar').exists?
  @user = User.create(email: 'admin@borwin.com.ar', password: 'borwin123', password_confirmation: 'borwin123')
  @user.role = 'administrator'
  @user.approved = true
  @user.save!
end

PaymentType.create([{ name: 'fee', description: 'Costo Fijo', status: 'A' },
                    { name: 'cpc', description: 'Costo por Click', status: 'A' },
                    { name: 'fee+cpc', description: 'Costo Fijo + Costo por Click', status: 'A' }]) if (PaymentType.count == 0)