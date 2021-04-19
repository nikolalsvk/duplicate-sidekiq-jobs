class UniqueBookSalesWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed,
                  on_conflict: :reject

  def perform(book_id)
    book = Book.find(book_id)

    logger.info "I am a Sidekiq Book Sales worker - I started"
    sleep 2
    logger.info "I am a Sidekiq Book Sales worker - I finished"

    book.update(sales_calculated_at: Time.current)
    book.update(crunching_sales: false)
  end
end
