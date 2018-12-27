class Api::V1::PinsController < ApplicationController
  before_action :basic_auth

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, token|
      user = User.find_by_email(username)
      sign_in user if user && user.api_token == token
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :image_url)
  end
end
