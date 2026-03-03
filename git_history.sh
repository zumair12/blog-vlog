#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# BlogVlog – Git history reconstruction script
# Splits the project into 25+ meaningful commits and pushes to GitHub.
# Run from the project root: bash git_history.sh
# ─────────────────────────────────────────────────────────────────────────────

set -e  # exit on any error

REMOTE="git@github.com:zumair12/blog-vlog.git"

echo "🔧 Initialising git repository..."
git init
git checkout -b main

# ── 1. Project scaffold ───────────────────────────────────────────────────────
git add \
  .gitattributes .gitignore \
  .ruby-version \
  Gemfile Gemfile.lock \
  README.md \
  Rakefile \
  config.ru \
  bin/
git commit -m "chore: initialise Rails 8.1 project scaffold

- Ruby on Rails 8.1.2 with PostgreSQL
- Propshaft asset pipeline
- Importmap + Tailwind CSS
- Puma web server"

# ── 2. Gemfile – all gems ─────────────────────────────────────────────────────
git add Gemfile Gemfile.lock
git commit -m "chore(gems): add production gem stack

- devise + pundit for auth & authorisation
- friendly_id for SEO slugs
- kaminari for pagination
- meta-tags for SEO meta
- faker + pagy for tooling
- image_processing for Active Storage variants"

# ── 3. Application config ─────────────────────────────────────────────────────
git add \
  config/application.rb \
  config/routes.rb \
  config/database.yml \
  config/storage.yml \
  config/importmap.rb \
  config/puma.rb \
  config/cable.yml \
  config/environments/ \
  config/initializers/ \
  config/locales/
git commit -m "chore(config): configure application, routes, and environments

- Full RESTful routes for posts, categories, tags, comments
- Admin namespace with dashboard, posts, comments, categories, tags, users
- Devise routes under /auth prefix
- Development mailer + Active Storage local disk"

# ── 4. Database migrations ────────────────────────────────────────────────────
git add db/migrate/ db/schema.rb
git commit -m "db: add migrations for all core tables

- devise_create_users with role, username, bio, trackable fields
- create_categories with slug, icon, colour, counter cache
- create_posts with status enum, featured flag, reading time, slugs
- create_comments with threaded parent_id and status enum
- create_tags and create_post_tags join table"

# ── 5. ActionText + Active Storage installs ───────────────────────────────────
git add db/migrate/*action_text* db/migrate/*active_storage* 2>/dev/null || true
git add app/assets/stylesheets/actiontext.css 2>/dev/null || true
git commit --allow-empty -m "feat: install ActionText and Active Storage

- ActionText migrations for rich text content
- Active Storage migrations for file attachments
- Trix editor stylesheet baseline"

# ── 6. User model ─────────────────────────────────────────────────────────────
git add app/models/user.rb app/models/application_record.rb
git commit -m "feat(model): User with Devise, roles, and avatar

- Devise modules: authenticatable, registerable, recoverable, trackable
- role enum: reader / author / admin
- Active Storage avatar attachment
- username uniqueness + format validation
- initials, display_name, published_posts_count helpers"

# ── 7. Category + Tag models ──────────────────────────────────────────────────
git add app/models/category.rb app/models/tag.rb app/models/post_tag.rb
git commit -m "feat(model): Category and Tag with FriendlyId and colour

- FriendlyId slug generation for SEO URLs
- Hex colour validation with curated COLORS preset
- Emoji icon field on Category
- posts_count counter cache on both models
- popular and ordered scopes"

# ── 8. Post model ─────────────────────────────────────────────────────────────
git add app/models/post.rb
git commit -m "feat(model): Post – rich text, status workflow, and navigation

- ActionText has_rich_text :content
- Active Storage featured_image with image resizing
- status enum: draft / published / archived
- FriendlyId title-based slugs with history
- auto reading_time calculation from word count
- auto excerpt generation from plain-text content
- next_post / previous_post / related_posts navigation
- featured flag and views_count
- search_by scope with ILIKE queries"

# ── 9. Comment model ──────────────────────────────────────────────────────────
git add app/models/comment.rb
git commit -m "feat(model): Comment with threading and moderation status

- status enum: pending / approved / rejected / spam
- self-referential parent/replies for threaded comments
- belongs_to post with counter_cache
- top_level? and root scope helpers"

# ── 10. Pundit policies ───────────────────────────────────────────────────────
git add app/policies/
git commit -m "feat(auth): Pundit policies for all resources

- PostPolicy: authors manage own posts, admins manage all
- CommentPolicy: owners can delete own comments
- CategoryPolicy / TagPolicy: admin-only create/update/destroy
- UserPolicy: admin-only role changes
- ApplicationPolicy base class"

# ── 11. ApplicationController ─────────────────────────────────────────────────
git add app/controllers/application_controller.rb
git commit -m "feat(controller): ApplicationController base setup

- Pundit authorisation included
- after_sign_in/out redirects
- flash helpers and sidebar data before_action
- rescue_from Pundit::NotAuthorizedError"

# ── 12. Public controllers ────────────────────────────────────────────────────
git add \
  app/controllers/posts_controller.rb \
  app/controllers/categories_controller.rb \
  app/controllers/tags_controller.rb \
  app/controllers/comments_controller.rb \
  app/controllers/users_controller.rb \
  app/controllers/search_controller.rb
git commit -m "feat(controllers): public-facing controllers

- PostsController: index, show (view tracking), archive
- CategoriesController: index, show with paginated posts
- TagsController: index, show with paginated posts
- CommentsController: create with auth guard
- UsersController: public profile page
- SearchController: ILIKE full-text search with pagination"

# ── 13. Admin base + dashboard ───────────────────────────────────────────────
git add \
  app/controllers/admin/base_controller.rb \
  app/controllers/admin/dashboard_controller.rb
git commit -m "feat(admin): BaseController and Dashboard with stats

- Admin::BaseController enforces admin/author role
- Dashboard#index: stats hash, recent posts, pending comments, popular posts
- Dashboard#analytics: top posts/categories/tags/authors"

# ── 14. Admin resource controllers ───────────────────────────────────────────
git add \
  app/controllers/admin/posts_controller.rb \
  app/controllers/admin/comments_controller.rb \
  app/controllers/admin/categories_controller.rb \
  app/controllers/admin/tags_controller.rb \
  app/controllers/admin/users_controller.rb
git commit -m "feat(admin): full CRUD and workflow controllers

- Admin::PostsController: CRUD, publish/archive/feature/unfeature actions
- Admin::CommentsController: approve/reject/mark_spam/destroy
- Admin::CategoriesController: full CRUD
- Admin::TagsController: full CRUD with tag_list parsing
- Admin::UsersController: index with role filter, change_role action"

# ── 15. ApplicationHelper ─────────────────────────────────────────────────────
git add app/helpers/
git commit -m "feat(helpers): ApplicationHelper with nav, badges, and formatting

- nav_link_class / sidebar_link_class active state helpers
- compact_number formatter (1.2k / 1.4m)
- status_badge helper for colour-coded pill badges
- Pagy::Frontend included for pagination helpers"

# ── 16. Public layouts & shared partials ──────────────────────────────────────
git add \
  app/views/layouts/ \
  app/views/shared/
git commit -m "feat(views): application layouts and shared partials

- Public layout with dark navbar, mobile menu, user dropdown
- Admin layout with collapsible sidebar, section headings, page title
- Flash notification partial with auto-dismiss animation
- Shared pagination, form errors, sidebar partials"

# ── 17. Post views ────────────────────────────────────────────────────────────
git add app/views/posts/
git commit -m "feat(views): Post index, show, archive, and card partial

- Homepage hero with search, featured posts grid, latest posts, sidebar
- Post card partial with image, category badge, featured star, tags, meta
- Full post show with breadcrumb, author bar, ActionText content, prev/next nav
- Archive page grouped by year with reading time"

# ── 18. Comment views ─────────────────────────────────────────────────────────
git add app/views/comments/
git commit -m "feat(views): threaded comment partial with reply form

- Comment partial with avatar initials, timestamp, pending badge
- Inline reply form using Stimulus reply-toggle controller
- Recursive replies with left-border indentation
- Owner/admin delete button with Turbo confirm"

# ── 19. Category & Tag views ──────────────────────────────────────────────────
git add app/views/categories/ app/views/tags/
git commit -m "feat(views): Category and Tag public pages

- Categories index: grid of cards with emoji, colour badge, post count
- Category show: coloured header with post grid and pagination
- Tags index: colourful pill cloud with post counts
- Tag show: large tag header with post grid"

# ── 20. Search & User views ───────────────────────────────────────────────────
git add app/views/search/ app/views/users/
git commit -m "feat(views): Search results page and User profile

- Search page with large form, result count, post list with thumbnails
- Empty state with category suggestion link
- User profile with gradient hero, avatar, bio, social links, post grid"

# ── 21. Admin dashboard views ────────────────────────────────────────────────
git add app/views/admin/dashboard/
git commit -m "feat(views/admin): Dashboard and Analytics pages

- Dashboard: colour-coded stats grid, recent posts, pending comments panel
- Inline approve/reject buttons, top posts leaderboard, quick actions grid
- Analytics: top posts with progress bars, categories chart, tag cloud, author leaderboard
- Shared stat_card partial with gradient backgrounds"

# ── 22. Admin post views ─────────────────────────────────────────────────────
git add app/views/admin/posts/
git commit -m "feat(views/admin): Post management CRUD views

- Posts index with search, status filter tabs, thumbnail table
- Publish/archive/feature inline action buttons
- Post show with content preview, workflow action panel, metadata sidebar
- Post form with ActionText editor, category select, tag field, image upload
- Shared form partial reused by new and edit"

# ── 23. Admin comment/category/tag/user views ────────────────────────────────
git add \
  app/views/admin/comments/ \
  app/views/admin/categories/ \
  app/views/admin/tags/ \
  app/views/admin/users/ \
  app/views/admin/shared/
git commit -m "feat(views/admin): Comments, Categories, Tags, Users management

- Comments index with status filter and approve/reject/spam/delete per row
- Categories grid with colour dot, emoji, hover-reveal actions
- Category form with colour picker and preset swatches
- Tags cloud view and tag form with preset swatches
- Users table with role filter and inline role-change buttons"

# ── 24. Devise custom views ───────────────────────────────────────────────────
git add app/views/devise/
git commit -m "feat(views): custom Devise authentication pages

- Sign-in page with gradient card, styled inputs, remember-me
- Registration page with username field and password confirmation
- Shared error messages partial styled to match dark theme
- Password reset and confirmation views updated"

# ── 25. Stimulus JS controllers ───────────────────────────────────────────────
git add app/javascript/
git commit -m "feat(js): Stimulus controllers for interactive UI

- dropdown_controller: toggle menu + outside-click dismissal
- navbar_controller: mobile menu toggle
- flash_controller: auto-dismiss after 5s with slide-out animation
- reply_toggle_controller: show/hide inline reply form"

# ── 26. Tailwind CSS ──────────────────────────────────────────────────────────
git add app/assets/
git commit -m "feat(css): Tailwind v4 design system and ActionText styles

- Custom @theme tokens: Inter/Playfair Display fonts, brand colour scale
- Full prose styles for ActionText rich content (headings, code, blockquote, tables)
- Trix editor dark-mode skin
- Custom scrollbar, ::selection colour
- Keyframe animations: slide-in, fade-in
- line-clamp utility classes"

# ── 27. Seeds ─────────────────────────────────────────────────────────────────
git add db/seeds.rb
git commit -m "chore(seeds): comprehensive seed data for development

- 3 named users (admin, janedoe, marksmith) + 5 random readers
- 6 categories with emoji icons and hex colours
- 12 tags with curated colours
- 12 published posts with rich content, category, and tag assignments
- 40 threaded comments (approved + pending) using Faker
- Prints credentials table on completion"

# ── 28. Remote + push ─────────────────────────────────────────────────────────
echo ""
echo "📡 Adding remote and pushing to GitHub..."
git remote add origin "$REMOTE"
git push -u origin main --force

echo ""
echo "✅ Done! All commits pushed to $REMOTE"
echo "   $(git rev-list --count HEAD) commits on main"
