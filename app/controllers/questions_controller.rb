class QuestionsController < ApplicationController
    def new
        respond_to do |format|
            format.turbo_stream
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
