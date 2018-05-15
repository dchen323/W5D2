class SubsController < ApplicationController
  before_action :require_log_in, except: [:index, :show ]
  
  def index
    @subs = Sub.all
    render :index
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  def new
    @sub = Sub.new
    render :new
  end
  
  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end 
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end
  
  def update
    @sub = current_user.moderated_subs.find_by(id: params[:id])
    if @sub.nil?
      flash[:notice] = ["You may not edit subs or posts for which you are not the moderator."]
      redirect_to :root
    elsif @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end
  
  private
  
  def sub_params
    params.require(:sub).permit(:title,:description)
  end

end
