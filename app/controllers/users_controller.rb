require 'builder'
require 'will_paginate'
include ActionView::Helpers::NumberHelper

class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit_settings, :update_settings, :index, :all_users]

  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def edit_settings
    @user = User.find(params[:id])
  end

  def update_settings
    @user = User.find(params[:id])
    if @user.update_attributes(setting_params)
      flash.now[:success] = "Settings have been successfully saved."
      render 'edit_settings'
    else
      render 'edit_settings'
    end
  end

  def sme_edit
    @user = User.find(params[:id])
  end

  def sme_update
    @user = User.find(params[:id])
    if @user.update_attributes(sme_params)
      flash.now[:success] = "Profile has been successfully updated."
      render 'sme_edit'
    else
      render 'sme_edit'
    end
  end

  def provider_edit
    @user = User.find(params[:id])
  end

  def provider_update
    @user = User.find(params[:id])
    if @user.update_attributes(sme_params)
      flash.now[:success] = "Profile has been successfully updated."
      render 'provider_edit'
    else
      render 'provider_edit'
    end
  end

  def index
      @users = User.where.not("id = ?",current_user.id).order("created_at DESC")
      @conversations = Conversation.involving(current_user).order("created_at DESC")
  end

  def all_users
    @filterrific = initialize_filterrific(
      User,
      params[:filterrific],
      :select_options => {
        sorted_by: User.options_for_sorted_by,
        with_rolable_type: User.rolable_type_for_select,
        with_provider_type: User.provider_type_for_select,
        by_nature_of_funding: User.nature_of_funding_for_select,
        with_business_activity: User.business_activity_for_select,
        by_other_support_sought: User.other_support_sought_for_select,
        by_nature_of_financing: User.nature_of_funding_for_select,
        by_other_support_offered: User.other_support_sought_for_select
      },
       :persistence_id => false,
    ) or return
    @users = @filterrific.find.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

    def signed_in_user
      unless signed_in?
        redirect_to new_user_session_path
      end
    end

  private

    def setting_params
      params.require(:user).permit(:address, :contact_number, :email, :password,
                                   :password_confirmation, :current_password)
    end

    def sme_params
      params.require(:user).permit(:ceo_name, :username, :business_activity, :date_founded, :content, nature_of_funding:[], other_support_sought:[])
    end

    def provider_params
      params.require(:user).permit(:username, :provider_type, :content, nature_of_financing:[], other_support_offered:[])
    end

end