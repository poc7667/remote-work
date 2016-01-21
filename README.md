# Requirements

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

# Prepare data
## DB setup
- rake db:create # make sure the postgreSQL is ready.
- rake db:migrate
- RAILS_ENV=test rake db:create

## Import Sample Data

    rake prepare_data:user
    rake prepare_data:category
    rake prepare_data:item_and_associations
    rake prepare_data:associations_user_and_items


## Sample usages

    rails c # go to rails console
    #Recommender.get_recommendations(<USER_ID>, <STRATEGY_NAME>)
    Recommender.get_recommendations(35688, "category")
    Recommender.get_recommendations(35688, "user")

# RSPEC

rspec spec/requests/api/v1/recommendations_spec.rb

![inline](https://i.imgur.com/0hbRM2E.png =300x "Title")

# WEB API USAGE

http://133.130.101.114:3000/api/v1/recommendations/35688/category
http://133.130.101.114:3000/api/v1/recommendations/35688/users

http://localhost:3000/api/v1/recommendations/35688/category
http://localhost:3000/api/v1/recommendations/35688/user