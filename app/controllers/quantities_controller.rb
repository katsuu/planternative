class QuantitiesController < ApplicationController
before_action :find_quantity, only: [ :update, :destroy ]

  def create
    @product = Product.find(params[:product_id])
    @quantity = Quantity.new(quantity_params)
    @quantity.product = @product
    @shopping_list = ShoppingList.find_by(mark_as_done: false, user: current_user) || ShoppingList.create(user: current_user, date: Date.today, mark_as_done: false)
    @quantity.shopping_list = @shopping_list
    if @quantity.save
      redirect_to product_path(@product)
    else
      render "products/show"
    end
  end

  def update
    @shopping_list = ShoppingList.find_by(mark_as_done: false, user: current_user) || ShoppingList.create(user: current_user, date: Date.today, mark_as_done: false)
    @quantity.update(quantity_params)
    if @quantity.save
      redirect_to shopping_list_path(@shopping_list)
    else
      render "shopping_lists/show"
    end
  end

  def destroy
    @quantity.destroy
    @shopping_list = ShoppingList.find_by(mark_as_done: false, user: current_user) || ShoppingList.create(user: current_user, date: Date.today, mark_as_done: false)
    redirect_to shopping_list_path(@shopping_list)
  end

  private

  def find_quantity
    @quantity = Quantity.find(params[:id])
  end

  def quantity_params
    params.require(:quantity).permit(:quantity)
  end
end
