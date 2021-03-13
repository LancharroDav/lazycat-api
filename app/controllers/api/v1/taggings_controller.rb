class Api::V1::TaggingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  #POST api/v1/taggings.json
  def create
    tagging = Tagging.new(taggings_params)

    if tagging.save
      render json: tagging
    else
      render json: tagging.errors, status: :unprocessable_entity
    end
  end

  #DELETE api/v1/taggings/[:id].json
  def destroy
    tagging = Tagging.find_by(taggings_params)

    if tagging.destroy
      render json: 'Succesfully removed from this kit'
    else
      render json: kitting.errors, status: :unprocessable_entity
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def taggings_params
      params.require(:tagging).permit(:bookmark_id, :tag_id)
    end
end