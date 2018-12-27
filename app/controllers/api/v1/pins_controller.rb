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
    user = User.find_by(email: request.headers['X-USER-EMAIL'])
    if user && user.api_token == request.headers['X-API-TOKEN']
      sign_in user
    else
      head 401
    end
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :image_url)
  end
end
