class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
  
    if user.is? :administrator
      can :manage, :all
      
    elsif user.is? :super_user
      can :read, :all
    
    elsif user.is? :influencer
      can :manage, Home
      can :manage, Influencer, :user_id => user.id
      can :manage, Audience
      can :manage, Message
      can [:details, :read], Transaction     
      can :manage, Tweet, :influencer_id => Influencer.influencer_for_user(user).id
      can :index, Referral, :source_id => Influencer.influencer_for_user(user).id
    
    elsif user.is? :advertiser
      can :manage, Home
      can :list, Influencer
      can :influencer, Audience
      can :manage, Message
      can [:details, :read], Transaction
      can :manage, Advertiser, :user_id => user.id     
      can :manage, Campaign, :advertiser_id => Advertiser.advertiser_for_user(user).id
      can :manage, Tweet, :advertiser_id => Advertiser.advertiser_for_user(user).id
    
    elsif user.is? :affiliate
      can :manage, Home
      can :manage, Message
      can [:details, :read], Transaction   
      can :manage, Affiliate, :user_id => user.id
      can :index, Referral, :source_id => Affiliate.affiliate_for_user(user).id
      
    else  
      can :create, User
      can :create, Influencer
      can :create, Advertiser
      can :create, Affiliate      
    end
  end
end