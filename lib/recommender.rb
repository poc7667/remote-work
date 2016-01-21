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

  def _get_recommendations_by_ids
    self.recommendations = Item.where(id: recommendations - user.items.pluck(:id))
    self.recommendations
  end

end

class RecommenderByCategory < RecommenderBase

  def get_recommendations
    prepare_uniq_bought_items_and_categories
    self.recommendations = @categories.inject([]) do |h, cate_id|
      h << Category.find(cate_id).items.pluck(:id)
      h
    end.flatten
    _get_recommendations_by_ids
  end

  private
    def prepare_uniq_bought_items_and_categories
      @categories = []
      user.items.each do |item|
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
    self.recommendations = get_similar_user_ids.inject([]) do |h, user_id|
      h << User.find(user_id).items.pluck(:id)
      h.flatten.uniq
      h
    end.flatten
    _get_recommendations_by_ids
  end

  private
    def get_similar_user_ids
      user.items.inject([]) do |h, item|
        item.users
        h << item.users.pluck(:id)
        h
      end.flatten.uniq
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