class ExamsController < ApplicationController
  include SessionsHelper
  before_action :logined_in?
  before_action :load_user, only: %i(index create)
  before_action :load_subject, only: %i(new create)
  before_action :load_questions, :init_exam,
                only: :create
  before_action :load_exam, only: %i(update show)

  def index
    @pagy, @exams = pagy @user.exams.by_key_word_with_relation_tables(params[:query]),
                         items: load_per_page(Settings.paging.per_page_5)
  end

  def new; end

  def show; end

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
    if @subject.questions.count > Settings.exams.number_of_question
      return @questions = @subject.questions.to_a.shuffle![0..9]
    end

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
    @user = current_user
  end

  def exam_params
    params.require(:exam).permit(:user_id, :subject_id, :id)
  end

  def update_details answers
    score = 0
    (0..9).each do |i|
      next unless answer = ExamDetail.find_by(id: answers.dig(i.to_s.to_sym,
                                                              :id))

      answer.selected_answer_id = answers[i.to_s.to_sym][:selected_answer_id]
      answer.save!
      score += 1 if Answer.find_by(id: answer.selected_answer_id)&.true_answer?
      @exam.score = score
    end
  end

  def user_not_correct
    flash[:danger] = t ".user_not_correct"
    redirect_to :root
  end

  def load_exam
    return if @exam = current_user.exams.includes(exam_details: [question: :answers]).find_by(id: params[:id])

    flash[:danger] = t "exam_not_found"
    redirect_to :root
  end
end
