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
      redirect_to item_set_path(@item_set)
    end
  end

  def edit
    @item_set = ItemSet.find(params[:id])
    @page_title = "Edit Item Set"

    # you should only be able to edit item sets you own
    if @item_set.user_id != current_user.id
      flash[:danger] = "Unauthorized action"
      redirect_to item_set_path(@item_set)
    end
  end

  def update
    @item_set = ItemSet.find(params[:id])

    # you should only be able to edit item sets you own
    if @item_set.user_id != current_user.id
      flash[:danger] = "Unauthorized action"
      redirect_to item_set_path(@item_set)
    end
  end

  def show
    @item_set = ItemSet.find(params[:id])

    @page_title = "View Item Set: #{@item_set.title}"
  end

  def destroy
    @item_set = ItemSet.find(params[:id])

    # you should only be able to destroy item sets you own
    if @item_set.user_id != current_user.id
      flash[:danger] = "Unauthorized action"
      redirect_to item_set_path(@item_set)
    end

    @item_set.destroy

    flash[:success] = "This item set has been deleted"
    redirect_to items_set_path
  end

end
