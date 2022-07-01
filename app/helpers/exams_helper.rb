module ExamsHelper
  def generate_question_content index, content
    t "exams.show.question #{index + 1}: #{content}"
  end

  def load_exam_path user
    user&.admin? ? :admin_exams : :exams
  end

  def load_user_name exam
    exam.user.first_name + " " + exam.user.last_name
  end

  def generate_string first, last
    "#{first}: #{last}"
  end

  def choose_answer answer_id, exam_details
    return exam_details.selected_answer_id == answer_id
  end

  def choose_answer_correct? exam_details
    return Answer.find_by(id: exam_details.selected_answer_id)&.is_correct == 1
  end

end
