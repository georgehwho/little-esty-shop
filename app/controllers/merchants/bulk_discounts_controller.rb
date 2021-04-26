class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])

    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)

    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path
    else
      redirect_to new_merchant_bulk_discount_path
      flash[:error] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :percent_discount, :threshold)
  end
end