collection @transactions
attributes :id, :cost, :commission, :fee, :service_type, :qty, :release_at, :created_at, :updated_at
child(:customer) do
  attributes :id, :email, :name
end
child(:expert) do
  attributes :id, :email, :name
end
child(:job) do
  attributes :id, :title, :status
end