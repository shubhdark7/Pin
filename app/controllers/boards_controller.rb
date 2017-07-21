class BoardsController < ApplicationController
  before_action :set_pin, only: [:edit, :update, :show, :destroy]
  before_action :authenticate_user!
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @boards = current_user.boards.order("created_at DESC")
  end

  def new
    @board = current_user.boards.build
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to board_path(@board), notice: "Successfully created new Board"
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @board.update(board_params)
      redirect_to board_path(@board), notice: "Successfully updated your Board"
    else
      render 'edit'
    end
  end

  def show
    @pins = @board.pins.order("created_at DESC")
    @my_boards = current_user.boards
  end

  def destroy
    @board.destroy
    redirect_to root_path
  end

  private
    def set_pin
      @board = Board.find(params[:id])
    end

    def board_params
      params.require(:board).permit(:name)
    end

    def require_same_user
      if current_user != @board.user
        redirect_to root_path
      end
    end
end
