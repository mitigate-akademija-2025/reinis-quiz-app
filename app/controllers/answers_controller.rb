class AnswersController < ApplicationController
    include ActionView::RecordIdentifier

  def new
    quiz = Quiz.find(params[:quiz_id])
    question = Question.find(params[:question_id])
    answer = question.answers.build # Not saved to DB

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.append(:answers, partial: "answers/answer", locals: { answer: answer, question: question, quiz: quiz }) }
    end
  end

    def destroy
        answer = Answer.find(params[:id])
        answer.destroy
        rescue ActiveRecord::RecordNotFound
            answer = Answer.new(id: params[:id])
        ensure 
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(answer)) }
                format.html { redirect_back fallback_location: root_path }
        end
    end

    def remove_local
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(params[:dom_id]) }
    end
  end
end
