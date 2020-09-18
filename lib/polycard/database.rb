require 'sequel'

DATABASE_NAME = 'cards' unless defined? DATABASE_NAME
DB = Sequel.postgres(DATABASE_NAME)

class Deck < Sequel::Model(DB[:deck])
  one_to_many :cards
end

class Card < Sequel::Model(DB[:card])
  one_to_many :sides

  def next
    Card.where do |o|
      o.id > id
    end.first
  end
end

module WithPK
  attr_accessor :pk
end

class Side < Sequel::Model(DB[:side])
  many_to_one :card

  def self.with_pk!(pk)
    super
  rescue Sequel::NoMatchingRow => e
    e.extend(WithPK)
    e.pk = pk
    raise e
  end

  # @return [Side] the next side in the same card
  def next
    next_side = card.sides_dataset.where do |o|
      o.id > id
    end.first

    return next_side unless next_side.nil?

    next_card = card.next
    return nil if next_card.nil?

    next_card.sides_dataset.first
  end
end
