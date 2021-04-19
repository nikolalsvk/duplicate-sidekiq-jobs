class BookSalesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "I am an ActiveJob Book Sales job - I started"
    sleep 2
    puts "I am an ActiveJob Book Sales job - I finished"
  end
end
