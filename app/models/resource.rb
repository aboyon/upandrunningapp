class Resource < ApplicationRecord

  scope :latest, ->() { order('id DESC') }

  has_one_attached :filename
  validates_presence_of :name, :tags

  before_save :sanitize_tags

  # @params <Array, include_tags> array containing the tags we're looking for
  # @params <Array, exclude_tags> array containing the tags we want to exclude
  def self.tag_filter(include_tags, exclude_tags = [])
    query = self.all
    include_tags.each do |included_tag|
      query = query.where("tags ILIKE ?", "%#{included_tag}%")
    end
    exclude_tags.each do |excluded_tag|
      query = query.where("tags NOT ILIKE ?", "%#{excluded_tag}%")
    end
    query
  end

  def self.related_content(search, include_tags, exclude_tags = [])
    related_tags = (search.flat_map(&:tag_list) - include_tags).uniq
    Hash[
      related_tags.map do |tag|
        [tag, self.tag_filter([tag], exclude_tags).count]
      end
    ]
  end

  def tag_list
    tags.split(',')
  end

  private

    def sanitize_tags
      self.tags = tags.split(',').map(&:strip).sort.join(',')
    end

end
