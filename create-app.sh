#!/bin/bash
set -e

SLUG=$1

if [ -z "$SLUG" ]; then
  echo "Usage: ./create-app.sh <slug>"
  echo "Example: ./create-app.sh my-awesome-app"
  exit 1
fi

# Scaffold the app
mkdir -p apps/$SLUG

cat > apps/$SLUG/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${SLUG}</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            line-height: 1.6;
            background: #0a0a0f;
            color: #fff;
        }
        h1 { color: #00d4ff; }
        .meta { color: #666; font-size: 0.9em; }
    </style>
</head>
<body>
    <h1>${SLUG}</h1>
    <p class="meta">Deployed via OpenClaw Lab</p>
    <p>Created: $(date -u +"%Y-%m-%d %H:%M UTC")</p>
    <p><a href="/apps/">← Back to Lab</a></p>
</body>
</html>
EOF

# Update apps index
cat > apps/index.html << 'INDEXEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OpenClaw Lab - App Directory</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: #fff;
            min-height: 100vh;
            padding: 60px 40px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        header { text-align: center; margin-bottom: 60px; }
        h1 {
            font-size: 48px;
            font-weight: 700;
            background: linear-gradient(90deg, #00d4ff, #7b2cbf);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 16px;
        }
        .subtitle { color: rgba(255,255,255,0.6); font-size: 18px; }
        .app-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
        }
        .app-card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 32px;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #fff;
        }
        .app-card:hover {
            background: rgba(255,255,255,0.1);
            border-color: #00d4ff;
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }
        .app-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #00d4ff, #7b2cbf);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 20px;
        }
        .app-name {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        .app-desc {
            color: rgba(255,255,255,0.6);
            font-size: 14px;
            line-height: 1.5;
        }
        footer {
            text-align: center;
            margin-top: 80px;
            padding-top: 40px;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: rgba(255,255,255,0.4);
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>OpenClaw Lab</h1>
            <p class="subtitle">AI-Powered App Publishing Platform</p>
        </header>
        
        <div class="app-grid">
INDEXEOF

# Add all apps to index
for dir in apps/*/; do
  slug=$(basename "$dir")
  if [ "$slug" != "index.html" ]; then
    echo "            <a href=\"./${slug}/\" class=\"app-card\">" >> apps/index.html
    echo "                <div class=\"app-icon\">🚀</div>" >> apps/index.html
    echo "                <div class=\"app-name\">${slug}</div>" >> apps/index.html
    echo "                <div class=\"app-desc\">App deployed via OpenClaw Lab</div>" >> apps/index.html
    echo "            </a>" >> apps/index.html
  fi
done

cat >> apps/index.html << 'INDEXEOF'
        </div>
        
        <footer>
            <p>Built with OpenClaw · Deployed on Cloudflare Pages</p>
            <p style="margin-top: 8px; font-size: 12px;">lab.openclawpay.ai</p>
        </footer>
    </div>
</body>
</html>
INDEXEOF

# Commit and push
git add apps/
git commit -m "feat: add app ${SLUG}"
git push origin main

echo ""
echo "✅ App created: https://lab.openclawpay.ai/apps/${SLUG}/"
echo "📁 Directory: https://lab.openclawpay.ai/apps/"
