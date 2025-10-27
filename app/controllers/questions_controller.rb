class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.with_attached_files.find(params[:id])
    @answers = @question.answers.sort_by_best
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

  def edit
    @question = current_user.questions.find(params[:id])
  end

  def update
    @question = current_user.questions.find(params[:id])

    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy
    redirect_to questions_path, notice: "Question was successfully deleted"
  end

  def purge_attachment
    @question = current_user.questions.find(params[:id])
    @question.files.find(params[:attachment_id]).purge
    redirect_to @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
