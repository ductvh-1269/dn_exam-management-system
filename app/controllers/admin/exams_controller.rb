class Admin::ExamsController < AdminController
  before_action :load_exam, only: %i(show)
  def index
    query = params[:query]
    size = load_per_page Settings.exams.exams_per_page_5
    result = Exam.by_key_word_with_relation_tables query
    @pagy, @exams = pagy(result, items: size)
  end

  def show
    render :template => 'exams/show'
  end

  private
  def load_exam
    return if @exam = Exam.find_by(id: params[:id])
    flash[:danger] = t ".exam_not_found"
    redirect_to :admin_exams
  end
end
