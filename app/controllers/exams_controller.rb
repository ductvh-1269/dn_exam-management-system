class ExamsController < ApplicationController
  include SessionsHelper
  before_action :load_subject, only: %i(new create)
  before_action :load_user, :load_questions, :init_exam,
                only: :create
  before_action :load_exam, only: :update

  def new; end

  def update
    answers = params[:exam][:exam_details_attributes]

    begin
      ActiveRecord::Base.transaction do
        update_details answers
        @exam.save!
      end
      flash[:success] = t ".exam_done"
    rescue StandardError => e
      flash[:danger] = e
    ensure
      redirect_to :root
    end
  end

  def create; end

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

  def build_exam; end

  def init_exam
    @exam = @user.exams.build
    @exam.subject_id = @subject.id
    ExamDetail.transaction do
      @exam.save!
      @questions.each do |q|
        detail = @exam.exam_details.build
        detail.question_id = q.id
        detail.save!
      end
    rescue StandardError
      flash[:danger] = t ".have_an_error"
      redirect_to :root
    end
  end

  def load_user
    return if @user = current_user

    flash[:danger] = t ".you_need_to_login"
    redirect_to :login
  end

  def exam_params
    params.require(:exam).permit(:user_id, :subject_id, :id)
  end

  def update_details answers
    score = 0;
    (0..9).each do |i|
      next unless answer = ExamDetail.find_by(id: answers.dig(i.to_s.to_sym,
                                                              :id))

      answer.selected_answer_id = answers[i.to_s.to_sym][:selected_answer_id]
      answer.save!
      score +=1 if correct_answer = Answer.find(answer.selected_answer_id).is_correct
      @exam.score = score
    end
  end

  def user_not_correct
    flash[:danger] = t ".user_not_correct"
    redirect_to :root
  end

  def load_exam
    return if @exam = current_user.exams.find_by(id: params[:id])
      flash[:danger] = t "exam_not_found"
      redirect_to :root
  end
end
