class ItemSetsController < ApplicationController

  before_filter :require_authentication, 
    :only => [
      :new, 
      :create, 
      :edit, 
      :update, 
      :edit_children, 
      :destroy, 
      :update_json
    ]

  def index
    @item_sets = ItemSet.where(:visible_to_public => true).page(params[:page])
    @item_sets = @item_sets.order(:updated_at => :desc)
    
    if !params[:champion].blank?
      @item_sets = @item_sets.where(:champion => params[:champion])
    end

    if !params[:role].blank?
      @item_sets = @item_sets.where(:role => params[:role])
    end

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
      redirect_to edit_children_item_set_path(@item_set)
    else
      render 'new'
    end
  end

  def edit
    @item_set = ItemSet.find(params[:id])
    @page_title = "Edit Item Set Metadata"

    # you should only be able to edit item sets you own
    if @item_set.user_id != current_user.id
      flash[:danger] = "Unauthorized action"
      redirect_to item_set_path(@item_set)
    end
  end

  def edit_children
    @item_set = ItemSet.find(params[:id])

    # you should only be able to edit item sets you own
    if @item_set.user_id != current_user.id
      flash[:danger] = "Unauthorized action"
      redirect_to item_set_path(@item_set)
      return
    end

    if @item_set.item_set_json.blank?
      set_data = nil 
    else
      set_data = JSON.parse(@item_set.item_set_json)
    end
    gon.push({
      :authToken => form_authenticity_token,
      :itemSetId => @item_set.id,
      :champion => @item_set.champion,
      :setData => set_data,
      :itemData => Item.item_hash["data"]
    })
  end

  def update
    @item_set = ItemSet.find(params[:id])

    # you should only be able to edit item sets you own
    if @item_set.user_id != current_user.id
      flash[:danger] = "Unauthorized action"
      redirect_to item_set_path(@item_set)
      return
    end

    @item_set.title = params[:item_set][:title]
    @item_set.role = params[:item_set][:role]
    @item_set.visible_to_public = params[:item_set][:visible_to_public]

    if @item_set.save
      flash[:success] = "Successfully updated item set meta data"
      redirect_to item_set_path(@item_set)
    else
      @page_title = "Editing Item Set"
      render 'edit'
    end
  end

  def update_json
    @item_set = ItemSet.find(params[:id])

    # you should only be able to edit item sets you own
    if @item_set.user_id != current_user.id
      render :json => {
        'status' => 'error',
        'error' => 'permission denied'
      }
      return
    end

    @item_set.visible_to_public = true
    @item_set.item_set_json = params[:json]

    if @item_set.save
      render :json => {
        'status' => 'success',
        'input_parameter' => params[:json]
      }
    else
      render :json => {
        'status' => 'error',
        'error' => 'error while saving item_set record'
      }
    end
  end

  def show
    @item_set = ItemSet.where(:id => params[:id]).first
    if @item_set.blank?
      flash[:danger] = "Sorry this item set does not seem to exist, or if it did exist at one point, it was deleted by the owner"
      redirect_to item_sets_path
      return
    end

    @subscription = Subscription.where(:user => current_user, :item_set => @item_set).first

    # for the comment list
    @item_set_comments = @item_set.item_set_comments
    # for the form
    @item_set_comment = @item_set.item_set_comments.new

    if !@item_set.item_set_json.blank?
      @item_set_data = JSON.parse(@item_set.item_set_json)
    else
      @item_set_data = nil
    end

    @page_title = "View Item Set: #{@item_set.display_name}"
  end

  def delete
    @item_set = ItemSet.where(:id => params[:id]).first
    @page_title = "Confirm Deletion #{@item_set.display_name}"
  end


  def destroy
    @item_set = ItemSet.find(params[:id])

    # you should only be able to destroy item sets you own
    if @item_set.user_id != current_user.id
      flash[:danger] = "Unauthorized action"
      redirect_to item_set_path(@item_set)
      return
    end

    @item_set.destroy

    flash[:success] = "This item set has been deleted"
    redirect_to item_sets_path
  end

end
