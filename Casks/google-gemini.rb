cask "google-gemini" do
  version :latest
  sha256 :no_check

  url "https://dl.google.com/release2/j33ro/release/Gemini.dmg",
      verified: "dl.google.com/release2/"
  name "Gemini"
  desc "AI assistant"
  homepage "https://gemini.google/mac/"

  livecheck do
    skip "Official download does not expose version metadata"
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Gemini.app"

  zap trash: [
    "~/Library/Application Support/com.google.GeminiMacOS",
    "~/Library/Caches/com.google.GeminiMacOS",
    "~/Library/HTTPStorages/com.google.GeminiMacOS",
    "~/Library/Preferences/com.google.GeminiMacOS.plist",
    "~/Library/Saved Application State/com.google.GeminiMacOS.savedState",
  ]
end
