class ItemsController < ApplicationController


def index
 @items = Item.all
end

def new
	@item = Item.new
end

def create
  	@item = Item.new(item_params)
  	if @item.save
  	  flash[:success] = "New item added to your inventory"
  	  redirect_to root_url
  	else
  	  flash[:danger] = "Item not created"
  	  redirect_to item_path
  	end
end

def show
	@items = Item.find(params[:id])
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