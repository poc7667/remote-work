# Demo

- Sample server: 133.130.101.114
- Database: postgreSQL
- Request format: http://<SERVER>/api/v1/recommendations/<USER_ID>/<STRATEGY_NAME>
- Response format: `[{item_id, categories:[ids], ..., {}]`
    - http://133.130.101.114:3000/api/v1/recommendations/35688/category
        - user_id: 35688
        - strategy: category
    - http://133.130.101.114:3000/api/v1/recommendations/35688/users
        - user_id: 35688
        - strategy: users

# Introduction(What I've done)


- import sample data function (parse csv and import it to DB) (.//lib/tasks/prepare_data.rake)
    - design pattern: Template method, Factory method
    - comment: it seems the requirement ask me to create a custom object to handler the recommendation function, so, I am used to putting custom object here
- about the 2nd strategy, I think we could use `collaborative filtering algorithm` , I've tried that once, it can give us the most similiar users' items, just by sorting the calculated scores.
- capistrano deploy script
- rspec test scripts
- api controller only respond JSON format

## About the scaling issues

The `sharding`, `1 master Many slaves model`, `cache` methodoligies came into my mind at the first place.

For the `similar categories` recommendation strategy, I think we could use `cache` to accelerate. Because, the `categories` supposed not to increase in a millions scale. We can easily use Redis or some memory cache techniques to accelerate the most common queries.

About the database infrastructure design, I tend to use `sharding` for this case. 

All the queries are coming with `user_id`

Suppose I have 26 servers I'd like to put Adam, Alan, Alex, ..., users' name having 'a' in the first letter. I will store them in <server A cluster>, and Bill, Brandon, ..., will be sotred at <server B cluster>. Ideally, when the number of users is big enough it should be 26x speed than before.

Also, we could use **1 master Many slaves** model, becuase I think in this case, the read requests is much more than write. So the read requests will be bottleneck.

## Knowledge about Ruby and RoR
- has_and_belongs_to_many association
- use `pluck` to avoid heavy Rails Active Record operations.
- Block, Lambda, iterate injection, try exception
- customized JSON responsewith jBuilder
- Rspec for test API requests
- metaprograming, monkey patch

# Launch Project

## DB setup
    - bundle install # install necessary gems
    - rake db:create # make sure the postgreSQL is ready.
    - rake db:migrate
    - RAILS_ENV=test rake db:create

## Import Sample Data

    - rake prepare_data:user
    - rake prepare_data:category
    - rake prepare_data:item_and_associations
    - rake prepare_data:associations_user_and_items

## Sample usages

    rails c # go to rails console
    #Recommender.get_recommendations(<USER_ID>, <STRATEGY_NAME>)
    Recommender.get_recommendations(35688, "category")
    Recommender.get_recommendations(35688, "user")
    #=> #<ActiveRecord::Relation [#<Item id: 1217,created_at: "2016-01-21 08:29:23", updated_at: "2016-01-21 08:29:23">, #<Item id: 1220,created_at: "2016-01-21 08:29:23", updated_at: "2016-01-21 08:29:23">, #<Item id: 1242,created_at: "2016-01-21 08:29:23", updated_at: "2016-01-21 08:29:23">, #<Item id: 1266,created_at: "2016-01-21 08:29:23", updated_at: "2016-01-21 08:29:23">, #<Item id: 1270,created_at: "2016-01-21 08:29:23", updated_at: "2016-01-21 08:29:23">, #<Item id: 1272,created_at: "2016-01-21 08:29:23", updated_at: "2016-01-21 08:29:23">, #<Item id: 1286,created_at: "2016-01-21 08:29:24", updated_at: "2016-01-21 08:29:24">, #<Item id: 1290,created_at: "2016-01-21 08:29:24", updated_at: "2016-01-21 08:29:24">, #<Item id: 1292,created_at: "2016-01-21 08:29:24", updated_at: "2016-01-21 08:29:24">, #<Item id: 1294,created_at: "2016-01-21 08:29:24", updated_at: "2016-01-21 08:29:24">, ...]>

# Test 

Test webapi, for the two strategies

    rspec spec/requests/api/v1/recommendations_spec.rb

![inline](https://i.imgur.com/0hbRM2E.png =300x "Title")

# Assignment Requirements

RS Mini Project: Recommenders

Notes:

Approximate time: 3-4 hours
5 Files are attached that you can load for testing (tab-separated: users, items, categories, categories_items, orders)
Requirements: Write 2 different recommender strategy classes. Your classes/objects should accomplish the following goals:

Given a user_id and a recommendation strategy, return an item recommendation for the user
Write test coverage for your code
Other tips:

There should be a clear interface to using your recommendation classes
Do pay attention to organization, formatting, syntax, code quality. This should be assumed to be production-ready code.
Design the code so that in the future it is easy to add additional recommender strategies
Use good OOP Principles and design patterns where relevant
Think about scale. What if there are millions of users and millions of orders?

## Recommendation Class 1

Category Recommender Based on the purchased items, 

recommend items that most closely related based on the **category similarity**. 

Must have at **least 1 category** in common. Must not have already been purchased by the user.

### Example

- Item 1 is "Nike Dunks" with **categories "Shoes", "Basketball", and "Nike"**
- Item 2 is "Nike Street Basketball" with **categories "Balls", "Basketball" and "Nike"**
- Item 3 is "Addidas Jersey" with **categories "Clothing", "Basketball", and "Addidas"**
- Item 4 is "Golf bag" with **categories "Golf", "Accessories"**

If user purchased item1, then they should be recommended item 2, item 3

## Recommendation Class 2 

Similar Users Recommend items that other users with similar purchases have ordered.

### Example 

- **UserA** ordered "Nike Dunks" 
- **UserB** ordered "Nike Dunks" and "Nike Street Basketball" 
- **UserC** ordered "Nike Street Basketball" and "Golf bag"

The recommender should recommend 

- "Nike Street Basketball" for **UserA**
- "Golf bag" for **UserB**
- "Nike Dunks" for **UserC**
