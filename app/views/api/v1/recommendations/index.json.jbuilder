json.array!(@recommendations) do |f|
  json.item_id f.id
  json.categories f.categories do |category|
    json.id category.id
  end
end