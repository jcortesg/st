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

describe AffiliatesController do

  # This should return the minimal set of attributes required to create a valid
  # Affiliate. As you add validations to Affiliate, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all affiliates as @affiliates" do
      affiliate = Affiliate.create! valid_attributes
      get :index
      assigns(:affiliates).should eq([affiliate])
    end
  end

  describe "GET show" do
    it "assigns the requested affiliate as @affiliate" do
      affiliate = Affiliate.create! valid_attributes
      get :show, :id => affiliate.id
      assigns(:affiliate).should eq(affiliate)
    end
  end

  describe "GET new" do
    it "assigns a new affiliate as @affiliate" do
      get :new
      assigns(:affiliate).should be_a_new(Affiliate)
    end
  end

  describe "GET edit" do
    it "assigns the requested affiliate as @affiliate" do
      affiliate = Affiliate.create! valid_attributes
      get :edit, :id => affiliate.id
      assigns(:affiliate).should eq(affiliate)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Affiliate" do
        expect {
          post :create, :affiliate => valid_attributes
        }.to change(Affiliate, :count).by(1)
      end

      it "assigns a newly created affiliate as @affiliate" do
        post :create, :affiliate => valid_attributes
        assigns(:affiliate).should be_a(Affiliate)
        assigns(:affiliate).should be_persisted
      end

      it "redirects to the created affiliate" do
        post :create, :affiliate => valid_attributes
        response.should redirect_to(Affiliate.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved affiliate as @affiliate" do
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliate.any_instance.stub(:save).and_return(false)
        post :create, :affiliate => {}
        assigns(:affiliate).should be_a_new(Affiliate)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliate.any_instance.stub(:save).and_return(false)
        post :create, :affiliate => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested affiliate" do
        affiliate = Affiliate.create! valid_attributes
        # Assuming there are no other affiliates in the database, this
        # specifies that the Affiliate created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Affiliate.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => affiliate.id, :affiliate => {'these' => 'params'}
      end

      it "assigns the requested affiliate as @affiliate" do
        affiliate = Affiliate.create! valid_attributes
        put :update, :id => affiliate.id, :affiliate => valid_attributes
        assigns(:affiliate).should eq(affiliate)
      end

      it "redirects to the affiliate" do
        affiliate = Affiliate.create! valid_attributes
        put :update, :id => affiliate.id, :affiliate => valid_attributes
        response.should redirect_to(affiliate)
      end
    end

    describe "with invalid params" do
      it "assigns the affiliate as @affiliate" do
        affiliate = Affiliate.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliate.any_instance.stub(:save).and_return(false)
        put :update, :id => affiliate.id, :affiliate => {}
        assigns(:affiliate).should eq(affiliate)
      end

      it "re-renders the 'edit' template" do
        affiliate = Affiliate.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Affiliate.any_instance.stub(:save).and_return(false)
        put :update, :id => affiliate.id, :affiliate => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested affiliate" do
      affiliate = Affiliate.create! valid_attributes
      expect {
        delete :destroy, :id => affiliate.id
      }.to change(Affiliate, :count).by(-1)
    end

    it "redirects to the affiliates list" do
      affiliate = Affiliate.create! valid_attributes
      delete :destroy, :id => affiliate.id
      response.should redirect_to(affiliates_url)
    end
  end

end
