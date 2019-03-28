class ResourceController < ApplicationController
  def index
    @resources = if params[:filter].present?
      Resource.page(params[:page]).tag_filter(params[:filter])
    else
      Resource.page(params[:page])
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
