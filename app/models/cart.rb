class Cart
  attr_reader :items

  def initialize(items = [])
    @items = items
  end

  def add_item(product_id)
    found_item = items.find { |item| item.product_id == product_id }
    
    if found_item
      found_item.increment
    else
      @items << CartItem.new(product_id)
    end
  end

  def empty?
    @items.empty?
  end

  def total_price(discount = 1)
    total_price = @items.reduce(0) { |total_price, item| total_price + item.price }
    if discount == "xmas"
      ratio = 0.9
    elsif (total_price / 1000) >= 1
      total_price = total_price - 100 * (total_price / 1000)
      ratio = 1
    else 
      ratio = 1
    end
    discount_price = total_price * ratio
  end

  def serialize
    all_items = items.map { |item| 
      {"product_id" => item.product_id, "quantity" => item.quantity}
    }

    { "items" => all_items }
  end

  def self.from_hash(hash)
    if hash.nil?
      new []
    else
      new hash["items"].map { |item_hash|
        CartItem.new(item_hash["product_id"], item_hash["quantity"])
      }
    end
  end
end