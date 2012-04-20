class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
  
    if user.admin?
      can :manage, :all
      
    elsif user.influencer?
      can :manage, Home
      can :manage, Influencer, :user_id => user.id
      can :manage, Audience
      can :manage, Message
      can [:details, :read], Transaction     
      can :manage, Tweet, :influencer_id => user.influencer.id
      can :index, Referral, :source_id => user.influencer.id
    
    elsif user.advertiser?
      can :manage, Home
      can :list, Influencer
      can :influencer, Audience
      can :manage, Message
      can [:details, :read], Transaction
      can :manage, Advertiser, :user_id => user.id     
      can :manage, Campaign, :advertiser_id => user.advertiser.id
      can :manage, Tweet, :advertiser_id => user.advertiser.id
    
    elsif user.affiliate?
      can :manage, Home
      can :manage, Message
      can [:details, :read], Transaction   
      can :manage, Affiliate, :user_id => user.id
      can :index, Referral, :source_id => user.affiliate.id
    else  
      can :create, User
      can :create, Influencer
      can :create, Advertiser
      can :create, Affiliate      
    end
  end
end