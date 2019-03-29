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

  def sanitize_tags(tag_string)
    include_tags, exclude_tags = tag_string.squeeze(' ').split(' ').partition do |tag|
      tag.start_with?('+')
    end
    exclude_tags ||= [] # for the case when we don't have "negative tags"
    exclude_tags.select! { |tag| tag.start_with?('-') } # just sanitize the tag list removing those ones not including a "-"
    (exclude_tags + include_tags).map { |tag| tag.gsub!(/\W/,'') }
    [include_tags, exclude_tags]
  end
end
