require 'html/pipeline'

module TagHelper
  def human_time(time)
    content_tag :abbr, class: "timeago", title: time.iso8601 do
      time.to_formatted_s(:long)
    end
  end

  def markdownify(text)
    md_pipeline.call(text)[:output].html_safe
  end

  def sanitize_whitelist
    Sanitize::Config.merge(Sanitize::Config::BASIC,
      elements: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'a', 'p', 'strong', 'em', 'ul', 'ol', 'li']
    )
  end

  def md_pipeline
    @md_pipeline ||= HTML::Pipeline.new([
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      HTML::Pipeline::AutolinkFilter
    ], gfm: true, whitelist: sanitize_whitelist)
  end
end
