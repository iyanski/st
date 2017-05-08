collection @transactions
attributes :id, :cost, :commission, :fee, :service_type, :qty, :release_at, :created_at, :updated_at
child(:job) do
  attributes :id, :title, :status, :code
end