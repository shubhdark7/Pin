class PinsController < ApplicationController
  before_action :set_pin, only: [:edit, :update, :show, :destroy, :upvote]
  before_action :authenticate_user!
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :only_image_or_url, only: [:create]

  def index
    @pins = Pin.all.order("created_at DESC")
    @my_boards = current_user.boards
  end

  def new
    @board = params[:id]
    # if Board.find(@board).nil?
    @pin = current_user.pins.build
    # else
      # redirect_to root_path, notice: "Error occured while creating Pin"
    # end
  end

  def create
    # render plain: params.inspect
    @pin = current_user.pins.build(pin_params)
    if !params[:pin][:url].empty?
        @pin.data_from_url(@pin.url) 
    end
    if @pin.save
      redirect_to pin_path(@pin), notice: "Successfully created new Pin"
    else
      redirect_to new_pin_path(params[:pin][:board_id]), :params => params, :flash => { :error => @pin.errors.full_messages.join(' | ') }
    end
  end

  def edit
    @board = @pin.board.id
  end

  def update
    if @pin.update(pin_params)
      redirect_to pin_path(@pin), notice: "Successfully updated your Pin"
    else
      render 'edit'
    end
  end

  def show
    @my_boards = current_user.boards
  end

  def upvote
    @pin.upvote_by current_user
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @pin.destroy
    redirect_to root_path
  end

  def add_pin
    # render plain: params.inspect
    pin = Pin.find(params[:pin_id])
    @new_pin = Pin.new
    @new_pin.title = params[:title]
    @new_pin.description = params[:description]
    @new_pin.image = pin.image
    @new_pin.url = pin.url
    @new_pin.user = current_user
    @new_pin.board_id = params[:board_id].to_i
    # render plain: @new_pin.inspect
    if @new_pin.save
      redirect_back fallback_location: root_path, notice: "Successfully added Pin"
    else
      redirect_back fallback_location: root_path, notice: "Problem encountered while adding Pin"
    end
  end

  private
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def pin_params
      params.require(:pin).permit(:title, :description, :image, :url, :board_id)
    end

    def require_same_user
      if current_user != @pin.user
        redirect_to root_path
      end
    end
    def only_image_or_url
      if params[:pin].has_key? :image
        if (params[:pin][:url].empty? && params[:pin][:image].nil?) || (!params[:pin][:url].empty? && !params[:pin][:image].nil?)
          # redirect_to root_path, notice: "Error: "
          redirect_back fallback_location: root_path, notice: "Error: Fill only one of the following: Image URL/Image Upload"
        end
      else
        if params[:pin][:url].empty?
          redirect_back fallback_location: root_path, notice: "Error: Fill only one of the following: Image URL/Image Upload" 
        end
      end
    end
end
