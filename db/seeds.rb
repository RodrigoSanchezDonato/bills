# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'open-uri'
require 'nokogiri'

puts 'creating database'

def scraper

  url = 'https://sapl.camaranh.rs.gov.br/sistema/search/?q=projeto+de+lei&models=materia.materialegislativa'

  doc = Nokogiri::HTML(open(url))

  # to pick all 10 item in a page:
  listings = doc.search('table.table-striped.table-bordered td p')

  page = 1

  per_page = listings.count # 10 per page
  total = doc.search('table.table-striped.table-bordered td h3').text.split(' ').last.to_i # 72320 total of items
  last_page = (total.to_f / per_page.to_f).round # total of pages
  bills = []

  while page <= last_page
    pagination_url = "https://sapl.camaranh.rs.gov.br/sistema/search/?q=projeto%20de%20lei&page=#{page}&models=materia.materialegislativa" # url when pagination is changed, so it receive the page number while looping in order to loop through each page

    puts pagination_url
    puts "Page: #{page}"
    puts ''
    pagination_doc = Nokogiri::HTML(open(pagination_url))

    # to pick all the 10 items per page
    pagination_ptext = pagination_doc.search('table.table-striped.table-bordered td p')

    pagination_ptext.each do |element|

      bills << element.text

      puts "added element #{element.text}"
      puts ''
    end
    page += 1
  end

  bills.count
end

p scraper

puts 'done'
