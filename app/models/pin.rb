class Pin < ApplicationRecord
  acts_as_votable
  belongs_to :user
  belongs_to :board
  validates :title, presence: true
  # validates :url, format: {with: /\.(png|jpg|gif)\Z/i}, :allow_blank => true
  has_attached_file :image #, styles: { medium: "300x300>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def data_from_url(url)
    object = LinkThumbnailer.generate(url)
    self.title = object.title
    self.description = object.description
    self.image = URI.parse(object.images.first.src.to_s).open
  end
end
