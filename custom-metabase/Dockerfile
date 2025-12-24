FROM metabase/metabase:latest

# Create a directory for custom assets
RUN mkdir -p /app/custom-assets

# Copy custom logo
COPY assets/logo.svg /app/custom-assets/logo.svg

# Set environment variables
ENV MB_SITE_NAME="Analytics Pro"
ENV MB_SITE_URL="http://localhost:3003"
ENV MB_LOGO_URL="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjYwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDx0ZXh0IHg9IjEwIiB5PSI0MCIgZm9udC1mYW1pbHk9IkFyaWFsIiBmb250LXNpemU9IjI0IiBmaWxsPSJibHVlIj5OZXcgTG9nbzwvdGV4dD4KPC9zdmc+"

# Expose port
EXPOSE 3000

# Note: The logo replacement requires mounting or CSS injection
# For a simple test, we'll use the site name change
