# Custom Metabase Build Instructions

## Quick Setup

1. **Create directory structure:**
```bash
mkdir custom-metabase
cd custom-metabase
mkdir assets
```

2. **Add your logo:**
   - Save your logo as `assets/logo.svg`
   - Recommended size: 200x60px
   - Use SVG format for best quality

3. **Copy the Dockerfile:**
   - Use the `custom-metabase-Dockerfile` from this project
   - Rename it to `Dockerfile` in your `custom-metabase` directory

4. **Build the image:**
```bash
docker build -t custom-metabase:v1 .
```

5. **Run your custom Metabase:**
```bash
docker run -d -p 3003:3000 --name my-metabase custom-metabase:v1
```

6. **Access:** http://localhost:3003

## What Gets Customized

- ✅ Logo in navigation bar
- ✅ Site name (set via ENV variable)
- ✅ Favicon (if you uncomment and add favicon.ico)

## Next Steps

- Add your `assets/logo.svg` file
- Optionally add `assets/favicon.ico`
- Build and test!
