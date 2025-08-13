class AnswersController < ApplicationController

  def new
    quiz = Quiz.find(params[:quiz_id])
    question = Question.find(params[:question_id])
    @answer = Answer.new(question: question)

    @answer.body = 'Answer...'
    @answer.is_correct = false

    @answer.save
    
    # if answer.save
    #     respond_to do |format|
    #       # format.turbo_stream { render turbo_stream: turbo_stream.append(:answers, partial: "answers/answer", locals: { quiz: quiz, question: question, answer: answer }) }
    #       format.turbo_stream 
    #     end
    # end
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
