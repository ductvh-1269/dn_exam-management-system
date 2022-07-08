module ExamsHelper
  def generate_question_content index, content
    t "exams.show.question #{index + 1}: #{content}"
  end

  def load_exam_path user
    return :admin_exams if user&.admin?

    :exams
  end

  def load_exam_details_path user
    user&.admin? ? :admin_exam_path : :exam_path
  end

  def load_search_path user
    user&.admin? ? :admin_search : :search
  end

  def load_user_name exam
    "#{exam.user.first_name} #{exam.user.last_name}"
  end

  def generate_string first, last
    "#{first}: #{last}"
  end

  def choose_answer answer_id, exam_details
    exam_details.selected_answer_id == answer_id
  end

  def content_for_span exam_details
    if Answer.find_by(id: exam_details.selected_answer_id)&.true_answer?
      {value: t(".correct"), class: "badge badge-pill badge-success"}
    else
      {value: t(".incorrect"), class: "badge badge-pill badge-danger"}
    end
  end
end
