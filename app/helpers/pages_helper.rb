module PagesHelper
  def time_ago_in_words(created_at)
    time_difference = Time.current - created_at

    case time_difference
    when 0...60
      "#{time_difference.round} seconds ago"
    when 60...3600
      "#{(time_difference / 60).round} minutes ago"
    when 3600...86400
      "#{(time_difference / 3600).round} hours ago"
    when 86400...604800
      "#{(time_difference / 86400).round} days ago"
    when 604800...2592000
      "#{(time_difference / 604800).round} weeks ago"
    when 2592000...31104000
      "#{(time_difference / 2592000).round} months ago"
    else
      "#{(time_difference / 31104000).round} years ago"
    end
  end
end
