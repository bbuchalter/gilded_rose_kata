def update_quality(items)
  QualityUpdater.new(items).update
end


# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

class QualityUpdater
  def initialize(items)
    @items = items
  end

  attr_reader :items

  def update
    items.each do |item|
      ItemUpdater.new(item).update
    end
  end
end

class ItemUpdater
  def initialize(item)
    @item = item
  end

  attr_reader :item

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def update
    update_quality_for_the_day
    decrement_expiration
    update_quality_for_expired_products if expired?
  end

  def update_quality_for_the_day
    if quality_improves_over_time?
      increment_quality
      handle_accelerated_quality_cases
    else
      decrement_quality
    end
  end

  def update_quality_for_expired_products
    if quality_improves_past_expiration?
      increment_quality
    else
      quality_zeros_past_expiration? ? zero_quality : decrement_quality
    end
  end

  def quality_zeros_past_expiration?
    backstage_passes?
  end

  def quality_improves_past_expiration?
    aged_brie?
  end

  def expired?
    item.sell_in < 0
  end

  def expires?
    !sulfuras?
  end

  def quality_improves_over_time?
    aged_brie? || backstage_passes? || sulfuras?
  end

  def handle_accelerated_quality_cases
    if backstage_passes?
      if item.sell_in < 11
        increment_quality
      end
      if item.sell_in < 6
        increment_quality
      end
    end
  end

  def sulfuras?
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def aged_brie?
    item.name == "Aged Brie"
  end

  def backstage_passes?
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def has_quality?
    item.quality > 0
  end

  def zero_quality
    item.quality = item.quality - item.quality
  end

  def decrement_expiration
    item.sell_in -= 1 if expires?
  end

  def increment_quality
    item.quality += 1 if item.quality < MAX_QUALITY
  end

  def decrement_quality
    item.quality -= 1 if item.quality > MIN_QUALITY && expires?
  end
end
