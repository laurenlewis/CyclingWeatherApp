class ItemsController < ApplicationController

before_action :authenticate_user!

def index
 @item = Item.all
end

def new
	@item = Item.new
end

def create
  	@item = Item.new(item_params)
  	if @item.save
  	  flash[:success] = "New item added to your inventory"
  	  redirect_to items_path
  	else
  	  flash[:danger] = "Item not created"
  	  redirect_to items_path
  	end
end

def show
	@items = Item.find(params[:id])
end

def destroy
  Item.find(params[:id]).destroy
  flash[:success] = "Item Removed from Inventory"
  redirect_to items_path
end


private
  	
  	def item_params
  	  params.require(:item).permit(:name, :category, :typeofweather)
  	end

    def correct_user
      @item = current_user.items.find_by(id: params[:id])
      redirect_to root_url if @item.nil?
    end

end