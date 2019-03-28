module ApplicationHelper
  def format_file_size(number)
    case
    when number < 1024
      "#{number} bytes"
    when number.between?(1024, 1024*1024)
      "#{(number/1024)} Kb"
    when number > 1024*1024
      "#{(number/(1024*1024))} Mb"
    else
      number
    end
  end

  def generate_tag_link(tags)
    tags.map do |tag|
      encoded_tag = URI.encode("+#{tag} ")
      "<a href=\"#{files_path}/#{encoded_tag}/1\">#{tag}</a>"
    end.join(',')
  end
end
