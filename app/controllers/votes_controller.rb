class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable

  def vote_up
    if @votable.vote_up(current_user)
      render turbo_stream: turbo_stream.replace(
        "vote-block-#{@votable.class.name.underscore}-#{@votable.id}",
        partial: "shared/voting",
        locals: { votable: @votable }
      )
    else
      render_json_error
    end
  end

  def vote_down
    if @votable.vote_down(current_user)
      render turbo_stream: turbo_stream.replace(
        "vote-block-#{@votable.class.name.underscore}-#{@votable.id}",
        partial: "shared/voting",
        locals: { votable: @votable }
      )
    else
      render_json_error
    end
  end

  def cancel_vote
    @votable.cancel_vote(current_user)
    render turbo_stream: turbo_stream.replace(
      "vote-block-#{@votable.class.name.underscore}-#{@votable.id}",
      partial: "shared/voting",
      locals: { votable: @votable }
    )
  end

  private

  def set_votable
    @votable = votable_class.find(params[:votable_id])
  end

  def votable_class
    params[:votable_type].classify.constantize
  end

  def render_json_rating
    render json: { rating: @votable.rating, votable_type: params[:votable_type], votable_id: @votable.id }
  end

  def render_json_error
    render json: { error: "Не удалось проголосовать" }, status: :unprocessable_entity
  end
end
