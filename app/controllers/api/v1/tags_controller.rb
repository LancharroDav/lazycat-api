class Api::V1::TagsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_tag, only: [:show]
  before_action :authenticate_user!

  #GET /api/v1/tags.json
  def index
    tags_prepared = []
    tag = current_user.tags.sort_by { |a| a[:title]}
    tag.each do |t|
      t_final = t.slice(:id, :title)
      t_final[:count] = t.bookmarks.count
      if (t_final[:count] > 0)
        tags_prepared << t_final
      end
    end

    render json: tags_prepared
  end

  #GET /api/v1/tags/[:id].json
  def show
    bookmarks = @tag.bookmarks

    render json: bookmarks, include: {tags: {only: :title}}, except: [:user_id, :updated_at]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = current_user.tags.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tags_params
      params.require(:tag).permit(:title)
    end
end