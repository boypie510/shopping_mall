require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "購物車基本功能" do
    it "可以把商品丟到到購物車裡，然後購物車裡就有東西了" do
      cart = Cart.new 
      cart.add_item 1
      expect(cart.empty?).to be false
    end
    it "如果加了相同種類的商品到購物車裡，購買項目（CartItem）並不會增加，但商品的數量會改變" do
      cart = Cart.new
      3.times { cart.add_item(1) }
      5.times { cart.add_item(2) }
      2.times { cart.add_item(3) }

      expect(cart.items.length).to be 3
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.second.quantity).to be 5
    end
    it "商品可以放到購物車裡，也可以再拿出來" do 
      cart = Cart.new
      p1 = Product.create(title: "iPhone")
      p2 = Product.create(title: "iPad")

      3.times { cart.add_item(p1.id) }
      2.times { cart.add_item(p2.id) }

      expect(cart.items.first.product_id).to be p1.id
      expect(cart.items.second.product_id).to be p2.id
      expect(cart.items.first.product).to be_a Product
    end
    it "可以計算整台購物車的總消費金額" do
      cart = Cart.new
      p1 = Product.create(title: "iPhone", price: "100")
      p2 = Product.create(title: "iPad", price: "200")

      3.times { cart.add_item(p1.id) }
      2.times { cart.add_item(p2.id) }

      expect(cart.total_price).to be 700
    end
    it "特別活動可能可搭配折扣（例如聖誕節的時候全面打 9 折，或是滿額滿千送百）" do
      cart = Cart.new
      p1 = Product.create(title: "iPhone", price: "100")
      p2 = Product.create(title: "iPad", price: "200")

      3.times { cart.add_item(p1.id) }
      10.times { cart.add_item(p2.id) }

      expect(cart.total_price("xmas")).to be 2300 * 0.9
      expect(cart.total_price).to be 2100
    end
  end

  describe "購物車進階功能" do
    it "可以將購物車內容轉換成 Hash，存到 Session 裡" do
      cart = Cart.new
      5.times { cart.add_item(3) }
      7.times { cart.add_item(4) }

      expect(cart.serialize).to eq session_hash
    end
    it "可以把 Session 的內容（Hash 格式），還原成購物車的內容" do
      cart = Cart.from_hash(session_hash)
      
      expect(cart.items.first.product_id).to be 3
      expect(cart.items.first.quantity).to be 5
      expect(cart.items.second.product_id).to be 4
      expect(cart.items.second.quantity).to be 7
    end
  end

  private
  def session_hash
    {
      "items" => [
        {"product_id" => 3, "quantity" => 5},
        {"product_id" => 4, "quantity" => 7}
      ]
    }
  end
end
