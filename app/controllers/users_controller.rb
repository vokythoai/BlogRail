  class UsersController < ApplicationController


  load_and_authorize_resource

  def update
    @user.interest = [].to_json
    params[:user][:interest].split(",").each do |i|
      @user.interest.to_a << i
      @user.save
    end


    if @user
      flash[:notice] = "success"
      redirect_to users_path()
    else
      flash[:notice] = "error"
      redirect_to users_path()
    end

    DataMailer.send_data_to_user(@user).deliver_now
  end


  private

    def user_params
      params.require(:user).permit(:interest)
    end
end
