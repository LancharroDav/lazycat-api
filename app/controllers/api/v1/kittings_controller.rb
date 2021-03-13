class Api::V1::KittingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  #POST api/v1/kittings.json
  def create
    kitting = Kitting.new(kittings_params)

    if kitting.save
      render json: kitting
    else
      render json: kitting.errors, status: :unprocessable_entity
    end
  end

  #DELETE api/v1/kittings.json
  def destroy
    kit_id = params[:id].split('-')[0]
    bookmark_id = params[:id].split('-')[1]
    kitting = Kitting.find_by(kit_id: kit_id, bookmark_id: bookmark_id)

    # render json: kitting
    if kitting.destroy
      render json: 'Succesfully removed from this kit'
    else
      render json: kitting.errors, status: :unprocessable_entity
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def kittings_params
      params.require(:kitting).permit(:kit_id, :bookmark_id)
    end
end