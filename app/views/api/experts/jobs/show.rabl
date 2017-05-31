object @job
attributes :id, :expert, :customer, :category, :title, :description, :status, :published_at, :claimed_at, :estimated_at, :accepted_at, :submitted_at, :completed_at, :closed_at, :created_at, :updated_at, :etc, :estimate, :starts_at, :job_attachments, :code, :conversations, :service, :conversation, :company
child(:customer) do
  attributes :id, :email, :first_name, :last_name, :name
  node(:avatar) do |item|
    item.try(:avatar).try(:url)
  end
end
child(:expert) do
  attributes :id, :email, :first_name, :last_name, :name
  node(:avatar) do |item|
    item.try(:avatar).try(:url)
  end
end