class ItemsController < ApplicationController

def new
	@item = Item.new
end

def create
  	@item = current_user.items.build(item_params)
  	if @item.save
  	  flash[:success] = "New item added to your inventory"
  	  redirect_to root_url
  	else
  	  flash[:danger] = "Item not created"
  	  redirect_to item_path
  	end
end

def show
	# @items = @user.items(params[:id])
end


private
  	
  	def item_params
  	  params.require(:item).permit(:name, :category, :typeofweather)
  	end


end