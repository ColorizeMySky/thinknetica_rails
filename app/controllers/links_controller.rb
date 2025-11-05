class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if current_user.owner_of?(@link.linkable)

    respond_to :js
  end
end
