class AnswersController < ApplicationController

  def new
    quiz = Quiz.find(params[:quiz_id])
    question = Question.find_by(id: params[:question_id]) || 
               quiz.questions.build(id: params[:question_id])
    @answer = question.answers.build
    @answer.body = 'New Answer'
    @answer.is_correct = false
    @answer.save

    respond_to do |format|
      format.turbo_stream
    end
  end

    def destroy
        answer = Answer.find(params[:id])
        answer.destroy
        rescue ActiveRecord::RecordNotFound
            answer = Answer.new(id: params[:id])
        ensure 
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.remove(answer.id) }
        end
    end
end
