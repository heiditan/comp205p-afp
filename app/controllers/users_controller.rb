require 'builder'
require 'will_paginate'
include ActionView::Helpers::NumberHelper

class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit_settings
    @user = User.find(params[:id])
  end

  def update_settings
    @user = User.find(params[:id])
    if @user.update_attributes(setting_params)
    else
      render 'edit_settings'
    end
  end

  def index
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

  private

    def setting_params
      params.require(:user).permit(:address, :contact_number, :email, :password,
                                   :password_confirmation)
    end

end