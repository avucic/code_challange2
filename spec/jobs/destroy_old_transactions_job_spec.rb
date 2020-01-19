# frozen_string_literal: true

RSpec.describe DestroyOldTransactionsJob, type: :job do
  subject(:job) { described_class.perform_later }

  before do
    ActiveJob::Base.queue_adapter = :test
    allow(Transaction).to receive(:outdated).and_return(Transaction)
    allow(Transaction).to receive(:destroy_all).and_return(Transaction)
    DestroyOldTransactionsJob.perform_now
  end

  it 'queues the job' do
    expect { job }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by 1
  end

  it { expect(Transaction).to have_received(:outdated) }

  it { expect(Transaction).to have_received(:destroy_all) }
end
