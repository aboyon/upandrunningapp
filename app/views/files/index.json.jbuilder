json.total_records @resources.count
json.records @resources do |resource|
  json.name resource.name
  json.uuid resource.filename.filename
end

if @related.present?
  json.related_tags @related.each do |(tag,files_count)|
   json.tag tag
   json.file_count files_count
  end
end
