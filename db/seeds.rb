User.create!(
  first_name: "admin",
  last_name: "admin",
  email: "admin@gmail.com",
  password: "123123",
  password_confirmation: "123123",
  role: 0
)
User.create!(
  first_name: "user",
  last_name: "user",
  email: "user@gmail.com",
  password: "123123",
  password_confirmation: "123123",
  role: 1
)
10.times do |n|
  subject_name = "Môn học của " + Faker::Name.name
  Subject.create!(
    user_id: User.first.id,
    content: "Đây là content thứ #{n+1}",
    name: subject_name
  )
end
10.times do |n|
  subject_name = "Môn học của " + Faker::Name.name
  user_id = 1
  Subject.create!(
    user_id: User.first.id,
    content: "Đây là content thứ #{n+1}",
    status: false,
    name: subject_name
  )
end
50.times do |n|
  user_id = n%2 + 1
  Exam.create!(
    user_id: user_id,
    subject_id: (n + 1),
    spent_time: 120,
    score: n%11
  )
end
