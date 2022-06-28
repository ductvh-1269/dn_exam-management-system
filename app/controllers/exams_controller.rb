class ExamsController < ApplicationController
  include SessionsHelper
  before_action :load_user
  before_action :load_subject, :load_questions, :init_exam, only: :new

  def new; end

  private
  def load_questions
    return if @questions = @subject.questions.to_a.shuffle![0..9]

    flash[:danger] = t ".question_not_implemented"
    redirect_to :root
  end

  def load_subject
    return if @subject = Subject.find_by(id: params[:subject_id])

    flash[:danger] = t ".resource_not_found"
    redirect_to :root
  end

  def init_exam
    @exam = @user.exams.build
    @exam.subject_id = @subject.id
  end

  def load_user
    return if @user = current_user

    flash[:danger] = t ".you_need_to_login"
    redirect_to :login
  end
end
