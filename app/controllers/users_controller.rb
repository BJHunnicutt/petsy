class UsersController < ApplicationController
  def user
    @user ||= User.find(params[:id].to_i)
  end

  def new
    @user = User.new
  end

  def create

  end

  def index
    @merchants = []

    User.where.not(username: "").find_each do |user|
      if user.products != nil
        @merchants.push(user)
      end
    end
  end

  def show
    user

    if @user.id != session[:user_id]
      redirect_to root_path
    end

    @products = Product.where(user_id: @user.id )
  end

  def edit
    user
  end

  def update
    user.update_attributes(user_params)
    redirect_to user_path(user.id)
  end

  def destroy
    user.destroy
    redirect_to root_path
  end

  def purchase_history
    @user ||= User.find(params[:id].to_i)
    @purchase_orders = Order.where(buyer_id: @user.id).where.not(status: "pending")
  end

  def delete_order
    @order = Order.find(params[:current_order])
    @order.destroy
    redirect_to purchase_history_path(id: session[:user_id])
  end

  def selling_history
    @user ||= User.find(params[:id].to_i)

    #THERE MUST BE ANOTHER WAY!
    #Should this go in the model?
    @sold_orders = []
    Order.where.not(status: "pending").each do |order|
      order.products.each do |product|
        if product.user_id == @user.id
          @sold_orders.push(order)
        end
      end
    end

    @sold_orders = @sold_orders.uniq
  end

  #Is this supposed to go in the model?
  def mark_shipped
    @orderproduct = OrderProduct.find(params[:current_order_product].to_i)
    @orderproduct.shipped = true
    @orderproduct.save

    redirect_to selling_history_path
  end

private
    def user_params
      params.require(:user).permit(:name, :email, :username)
    end
end
