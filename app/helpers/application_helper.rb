# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  # Returns active Tailwind classes for navbar links
  def nav_link_class(current_path, path)
    active = current_path == path || (path != "/" && current_path.start_with?(path))
    base = "px-3 py-2 rounded-lg text-sm font-medium transition-colors"
    active ? "#{base} text-white bg-gray-800" : "#{base} text-gray-400 hover:text-white hover:bg-gray-800/50"
  end

  # Returns active Tailwind classes for admin sidebar links
  def sidebar_link_class(controller_name_key)
    active = params[:controller] == controller_name_key.to_s.tr("_", "/") ||
             params[:controller].start_with?(controller_name_key.to_s.tr("_", "/"))
    base = "flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium w-full transition-all duration-150"
    active ? "#{base} bg-violet-600/20 text-violet-300 border border-violet-500/20" : "#{base} text-gray-400 hover:text-white hover:bg-gray-800"
  end

  # Format a number (e.g., 1200 → "1.2k")
  def compact_number(num)
    return "0" if num.nil?
    if num >= 1_000_000
      "#{(num / 1_000_000.0).round(1)}m"
    elsif num >= 1_000
      "#{(num / 1_000.0).round(1)}k"
    else
      num.to_s
    end
  end

  # Render a status badge
  def status_badge(status)
    classes = case status.to_s
              when "published" then "bg-emerald-500/20 text-emerald-300"
              when "draft"     then "bg-amber-500/20 text-amber-300"
              when "archived"  then "bg-gray-500/20 text-gray-400"
              when "approved"  then "bg-emerald-500/20 text-emerald-300"
              when "pending"   then "bg-amber-500/20 text-amber-300"
              when "rejected"  then "bg-red-500/20 text-red-400"
              when "spam"      then "bg-red-700/20 text-red-500"
              else "bg-gray-500/20 text-gray-400"
              end
    content_tag(:span, status.to_s.capitalize, class: "text-xs px-2.5 py-1 rounded-full font-medium #{classes}")
  end

  def meta_title(title)
    "#{title} – BlogVlog"
  end
end
