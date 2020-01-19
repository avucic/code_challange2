# frozen_string_literal: true

require 'csv'

namespace :data do
  desc 'Import merchants data from csv file. File must contain header line'
  task :import_merchants, [:path] => :environment do |_t, args|
    raise ArgumentError, 'Missing path to the csv file' unless args[:path]

    Merchant.destroy_all

    CSV.read(args[:path], headers: :first_row).each do |row|
      Merchant.create!(row.to_hash)
    end
  end
end
