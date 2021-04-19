class Merchants::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoice_items = InvoiceItem.by_merchant(@merchant)
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @invoice_items = InvoiceItem.invoice_items_details(@invoice)
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(user_params)
    redirect_to merchant_invoice_path(invoice)
  end

  private

  def user_params
    params.require(:invoice).permit(:status)
  end
end
