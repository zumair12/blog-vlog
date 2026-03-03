# frozen_string_literal: true

# This is a comprehensive seed file for blog-vlog
# Run: rails db:seed

require "faker"

puts "🌱 Seeding database..."

# ─── Clean slate ────────────────────────────────────────────────────────────
PostTag.destroy_all
Comment.destroy_all
Post.destroy_all
Tag.destroy_all
Category.destroy_all
User.destroy_all

ActiveStorage::Attachment.destroy_all
ActiveStorage::Blob.destroy_all

puts "✓ Cleared existing data"

# ─── Users ─────────────────────────────────────────────────────────────────
admin = User.create!(
  username:  "admin",
  email:     "admin@blogvlog.com",
  password:  "password123",
  password_confirmation: "password123",
  role:      :admin,
  bio:       "BlogVlog founder and lead editor. Passionate about technology, writing, and building great communities.",
  website:   "https://blogvlog.com",
  twitter_handle: "blogvlog"
)

author1 = User.create!(
  username:  "janedoe",
  email:     "jane@blogvlog.com",
  password:  "password123",
  password_confirmation: "password123",
  role:      :author,
  bio:       "Full-stack developer and technical writer. I write about Ruby on Rails, JavaScript, and software architecture.",
  twitter_handle: "janedoe_dev"
)

author2 = User.create!(
  username:  "marksmith",
  email:     "mark@blogvlog.com",
  password:  "password123",
  password_confirmation: "password123",
  role:      :author,
  bio:       "Designer and front-end engineer who loves crafting beautiful user experiences.",
  website:   "https://marksmith.io"
)

5.times do
  User.create!(
    username:  "user_#{SecureRandom.hex(4)}",
    email:     Faker::Internet.unique.email,
    password:  "password123",
    password_confirmation: "password123",
    role:      :reader,
    bio:       Faker::Lorem.sentence(word_count: 15)
  )
end

puts "✓ Created #{User.count} users"

# ─── Categories ─────────────────────────────────────────────────────────────
categories_data = [
  { name: "Technology",  icon: "💻", color: "#6366f1", description: "Exploring the latest in software, hardware, and digital innovation." },
  { name: "Design",      icon: "🎨", color: "#ec4899", description: "UI/UX design, visual aesthetics, and creative processes." },
  { name: "Business",    icon: "📈", color: "#f97316", description: "Entrepreneurship, marketing, and startup insights." },
  { name: "Tutorial",    icon: "📚", color: "#22c55e", description: "Step-by-step guides and hands-on learning." },
  { name: "Opinion",     icon: "💬", color: "#8b5cf6", description: "Thoughtful perspectives on tech and culture." },
  { name: "Career",      icon: "🚀", color: "#14b8a6", description: "Career growth, job searching, and professional development." }
]

categories = categories_data.map { |data| Category.create!(data) }
puts "✓ Created #{Category.count} categories"

# ─── Tags ────────────────────────────────────────────────────────────────────
tags_data = [
  { name: "ruby",           color: "#ef4444" },
  { name: "rails",          color: "#dc2626" },
  { name: "javascript",     color: "#eab308" },
  { name: "typescript",     color: "#3b82f6" },
  { name: "react",          color: "#06b6d4" },
  { name: "css",            color: "#8b5cf6" },
  { name: "design-systems", color: "#ec4899" },
  { name: "postgresql",     color: "#6366f1" },
  { name: "devops",         color: "#f97316" },
  { name: "beginners",      color: "#22c55e" },
  { name: "productivity",   color: "#14b8a6" },
  { name: "open-source",    color: "#a78bfa" }
]

tags = tags_data.map { |td| Tag.create!(name: td[:name], color: td[:color], slug: td[:name]) }
puts "✓ Created #{Tag.count} tags"

# ─── Posts ───────────────────────────────────────────────────────────────────
post_authors = [ admin, author1, author2 ]

sample_content = <<~HTML
  <h2>Introduction</h2>
  <p>Welcome to this comprehensive guide. In this post, we'll dive deep into the topic and explore everything you need to know to get started and become proficient.</p>
  <blockquote>
    "The best code is the code you don't have to write." — Jeff Atwood
  </blockquote>
  <h2>Getting Started</h2>
  <p>Before we begin, make sure you have the necessary prerequisites installed. We'll walk through each step carefully so you don't miss anything important.</p>
  <ul>
    <li>Install the required dependencies</li>
    <li>Configure your environment</li>
    <li>Run the initial setup</li>
  </ul>
  <h2>Core Concepts</h2>
  <p>Understanding the fundamentals is crucial. Here's what you need to know about the core concepts that underpin everything we'll build in this guide.</p>
  <p>Once you've mastered these basics, you'll be able to apply them to real-world projects with confidence and efficiency.</p>
  <h2>Advanced Tips</h2>
  <p>Now that you have the foundation, let's look at some advanced techniques that will take your skills to the next level. These are patterns used by professionals in production environments.</p>
  <h2>Conclusion</h2>
  <p>We've covered a lot of ground today. Remember: the best way to learn is by doing. Take what you've learned here and start building something real. Happy coding!</p>
HTML

posts_data = [
  { title: "Building a Blog with Ruby on Rails 8 and ActionText", featured: true, category: categories[0] },
  { title: "Mastering Tailwind CSS v4: A Complete Guide",         featured: true, category: categories[1] },
  { title: "PostgreSQL Performance Tuning for Rails Apps",        featured: false, category: categories[0] },
  { title: "The Art of Design Systems: Building for Scale",       featured: true, category: categories[1] },
  { title: "From Idea to Startup: My Journey Building a SaaS",   featured: false, category: categories[2] },
  { title: "Ruby on Rails Best Practices in 2025",                featured: false, category: categories[3] },
  { title: "Why I Switched from React to Hotwire",               featured: false, category: categories[4] },
  { title: "Turbo Streams & Stimulus: Real-time Rails",           featured: false, category: categories[3] },
  { title: "Career Growth as a Software Engineer",               featured: false, category: categories[5] },
  { title: "Open Source Contribution Guide for Beginners",       featured: false, category: categories[3] },
  { title: "Understanding ActiveRecord Associations",            featured: false, category: categories[0] },
  { title: "CSS Grid vs Flexbox: When to Use Which",             featured: false, category: categories[1] }
]

created_posts = posts_data.each_with_index.map do |pd, i|
  post = Post.new(
    title:        pd[:title],
    status:       :published,
    featured:     pd[:featured],
    user:         post_authors[i % 3],
    category:     pd[:category],
    published_at: (12 - i).weeks.ago + rand(7).days
  )
  post.content = sample_content
  post.save!
  post
end

# Assign tags
created_posts.each_with_index do |post, i|
  post_tags = tags.sample(rand(2..4))
  post.tags << post_tags
end

puts "✓ Created #{Post.count} posts"

# ─── Comments ────────────────────────────────────────────────────────────────
readers = User.role_reader

created_posts.first(6).each do |post|
  rand(2..5).times do
    commenter = (readers + [ author1, author2 ]).sample
    comment = Comment.create!(
      body:   Faker::Lorem.paragraph(sentence_count: rand(1..3)),
      post:   post,
      user:   commenter,
      status: :approved
    )

    # Some replies
    if rand > 0.5
      replier = (readers + [ admin ]).sample
      Comment.create!(
        body:      Faker::Lorem.sentence(word_count: rand(8..20)),
        post:      post,
        user:      replier,
        parent:    comment,
        status:    :approved
      )
    end
  end
end

# Some pending comments
created_posts.last(3).each do |post|
  commenter = readers.sample || author1
  Comment.create!(
    body:   Faker::Lorem.paragraph(sentence_count: 2),
    post:   post,
    user:   commenter,
    status: :pending
  )
end

puts "✓ Created #{Comment.count} comments"

puts ""
puts "🎉 Seed complete!"
puts ""
puts "  Admin:   admin@blogvlog.com  /  password123"
puts "  Author:  jane@blogvlog.com   /  password123"
puts "  Author:  mark@blogvlog.com   /  password123"
puts ""
puts "  Posts: #{Post.count} | Comments: #{Comment.count} | Users: #{User.count}"
