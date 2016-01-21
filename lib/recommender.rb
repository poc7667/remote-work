class RecommenderBase
  attr_accessor :user_id, :user, :recommendations
  def initialize(user_id)
    self.user_id = user_id
    self.user = User.find(user_id)
    self.recommendations = []
  end
  def get_recommendations
    raise NotImplementedError.new __callee__    
  end

end

class RecommenderByCategory < RecommenderBase

  def get_recommendations
    prepare_uniq_bought_items_and_categories
    recommendations = @categories.inject([]) do |h, cate_id|
      h << Category.find(cate_id).items.pluck(:id)
      h
    end.flatten
    self.recommendations = Item.where(id: recommendations - @bought_items)
  end

  def prepare_uniq_bought_items_and_categories
    @categories = []
    @bought_items = []
    user.items.each do |item|
      @bought_items << item.id
      @categories << item.categories.inject([]) { |h, cate|
        h << cate.id
        h
      }.flatten
    end
    @categories.flatten!
    @categories.uniq!
  end  
end

class RecommenderByUser < RecommenderBase
  def get_recommendations
  end
end

class Recommender
  def self.get_recommendations(user_id, strategy=nil)
    case strategy
      when "category"
        RecommenderByCategory.new(user_id).get_recommendations
      when "user"
        RecommenderByUser.new(user_id).get_recommendations
      else
        print("\ninvalid strategy name, it will return ByCategory strategy")
        RecommenderByCategory.new(user_id).get_recommendations
    end
  end
end