require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe TweetDetailsController do

  # This should return the minimal set of attributes required to create a valid
  # TweetDetail. As you add validations to TweetDetail, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all tweet_details as @tweet_details" do
      tweet_detail = TweetDetail.create! valid_attributes
      get :index
      assigns(:tweet_details).should eq([tweet_detail])
    end
  end

  describe "GET show" do
    it "assigns the requested tweet_detail as @tweet_detail" do
      tweet_detail = TweetDetail.create! valid_attributes
      get :show, :id => tweet_detail.id
      assigns(:tweet_detail).should eq(tweet_detail)
    end
  end

  describe "GET new" do
    it "assigns a new tweet_detail as @tweet_detail" do
      get :new
      assigns(:tweet_detail).should be_a_new(TweetDetail)
    end
  end

  describe "GET edit" do
    it "assigns the requested tweet_detail as @tweet_detail" do
      tweet_detail = TweetDetail.create! valid_attributes
      get :edit, :id => tweet_detail.id
      assigns(:tweet_detail).should eq(tweet_detail)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TweetDetail" do
        expect {
          post :create, :tweet_detail => valid_attributes
        }.to change(TweetDetail, :count).by(1)
      end

      it "assigns a newly created tweet_detail as @tweet_detail" do
        post :create, :tweet_detail => valid_attributes
        assigns(:tweet_detail).should be_a(TweetDetail)
        assigns(:tweet_detail).should be_persisted
      end

      it "redirects to the created tweet_detail" do
        post :create, :tweet_detail => valid_attributes
        response.should redirect_to(TweetDetail.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tweet_detail as @tweet_detail" do
        # Trigger the behavior that occurs when invalid params are submitted
        TweetDetail.any_instance.stub(:save).and_return(false)
        post :create, :tweet_detail => {}
        assigns(:tweet_detail).should be_a_new(TweetDetail)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TweetDetail.any_instance.stub(:save).and_return(false)
        post :create, :tweet_detail => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tweet_detail" do
        tweet_detail = TweetDetail.create! valid_attributes
        # Assuming there are no other tweet_details in the database, this
        # specifies that the TweetDetail created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TweetDetail.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => tweet_detail.id, :tweet_detail => {'these' => 'params'}
      end

      it "assigns the requested tweet_detail as @tweet_detail" do
        tweet_detail = TweetDetail.create! valid_attributes
        put :update, :id => tweet_detail.id, :tweet_detail => valid_attributes
        assigns(:tweet_detail).should eq(tweet_detail)
      end

      it "redirects to the tweet_detail" do
        tweet_detail = TweetDetail.create! valid_attributes
        put :update, :id => tweet_detail.id, :tweet_detail => valid_attributes
        response.should redirect_to(tweet_detail)
      end
    end

    describe "with invalid params" do
      it "assigns the tweet_detail as @tweet_detail" do
        tweet_detail = TweetDetail.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TweetDetail.any_instance.stub(:save).and_return(false)
        put :update, :id => tweet_detail.id, :tweet_detail => {}
        assigns(:tweet_detail).should eq(tweet_detail)
      end

      it "re-renders the 'edit' template" do
        tweet_detail = TweetDetail.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TweetDetail.any_instance.stub(:save).and_return(false)
        put :update, :id => tweet_detail.id, :tweet_detail => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested tweet_detail" do
      tweet_detail = TweetDetail.create! valid_attributes
      expect {
        delete :destroy, :id => tweet_detail.id
      }.to change(TweetDetail, :count).by(-1)
    end

    it "redirects to the tweet_details list" do
      tweet_detail = TweetDetail.create! valid_attributes
      delete :destroy, :id => tweet_detail.id
      response.should redirect_to(tweet_details_url)
    end
  end

end
