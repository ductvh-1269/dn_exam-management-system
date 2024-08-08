class Admin::SubjectsController < AdminController
  def new
    @subject = Subject.new
  end

  def create
    @subject = @current_user.subjects.build subject_params
    if @subject.save
      flash[:info] = t ".create_noti"
      redirect_to @subject
    else
      flash.now[:danger] = t ".create_failed"
      render :new
    end
  end

  private

  def subject_params
    params.require(:subject).permit :name, :content
  end
end
