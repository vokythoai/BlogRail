class DataMailer < ActionMailer::Base

  def send_data_to_user(user_data)
    @get_email = user_data.email
    search_array =  user_data.interest.map{|p| "%"+p+"%"}
    @get_topic = PostData.where("title ILIKE ANY ( array[?] )",search_array).to_a
    mail(from: "ROR", to: user_data.email, subject: "Tin tuc moi")
  end

end