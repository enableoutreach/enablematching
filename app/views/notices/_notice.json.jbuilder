json.extract! notice, :id, :content, :sticky, :expires, :created_at, :updated_at
json.url notice_url(notice, format: :json)
