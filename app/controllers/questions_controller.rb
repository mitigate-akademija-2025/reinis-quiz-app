class QuestionsController < ApplicationController
    def new
        quiz = Quiz.find(params[:quiz_id])
        question = Question.new(quiz: quiz)
        question.title = 'New Question'

        if question.save
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.append(:questions, partial: "questions/question", locals: { question: question, quiz: quiz }) }
            end
        end
    end

    def destroy
        question = Question.find(params[:id])
        question.destroy
        rescue ActiveRecord::RecordNotFound
            question = Question.new(id: params[:id])
        ensure 
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.remove(question.id) }
        end
    end
end
