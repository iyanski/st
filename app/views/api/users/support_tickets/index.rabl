collection @tickets
attributes :id, :title, :description, :created_at, :updated_at, :code, :customer, :expert, :status, :conversation
child(:job) do
  attributes :id, :title, :code, :expert, :customer
end