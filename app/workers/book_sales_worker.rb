class BookSalesWorker
  include Sidekiq::Worker

  def perform(book_id)
    book = Book.find(book_id)

    puts "I am a Sidekiq Book Sales worker - I started"
    sleep 2
    puts "I am a Sidekiq Book Sales worker - I finished"

    book.update(sales_calculated_at: Time.current)
    book.update(crunching_sales: false)
  end
end
