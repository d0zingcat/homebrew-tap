cask "push-to-talk" do
  version "1.2.0"
  sha256 "5e3d377e413c9bd2054ea4dee0b5a5d3662015628830725b8d2bf16ca7e3d288"

  url "https://github.com/d0zingcat/push-to-talk/releases/download/v#{version}/PushToTalk.dmg"
  name "PushToTalk"
  desc "Voice input helper for Doubao IME"
  homepage "https://github.com/d0zingcat/push-to-talk"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: :big_sur

  app "PushToTalk.app"

  zap trash: [
    "~/.config/pushtotalk",
    "~/Library/Application Support/PushToTalk",
    "~/Library/Caches/com.pushtotalk.PushToTalk",
    "~/Library/HTTPStorages/com.pushtotalk.PushToTalk",
    "~/Library/Logs/pushtotalk",
    "~/Library/Preferences/com.pushtotalk.PushToTalk.plist",
  ]
end
