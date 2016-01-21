require 'csv'
DATASTORE = File.expand_path('../datasets/', __FILE__)

namespace :prepare_data do
  def get_sample_file_path(file_name)
    filename_prefix = "mini_proj-"
    filename_extension = ".csv"
    [DATASTORE, '/',filename_prefix, file_name, filename_extension].join('')
  end

  task :user => :environment do
    fpath = get_sample_file_path("users")
    csv_hdlr = File.read(fpath)
    csv = CSV.parse(csv_hdlr, :headers => true)
    csv.each_with_index do |row, i|
        toks = row[0].split
    end
    print DATASTORE
  end
end