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
          print("#{id} has already existed")
        end
        print(row)
    end
  end  

  task :user => :environment do
    csv_hdlr = get_csv_hdlr_by_file_name("users")
    parse_content_and_insert_to_db(csv_hdlr) do |toks|
        id = toks[0].to_i
        name = toks[1..-1].join(" ")
        user = User.create(id: id, name: name)
    end
  end


  task :category => :environment do
    csv_hdlr = get_csv_hdlr_by_file_name("categories")
    parse_content_and_insert_to_db(csv_hdlr) do |toks|
        id = toks[0].to_i
        name = toks[1..-1].join(" ")
        user = Category.create(id: id, name: name)
    end
  end

end