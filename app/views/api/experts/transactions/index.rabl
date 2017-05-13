collection @transactions
attributes :id, :cost, :earnings, :service_type, :qty, :release_at, :created_at, :updated_at, :floating_balance, :available_balance, :earnings
child(:job) do
  attributes :id, :title
end