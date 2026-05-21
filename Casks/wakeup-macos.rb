cask "wakeup-macos" do
  version "0.8.0"
  sha256 "a30abfa255c42a3b18294a290d6e2769c3f11ae3120c047201c044d059413f2b"

  url "https://github.com/d0zingcat/wakeup-macos/releases/download/v#{version}/WakeupMenu.dmg"
  name "WakeupMenu"
  desc "Remote wake utility"
  homepage "https://github.com/d0zingcat/wakeup-macos"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "WakeupMenu.app"

  zap trash: [
    "~/Library/Application Support/WakeupMenu",
    "~/Library/Caches/com.wakeup.menu",
    "~/Library/Preferences/com.wakeup.menu.plist",
  ]
end
