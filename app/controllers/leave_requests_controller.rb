# frozen_string_literal: true

class LeaveRequestsController < ApplicationController
  before_action :find_lr, only: %i[show view_lr update update_status destroy]
  before_action :authenticate_with_jwt_token, only: %i[show create update destroy]

  def show
    render json: @leave_request
  end

  def index
    @leave_requests = LeaveRequest.all
    render json: @leave_requests
  end

  def view_lr
    days = (@leave_request.end_date + 1 - @leave_request.start_date).to_i
    (@leave_request.start_date..@leave_request.end_date).each do |date|
      days -= 1 if date.saturday? || date.sunday?
    end

    approval = if @leave_request.approval.nil?
                 'pending'
               elsif @leave_request.approval == true
                 'Approved'
               else
                 'Rejected'
               end
    render json: {
      "employee": @leave_request.employee.user_name,
      id: @leave_request.id,
      "days requested for leave": days,
      "leave request status": approval
    }
  end

  def create
    @leave_request = LeaveRequest.new(leave_request_params)
    @leave_request.employee = @current_employee
    if @leave_request.save
      render json: @leave_request
    else
      render json: @leave_request.errors.full_messages
    end
  end

  def update
    if @leave_request.update(leave_request_params)
      render json: { message: 'Leave updated' }
    else
      render json: @leave_request.errors.full_messages
    end
  end

  def update_status
    @leave_request.update(approval: params[:approval])
    render json: { message: 'request status updated.' }
  end

  def destroy
    @leave_request.destroy
    render json: { message: 'leave request deleted' }
  end

  private

  def find_lr
    @leave_request = LeaveRequest.find(params[:id])
  end

  def leave_request_params
    params.require(:leave_request).permit(:start_date, :end_date)
  end
end
