class ItemSetCommentsController < ApplicationController

  before_filter :require_authentication

  def create
    @item_set = ItemSet.where(:id => params[:item_set_id]).first

    @item_set_comment = ItemSetComment.new
    @item_set_comment.user = current_user
    @item_set_comment.item_set = @item_set
    @item_set_comment.comment = params[:item_set_comment][:comment]

    if @item_set_comment.save
      flash[:success] = "Comment added"
    else
      flash[:danger] = "Failed to create comment, it may be either too long (longer than 2000 characters) or too short (at least 5 characters)"
    end
    redirect_to item_set_path(@item_set)
  end

  def update
    @item_set = ItemSet.where(:id => params[:item_set_id]).first

    @item_set_comment = ItemSetComment.find(params[:id])
    # check for authorization
    if @item_set_comment.user_id != current_user.id
      flash[:danger] = "Unauthorized"
      redirect_to item_set_path(@item_set)
      return
    end

    @item_set_comment.comment = params[:item_set_comment][:comment]
    if @item_set_comment.save
      flash[:success] = "Comment updated"
    else
      flash[:danger] = "Failed to update comment, it may be either too long (longer than 2000 characters) or too short (at least 5 characters)"
    end

    redirect_to item_set_path(@item_set)
  end

  def destroy
    @item_set = ItemSet.where(:id => params[:item_set_id]).first

    @item_set_comment = ItemSetComment.find(params[:id])
    # check for authorization
    if @item_set_comment.user_id != current_user.id
      flash[:danger] = "Unauthorized"
      redirect_to item_set_path(@item_set)
      return
    end

    @item_set_comment.destroy

    flash[:success] = "Comment deleted"

    redirect_to item_set_path(@item_set)
  end

end
