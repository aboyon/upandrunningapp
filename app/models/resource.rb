class Resource < ApplicationRecord
  has_many :taggings
  has_many :tags, :through => :taggings

  has_one_attached :filename
  validates_presence_of :name

  def self.tag_filter(tag_names)
    include_tags, exclude_tags = tag_names.squeeze(' ').split(' ').partition do |tag|
      tag.start_with?('+')
    end
    (exclude_tags || []).select! { |tag| tag.start_with?('-') } # just sanitize the tag list removing those ones not including a "-"
    (exclude_tags + include_tags).map { |tag| tag.gsub!(/\W/,'') }

    # @Todo this can be improved for the sake of DB performace
    Tag.where("name IN (?) AND name NOT IN (?)", include_tags, exclude_tags).flat_map(&:resources).uniq
  end

  def tag_list
    tags.pluck(:name)
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |tag_name|
      Tag.where(name: tag_name.strip).first_or_create!
    end
  end

end
