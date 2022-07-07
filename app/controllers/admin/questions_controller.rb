class Admin::QuestionsController < AdminController
  before_action :load_subject, only: %i(create update)
  before_action :load_question, only: %i(edit update destroy)
  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = @subject.questions.build question_params
    flag = at_least_a_true_answer.call(@question.answers)
    return if check_at_least_a_true_answer flag

    if @question.save
      flash[:info] = t ".create_question_successed"
      redirect_to new_admin_subject_question_path
    else
      flash.now[:danger] = t ".create_question_failed"
      render :new
    end
  end

  def update
    ActiveRecord::Base.transaction do
      update_false_answer
      @question.update!(question_params)
      flag = at_least_a_true_answer.call(@question.answers)
      raise StandardError unless flag
    end
    flash[:success] = t ".update_successed"
    redirect_to subject_path(@subject.id)
  rescue StandardError
    flash[:danger] = t ".must_a_true_answer"
    redirect_to edit_admin_subject_question_path
  end

  def destroy
    if @question.destroy
      flash[:success] = t ".delete_successed"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def question_params
    params.require(:question)
          .permit(:content, answers_attributes: [:id, :content,
                                                 :is_correct, :_destroy])
  end

  def load_subject
    return if @subject = Subject.find_by(id: params[:subject_id])

    flash[:danger] = t ".resource_not_found"
    redirect_to :root
  end

  def load_question
    return if @question = Question.find_by(id: params[:id])

    flash[:danger] = t ".resource_not_found"
    redirect_to :root
  end

  def at_least_a_true_answer
    lambda do |question|
      question.each do |i|
        return true if i.true_answer?
      end
      return false
    end
  end

  def check_at_least_a_true_answer flag
    return if flag

    flash[:danger] = t ".must_a_true_answer"
    redirect_to new_admin_subject_question_path
  end

  def update_false_answer
    @question.answers.each do |i|
      i.update! is_correct: :false_answer
    end
  end
end
