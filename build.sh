#!/bin/zsh
# Copyright (c) 2026 Ali Razavi. All rights reserved. Owned and controlled solely by Ali Razavi: no licence check, no remote control, no backdoor. Terms: see the LICENSE file.
# Rebuilds Untangle.app from src/main.swift and installs it in /Applications.
# Note: after a rebuild, macOS asks again for the Accessibility permission.
set -e
cd "$(dirname "$0")"
mkdir -p build preview
swiftc -swift-version 5 -O -o build/Untangle src/main.swift -framework AppKit -framework Carbon -framework Security -framework ServiceManagement -framework SwiftUI
./build/Untangle --render "$PWD/preview"
APP="build/Untangle.app"
rm -rf "$APP"; mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp build/Untangle "$APP/Contents/MacOS/Untangle"
rm -rf build/icon.iconset; mkdir build/icon.iconset
for s in 16 32 128 256 512; do
  sips -z $s $s preview/icon_1024.png --out build/icon.iconset/icon_${s}x${s}.png >/dev/null
  sips -z $((s*2)) $((s*2)) preview/icon_1024.png --out build/icon.iconset/icon_${s}x${s}@2x.png >/dev/null
done
iconutil -c icns build/icon.iconset -o "$APP/Contents/Resources/AppIcon.icns"
cat > "$APP/Contents/Info.plist" <<'P'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>NSHumanReadableCopyright</key><string>Copyright (c) 2026 Ali Razavi. All rights reserved.</string>
<key>CFBundleName</key><string>Untangle</string>
<key>CFBundleDisplayName</key><string>Untangle</string>
<key>CFBundleIdentifier</key><string>local.untangle</string>
<key>CFBundleExecutable</key><string>Untangle</string>
<key>CFBundleIconFile</key><string>AppIcon</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.0</string>
<key>CFBundleVersion</key><string>1</string>
<key>LSMinimumSystemVersion</key><string>13.0</string>
<key>LSUIElement</key><true/>
<key>NSHighResolutionCapable</key><true/>
<key>NSServices</key><array><dict>
<key>NSMenuItem</key><dict><key>default</key><string>Untangle</string></dict>
<key>NSMessage</key><string>untangleService</string>
<key>NSKeyEquivalent</key><dict><key>default</key><string>U</string></dict>
<key>NSPortName</key><string>Untangle</string>
<key>NSSendTypes</key><array><string>NSStringPboardType</string><string>public.utf8-plain-text</string></array>
<key>NSReturnTypes</key><array><string>NSStringPboardType</string><string>public.utf8-plain-text</string></array>
<key>NSTimeout</key><string>30000</string>
<key>NSRequiredContext</key><dict/>
</dict></array>
</dict></plist>
P
codesign --force --sign - "$APP"
pkill -x Untangle 2>/dev/null || true
rm -rf "/Applications/Untangle.app"
cp -R "$APP" "/Applications/Untangle.app"
rm -rf "$APP"  # keep a single copy so macOS registers the right one
/System/Library/CoreServices/pbs -update
echo "installed"
