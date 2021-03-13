class Api::V1::ChecksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  #GET /api/v1/checks.json
  def index
    render json: 'User logged', status: :ok
  end

  def starter
    bookmarks_prepared = []
    bookmarks = current_user.bookmarks.last(10).sort_by { |a| -a[:id]}
    bookmarks.each do |bm|
      bm_final = bm.slice(:id, :title, :url, :icon, :created_at)
      bm_final[:tags] = bm.tags.map do |t|
                        t_info = {}
                        t_info[:title] = t[:title]
                        t_info
                        end
      bookmarks_prepared << bm_final
    end    

    tags_prepared = []
    tag = current_user.tags.sort_by { |a| a[:title]}
    tag.each do |t|
      t_final = t.slice(:id, :title)
      t_final[:count] = t.bookmarks.count
      if (t_final[:count] > 0)
        tags_prepared << t_final
      end
    end

    kits_prepared = []
    kits = current_user.kits
    kits.each do |kt|
      kt_final = kt.slice(:id, :title, :created_at, :updated_at)
      kt_final[:bookmarks] = kt.bookmarks.map do |kb|
                              bm_info = {}
                              bm_info[:id] = kb[:id]
                              bm_info[:title] = kb[:title]
                              bm_info[:url] = kb[:url]
                              bm_info[:icon] = kb[:icon]
                              bm_info
                             end
      kits_prepared << kt_final
    end

    all_data = {bookmarks: bookmarks_prepared,
                tags: tags_prepared,
                kits: kits_prepared
              }

    render json: all_data
  end
end