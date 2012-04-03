module TweetHelper  
  def campaigns_for_select
    Campaign.where(:advertiser_id => current_entity_id).collect { |c| [c.description, c.id] }
  end
  def payment_types_for_select
    PaymentType.all.collect { |c| [c.description, c.id] }
  end  
end