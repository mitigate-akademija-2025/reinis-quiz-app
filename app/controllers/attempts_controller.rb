class AttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz
  before_action :check_previous_attempt, only: [:new, :create]
  
  def new
    @attempt = @quiz.attempts.build(user: current_user)
    @questions = @quiz.questions.includes(:answers)
  end

  def create
    @attempt = @quiz.attempts.build(user: current_user)
    
    if params[:attempt] && params[:attempt][:submissions_attributes]
      params[:attempt][:submissions_attributes].each do |_, submission_params|
        @attempt.submissions.build(
          question_id: submission_params[:question_id],
          answer_id: submission_params[:answer_id]
        )
      end
    end

    if @attempt.save
      redirect_to quiz_attempt_path(@quiz, @attempt), notice: 'Quiz completed successfully!'
    else
      @questions = @quiz.questions.includes(:answers)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @attempt = @quiz.attempts.includes(submissions: { question: :answers }).find(params[:id])
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def check_previous_attempt
    if @quiz.attempted_by?(current_user)
      redirect_to quiz_attempt_path(@quiz, @quiz.last_attempt_for(current_user)), 
                  alert: "You have already completed this quiz."
    end
  end
end