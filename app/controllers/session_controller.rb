# frozen_string_literal: true

class SessionController < ApplicationController
  def create
    employee = Employee.find_by(user_name: params[:session][:user_name])
    if employee&.authenticate(params[:session][:password])
      session[:employee_id] = employee.id
      token = generate_jwt_token(employee)
      render json: { employee:, token: }
    else
      render json: { errors: 'Invalid username or password' }, status: :unprocessable_entity
    end
  end

  def destroy
    session[:employee_id] = nil
    render json: { message: 'Logged out successfully' }
  end
end
