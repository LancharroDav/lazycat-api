class Api::V1::KitsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_kit, only: [:destroy]
  before_action :authenticate_user!

    #GET /api/v1/kits.json
    def index
      kits = current_user.kits
      
      render json: kits, include: {bookmarks: {except: [:user_id, :created_at, :updated_at]}}, except: [:user_id]
  
    end

  #POST api/v1/kits.json
  def create
    kit = current_user.kits.new(kits_params)

    if kit.save
      render json: kit
    else
      render json: kit.errors, status: :unprocessable_entity
    end
  end

  #DELETE api/v1/kits/[:id].json
  def destroy
    kit = current_user.kits.find_by(id: params[:id])
    kit.destroy
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_kit
      @kit = Kit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kits_params
      params.require(:kit).permit(:title)
    end
end