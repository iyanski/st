object @ticket
attributes :id, :title, :description, :created_at, :updated_at, :code, :expert, :expert, :status, :conversation
child(:job) do
  attributes :id, :title, :code
end