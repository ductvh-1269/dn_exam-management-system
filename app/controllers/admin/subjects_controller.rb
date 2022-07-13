class Admin::SubjectsController < AdminController
  before_action :load_subject, only: %i(export destroy)
  before_action :check_empty_answer, only: :export

  def new
    @subject = Subject.new
  end

  def create
    @subject = @current_user.subjects.build subject_params
    if @subject.save
      flash[:info] = t ".create_success"
      redirect_to @subject
    else
      flash.now[:danger] = t ".create_failed"
      render :new
    end
  end

  def destroy
    if @subject.destroy
      flash.now[:success] = t ".delete_successed"
    else
      flash.now[:danger] = t ".delete_failed"
    end
  end

  def export
    respond_to do |format|
      format.pdf do
        render pdf: @subject.id.to_s,
               page_size: Settings.pdf.page_size_a4,
               template: "subjects/export.html.erb",
               layout: "pdf.html",
               encoding: Settings.pdf.encoding,
               lowquality: true,
               dpi: Settings.pdf.dpi_75
      end
    end
  end

  private

  def subject_params
    params.require(:subject).permit :name, :content
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject

    flash[:danger] = t(".find_failed")
    redirect_to root_path
  end

  def check_empty_answer
    return if @subject.questions.size >= 1

    flash[:danger] = t(".require_questions")
    redirect_to subjects_path
  end
end
