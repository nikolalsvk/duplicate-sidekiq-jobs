# duplicate-sidekiq-jobs

The whole app is built to paint some examples for the Sidekiq Duplicate Jobs
blog post. You can read it [right here](https://blog.appsignal.com/2021/05/12/three-ways-to-avoid-duplicate-sidekiq-jobs.html).

## Setup

```bash
$ bundle install
$ bin/rails db:setup
$ bin/rails db:migrate
```

## Running

To get the Sidekiq Web locally on http://localhost:3000/sidekiq, run:

```bash
$ bin/rails server
```

Run Sidekiq process with:

```bash
$ bundle exec sidekiq
```

## Test out DIY solutions for running unique jobs

First, create a book in the Rails console to play around with:

```rb
Book.create(title: "The Street Photographer's Manual", sales_calculated_at: Time.now, sales_enqueued_at: 15.minutes.ago)
```

### 1. One Flag approach

You can try to schedule the `BookSalesWorker` 100 times with:

```rb
100.times { BookSalesService.schedule_with_one_flag(Book.last) }
```

Try checking the Sidekiq log and the job should run only once.

Also, there's an example with the boolean flag (`crunching_sales`) instead of using `sales_enqueued_at`. You can run that example with:

```rb
100.times { BookSalesService.schedule_with_one_boolean_flag(Book.last) }
```

The job should be executed only once.

### 2. Two Flag Approach

```rb
100.times { BookSalesService.schedule_with_two_flags(Book.last) }
```

The example will utilize two flags - `sales_calculated_at` and
`sales_enqueued_at` to figure out whether to schedule jobs or not. In the
end, only one job should perform.

### 3. Traverse Sidekiq Queue Approach

```rb
100.times { BookSalesService.schedule_unique_across_queue(Book.last) }
```

This approach will schedule 10 jobs at first, until the queue fills up. Then,
it will skip other jobs. If you have an idea how to improve this example,
please, submit a PR and let's make it better.

### 4. Using sidekiq-unique-jobs gem

Try running:

```rb
5.times { UniqueBookSalesWorker.perform_async(Book.last.id) }
```

Open http://localhost:3000/sidekiq and you should see couple of jobs in the
dead queue. Enter it and you will see the `UniqueBookSalesWorker` jobs that
got rejected because the same job was running.

## Contributing

All the files are inside `app/workers` and `app/services/book_sales_service.rb`
that are used to illustrate how to avoid duplicate jobs. If you have more ideas, please,
submit a PR that describes the approach.

## Future plans

- [ ] Cover with tests
- [x] Add sidekiq-unique-jobs gem example
