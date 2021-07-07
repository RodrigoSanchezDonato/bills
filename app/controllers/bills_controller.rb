require 'Nokogiri'
require 'open-uri'
class BillsController < ApplicationController

  def show
    @bill = Bill.find(params[:id])
  end

  def index
    @bills = Bill.all
  end

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

    while page <= 1
      pagination_url = "https://sapl.camaranh.rs.gov.br/sistema/search/?q=projeto%20de%20lei&page=#{page}&models=materia.materialegislativa" # url when pagination is changed, so it receive the page number while looping in order to loop through each page

      # puts pagination_url
      # puts "Page: #{page}"
      # puts ''
      pagination_doc = Nokogiri::HTML(open(pagination_url))

      # to pick all the 10 items per page
      pagination_ptext = pagination_doc.search('table.table-striped.table-bordered td p')

      pagination_ptext.each do |element|

        puts element.search('a').attr("href")


        bills << element.text

        bill = Bill.new
        bill.description = element.text
        bill.title = element.search('a').attr("href")
        bill.save

        # puts bill.description
      end
      page += 1
    end

    bills.count
    redirect_to bills_path
  end

  # p scraper

  # puts 'done'


    end
