class QuestionsController < ApplicationController
    include ActionView::RecordIdentifier
    def new
        quiz = Quiz.find(params[:quiz_id])
        @question = Question.new(quiz: quiz)
        @question.title = 'New Question'

        if @question.save
            respond_to do |format|
                format.turbo_stream
            end
        end
    end

    def destroy
        @question = Question.find(params[:id])
        @question.destroy
        rescue ActiveRecord::RecordNotFound
            @question = Question.new(id: params[:id])
        ensure 
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@question)) }
    end
    end
end
