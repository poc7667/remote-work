require 'csv'
DATASTORE = File.expand_path('../datasets/', __FILE__)

namespace :prepare_data do
  def get_sample_file_path(file_name)
    filename_prefix = "mini_proj-"
    filename_extension = ".csv"
    [DATASTORE, '/',filename_prefix, file_name, filename_extension].join('')
  end

  def get_csv_hdlr_by_file_name(fname)
    fpath = get_sample_file_path(fname)
    File.read(fpath)
  end

  def get_clean_toks(raw_toks)
    raw_toks.map(&:strip)
  end

  def parse_content_and_insert_to_db(csv_hdlr, &block)
    data = []
    CSV.parse(csv_hdlr, :headers => true).each do |row|
        begin
          toks = get_clean_toks(row[0].split)
          block.call(toks)
        rescue ActiveRecord::RecordNotUnique
          print("#{row} has already existed")
        end
        print(row)
    end
  end

  def create_category_item_association(item, categories)
    if categories.count > 0
      categories.each do |category|
        item.categories << category
      end
    end
  end

  task :user => :environment do
    csv_hdlr = get_csv_hdlr_by_file_name("users")
    parse_content_and_insert_to_db(csv_hdlr) do |toks|
        id = toks[0].to_i
        name = toks[1..-1].join(" ")
        User.create(id: id, name: name)
    end
  end

  task :category => :environment do
    csv_hdlr = get_csv_hdlr_by_file_name("categories")
    parse_content_and_insert_to_db(csv_hdlr) do |toks|
        id = toks[0].to_i
        name = toks[1..-1].join(" ")
        Category.create(id: id, name: name)
    end
  end

  task :item_and_associations => :environment do
    csv_hdlr = get_csv_hdlr_by_file_name("categories_items")
    parse_content_and_insert_to_db(csv_hdlr) do |toks|
        id = toks[0].to_i
        category_id = toks[1].to_i
        item = Item.create(id: id)
        categories = Category.where(id:category_id)
        create_category_item_association(item, categories)
    end
  end  

end