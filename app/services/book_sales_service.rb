module BookSalesService
  module_function

  def schedule_with_one_flag(book)
    if book.sales_enqueued_at < 10.minutes.ago
      book.update(sales_enqueued_at: Time.current)

      BookSalesWorker.perform_async(book.id)
    end
  end

  def schedule_with_one_boolean_flag(book)
    return if book.crunching_sales

    book.update(crunching_sales: true)

    BookSalesWorker.perform_async(book.id)
  end

  def schedule_with_two_flags(book)
    if book.sales_enqueued_at <= book.sales_calculated_at
      book.update(sales_enqueued_at: Time.current)

      BookSalesWorker.perform_async(book.id)
    end
  end

  def schedule_unique_across_queue(book)
    queue = Sidekiq::Queue.new('default')

    queue.each do |job|
      return if job.klass == BookSalesWorker.to_s &&
        job.args == [book.id]
    end

    BookSalesWorker.perform_async(book.id)
  end
end
