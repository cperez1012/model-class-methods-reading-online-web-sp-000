class Post < ActiveRecord::Base

  validate :is_title_case
  before_validation :make_title_case
  belongs_to :author

  def index
  # provide a list of authors to the view for the filter control
  @authors = Author.all

  # filter the @posts list based on user input
  if !params[:author].blank?
    @posts = Post.where(author: params[:author])
  elsif !params[:date].blank?
    if params[:date] == "Today"
      @posts = Post.where("created_at >=?", Time.zone.today.beginning_of_day)
    else
      @posts = Post.where("created_at <?", Time.zone.today.beginning_of_day)
    end
  else
    # if no filters are applied, show all posts
    @posts = Post.all
  end

  private

  def is_title_case
    if title.split.any?{|w|w[0].upcase != w[0]}
      errors.add(:title, "Title must be in title case")
    end
  end

  def make_title_case
    self.title = self.title.titlecase
  end
end
