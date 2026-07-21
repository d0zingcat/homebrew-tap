cask "loon4mac" do
  version "0.3.0-beta-63"
  sha256 "03fde42fee7a29120c24a9e7a98606b06a066abfd92639c2e7889df536a518a9"

  url "https://github.com/Loon0x00/Loon4Mac/releases/download/0.3.0%2863%29/Loon-#{version}.dmg"
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
