class OrderProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    return product.price*quantity
  end

end
