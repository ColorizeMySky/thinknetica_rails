class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question
    else
      @answers = @question.answers
      render "questions/show"
    end
  end

  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
