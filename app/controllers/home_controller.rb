# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
    redirect_to(action: 'initrax') if user_signed_in?
  end

  def initrax; end
end
