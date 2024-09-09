# frozen_string_literal: true

class ApplicationController < ActionController::API
  def current_employee
    @current_employee ||= Employee.find(session[:employee_id]) if session[:employee_id]
  end

  def logged_in?
    !!current_employee
  end

  def generate_jwt_token(employee)
    payload = { employee_id: employee.id }
    JWT.encode(payload, Rails.application.config.secret_key_base, 'HS256')
  end

  def authenticate_with_jwt_token
    token = request.headers['Authorization']
    begin
      payload, = JWT.decode(token, Rails.application.config.secret_key_base, ['HS256'])
      @current_employee = Employee.find(payload['employee_id'])
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
