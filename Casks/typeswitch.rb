cask "typeswitch" do
  version "0.4"
  sha256 "51a396a75708b745411c5d008b02bed793631f1b2f4ef5aab6fe1407b9eff8bb"

  url "https://github.com/ygsgdbd/TypeSwitch/releases/download/v#{version}/TypeSwitch.dmg"
  name "TypeSwitch"
  desc "Input method switcher"
  homepage "https://github.com/ygsgdbd/TypeSwitch"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "TypeSwitch.app"

  zap trash: [
    "~/Library/Application Support/TypeSwitch",
    "~/Library/Caches/top.ygsgdbd.TypeSwitch",
    "~/Library/Preferences/top.ygsgdbd.TypeSwitch.plist",
  ]
end
