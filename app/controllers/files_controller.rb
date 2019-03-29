class FilesController < ApplicationController
  include ApplicationHelper

  def index
    if params[:filter].present?
      included_tags, excluded_tags = sanitize_tags(params[:filter])
      @resources = Resource.tag_filter(included_tags, excluded_tags).page(params[:page]).per(10)
      @related = Resource.related_content(@resources, included_tags, excluded_tags)
    else
      @resources = Resource.latest.page(params[:page]).per(10)
    end
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def create
    user = Resource.create!(resource_params)
    redirect_to(files_path)
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Invalid information: #{e.message}"
    redirect_to(files_new_path)
  end

  private
    def resource_params
      params.require(:resource).permit(:name, :tags, :filename)
    end

end
