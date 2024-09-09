# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :find_employee, only: %i[show show_lr update destroy]
  before_action :authenticate_with_jwt_token, only: %i[update destroy]

  def show
    render json: @employee
  end

  def show_lr
    render json: @employee.leave_requests
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: { errors: @employee.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      render json: @employee
    else
      render json: { errors: @employee.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    render json: { message: 'employee deleted' }
  end

  private

  def employee_params
    params.require(:employee).permit(:user_name, :password)
  end

  def find_employee
    @employee = Employee.find(params[:id])
  end
end
