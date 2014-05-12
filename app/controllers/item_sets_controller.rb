class ItemSetsController < ApplicationController

  before_filter :require_authentication, :only => [:new, :create, :edit, :update]

  def index
    @item_sets = ItemSet.all

    @page_title = "Browse Item Sets"
  end

  def new
    @item_set = ItemSet.new

    @page_title = "Create New Item Set"
  end

  def create
    @item_set = ItemSet.new

    @item_set.title = params[:item_set][:title]
    @item_set.champion = params[:item_set][:champion]
    @item_set.role = params[:item_set][:role]
    @item_set.user = current_user

    if @item_set.save
      flash[:success] = "Succesfully created the item set"
      redirect_to 
    end
  end

  def edit
    @item_set = ItemSet.find(params[:id])

    @page_title = "Edit Item Set"
  end

  def show
    @item_set = ItemSet.find(params[:id])

    @page_title = "View Item Set: #{@item_set.title}"
  end

end
