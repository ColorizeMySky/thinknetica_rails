class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :destroy ]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy
    redirect_to questions_path, notice: "Question was successfully deleted"
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
