class Api::V1::BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :set_bookmark, only: [:destroy, :update]
  before_action :authenticate_user!

  #GET /api/v1/bookmarks.json
  def index
    bookmarks = current_user.bookmarks.last(10).sort_by { |a| -a[:id]}

    render json: bookmarks, include: {tags: {except: [:user_id, :created_at, :updated_at]}}, except: [:user_id, :updated_at]

  end

  #POST /api/v1/bookmarks.json
  def create
    tags_arr = bookmarks_params[:all_tags].downcase.split(",")
    tag_check = tags_arr.any?{|t| t.blank?}
    
    if tag_check == false
      host = bookmarks_params[:url].split('/')[0] + '//' + bookmarks_params[:url].split('/')[2]
      parsed_url = LinkThumbnailer.generate(host)
      icon_url = parsed_url.favicon
      bookmark = current_user.bookmarks.new(url: bookmarks_params[:url], title: bookmarks_params[:title], icon: icon_url)
      
      if bookmark.save
        bookmark_id = Bookmark.find_by(url: bookmarks_params[:url]).id
        tags_arr.map do |title|
          current_user.tags.find_or_create_by!(title: title)
          tag_id = Tag.find_by(title: title).id
          Tagging.find_or_create_by!(bookmark_id: bookmark_id, tag_id: tag_id)
        end
      
        render json: "Bookmark succesfully saved!", status: :created
      else
        render json: bookmark.errors, status: :unprocessable_entity
      end
    else
      render json: "Some tags are empty"
    end
  end

  #PATCH/PUT /api/v1/bookmarks/[:id]
  def update
    bookmark = current_user.bookmarks.find_by(id: params[:id])
    tags_arr = bookmarks_params[:all_tags].downcase.split(",")
    tagging_match = Tagging.where(bookmark_id: params[:id])

    if bookmark.update(title: bookmarks_params[:title])
      bookmark_id = Bookmark.find_by(url: bookmarks_params[:url]).id
      tagging_match.map do |match|
        match.destroy
      end
      tags_arr.map do |title|
        current_user.tags.find_or_create_by!(title: title)
        tag_id = Tag.find_by(title: title).id
        Tagging.find_or_create_by!(bookmark_id: bookmark_id, tag_id: tag_id)
      end
      render json: "Bookmark updated!"
    end
  end

  #DELETE /api/v1/bookmarks/[:id]
  def destroy
    bookmark = current_user.bookmarks.find_by(id: params[:id])
    bookmark.destroy
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = params[:id]
    end
    # Only allow a list of trusted parameters through.
    def bookmarks_params
      params.require(:bookmark).permit(:url, :title, :all_tags)
    end
end