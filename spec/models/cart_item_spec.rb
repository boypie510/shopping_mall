require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe "購物車基本功能" do
    it "每個 Cart Item 都可以計算它自己的金額（小計）" do
      cart = Cart.new
      p1 = Product.create(title: "iPhone", price: "100")
      p2 = Product.create(title: "iPad", price: "200")

      3.times { cart.add_item(p1.id) }
      2.times { cart.add_item(p2.id) }

      expect(cart.items.first.price).to be 300
      expect(cart.items.second.price).to be 400
    end
  end
end
