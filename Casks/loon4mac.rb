cask "loon4mac" do
  version "0.4.0-beta-991"
  sha256 "777c8499fe688dcaf917adc190509d4bd4a197be976ab6d6f9b5b9b2d12bd6ab"

  url "https://github.com/Loon0x00/Loon4Mac/releases/download/0.4.0%28991%29/Loon-#{version}.dmg"
  name "Loon"
  desc "Network debugging tool"
  homepage "https://github.com/Loon0x00/Loon4Mac"

  livecheck do
    url :homepage
    strategy :github_latest do |json|
      tag = json["tag_name"]
      # tag format: "0.3.0(63)" → cask version: "0.3.0-beta-63"
      tag.match(/^(\d+\.\d+\.\d+)\((\d+)\)$/) { |m| "#{m[1]}-beta-#{m[2]}" }
    end
  end

  depends_on macos: :ventura

  app "Loon.app"

  zap trash: [
    "~/Library/Application Support/Loon",
    "~/Library/Caches/com.loon.mac",
    "~/Library/Preferences/com.loon.mac.plist",
  ]
end
