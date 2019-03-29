class ResourceController < ApplicationController
  include ApplicationHelper

  before_action :sanitize_tags, :only => :index

  def index
    @resources = if params[:filter].present?
      Resource.tag_filter(*sanitize_tags)
    else
      Resource.latest
    end
  end

  def new

  end

  def create
    user = Resource.create!(resource_params)
  end

  private
    def resource_params
      params.require(:resource).permit(:name, :tag_list, :filename)
    end

end
