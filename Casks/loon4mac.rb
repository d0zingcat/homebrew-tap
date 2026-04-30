cask "loon4mac" do
  version "0.2.0-beta-60"
  sha256 "5dbe407bf798caa5ca7975b3ee4e8c01122515ad03eda14664dc4ba11ca75444"

  url "https://github.com/Loon0x00/Loon4Mac/releases/download/0.2.0%2860%29/Loon-#{version}.dmg"
  name "Loon"
  desc "Network debugging tool"
  homepage "https://github.com/Loon0x00/Loon4Mac"

  livecheck do
    url :homepage
    strategy :github_latest do |json|
      tag = json["tag_name"]
      # tag format: "0.2.0(60)" → cask version: "0.2.0-beta-60"
      tag.match(/^(\d+\.\d+\.\d+)\((\d+)\)$/) { |m| "#{m[1]}-beta-#{m[2]}" }
    end
  end

  depends_on macos: ">= :ventura"

  app "Loon.app"

  zap trash: [
    "~/Library/Application Support/Loon",
    "~/Library/Caches/com.loon.mac",
    "~/Library/Preferences/com.loon.mac.plist",
  ]
end
