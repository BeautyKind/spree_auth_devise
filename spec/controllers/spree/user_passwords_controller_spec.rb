require 'spec_helper'

describe Spree::UserPasswordsController do
  let(:user) { create(:user) }
  before do
    @request.env["devise.mapping"] = Devise.mappings[:spree_user]
  end

  context "#create" do

    context "using valid email" do
      context "and html format is used" do
        it "redirects to login" do
          spree_post :create, spree_user: { email: user.email }
          expect(response).to redirect_to spree.login_path
        end
      end

      context "and js format is used" do
        it "returns a json with the user" do
          spree_post :create, spree_user: { email: user.email }, format: 'js'
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed).to have_key("user")
        end
      end
    end

    context "using invalid email" do
      context "and html format is used" do
        it "renders forgot password template again" do
          spree_post :create, spree_user: { email: nil }
          expect(response).to render_template('new')
        end
      end

      context "and js format is used" do
        it "returns a json with the error" do
          spree_post :create, spree_user: { email: nil }, format: 'js'
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed).to have_key("message")
          expect(parsed["message"]).to eq I18n.t('devise.failure.invalid')
        end
      end
    end
  end
end

