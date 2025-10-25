class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :edit, :update, :destroy ]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save

    respond_to :js
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @answer.update(answer_params)

    respond_to :js
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy
    respond_to :js
  end

  def mark_as_best
    @answer = Answer.find(params[:id])

    if current_user == @answer.question.user
      @answer.mark_as_best
      flash[:notice] = "Best answer selected"
      respond_to :js
    else
      head :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
