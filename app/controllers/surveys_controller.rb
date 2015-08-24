class SurveysController < ApplicationController
  def index
  	@surveys=Survey.all
  end

  def new
  	@survey=Survey.new
    #@survey.questions.new
    @questions=Question.all
  end

  def create
  	@survey=Survey.new(survey_params)
    @survey.question_surveys.build(:question_id => '2', :survey_id => @survey.id) 
  	if @survey.save
  		flash[:success]="Survey Created"
  		redirect_to '/surveys'
  	else
  		flash.now[:error]="Please try again"
  		render'/'
  	end
  end

  def show
    @survey = Survey.find(params[:id])
    @survey_questions=QuestionSurvey.where(:survey => @survey)
    @surveyquestions=[]
    @survey_questions.each do |sq|
      @surveyquestions << sq.question_id
    end
    @questions=Question.all


  end


  def destroy_multiple

  Survey.destroy(params[:surveys])

  respond_to do |format|
    format.html { redirect_to '/surveys' }
    format.json { head :no_content }
  end
  end

  def survey_params
  	params.require(:survey).permit(:id, :title, :date, :category, questions_attributes: [:id, :context], question_surveys_attributes: [:survey_id, :question_id])
  end
end
