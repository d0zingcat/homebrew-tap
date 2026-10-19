cask "typeswitch" do
  version "0.10.1"
  sha256 "5137e3cdeff67a700a14a1f39eed2d5c0854e87f5677595b909d937f591ccc85"

  url "https://github.com/ygsgdbd/TypeSwitch/releases/download/v#{version}/TypeSwitch-macOS-universal.zip"
  name "TypeSwitch"
  desc "Input method switcher"
  homepage "https://github.com/ygsgdbd/TypeSwitch"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "TypeSwitch.app"

  zap trash: [
    "~/Library/Application Support/TypeSwitch",
    "~/Library/Caches/top.ygsgdbd.TypeSwitch",
    "~/Library/Preferences/top.ygsgdbd.TypeSwitch.plist",
  ]
end
