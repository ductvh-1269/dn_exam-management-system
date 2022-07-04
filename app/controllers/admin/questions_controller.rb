class Admin::QuestionsController < AdminController
  before_action :load_subject, only: :create
  def new
    @question = Question.new
  end

  def create
    @question = @subject.questions.build question_params
    flag = at_least_a_true_answer.call(@question.answers)
    unless flag
      flash[:danger] = t ".must_a_true_answer"
      redirect_to new_admin_subject_question_path
      return
    end
    if @question.save
      flash[:info] = t ".create_question_successed"
      redirect_to root_path
    else
      flash.now[:danger] = t ".create_question_failed"
      render :new
    end
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

  def at_least_a_true_answer
    lambda do |question|
      question.each do |i|
        return true if i.true_answer?
      end
      return false
    end
  end
end
