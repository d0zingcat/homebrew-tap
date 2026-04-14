cask "loon4mac" do
  version "0.2.0-beta-57"
  sha256 "b36bc66fddf3e11e63bdac014f2eec903c5cc060a7e82a3867ba914ddad92ad0"

  url "https://github.com/Loon0x00/Loon4Mac/releases/download/0.2.0%2857%29/Loon-#{version}.dmg"
  name "Loon"
  desc "Network debugging tool"
  homepage "https://github.com/Loon0x00/Loon4Mac"

  depends_on macos: ">= :ventura"

  app "Loon.app"

  zap trash: [
    "~/Library/Application Support/Loon",
    "~/Library/Caches/com.loon.mac",
    "~/Library/Preferences/com.loon.mac.plist",
  ]
end
