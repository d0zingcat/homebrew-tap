cask "dbx" do
  arch arm: "aarch64", intel: "x64"

  version "0.3.3"
  sha256 arm:   "ae6f5845ef35d00093e74ab781411724094b498d112d6fd4bae63738a788999e",
         intel: "f64b16d6d0f55efa16b7c90a4347bc4dbc505645eed6f7d03dc223bcab8f7506"

  url "https://github.com/t8y2/dbx/releases/download/v#{version}/dbx_#{version}_#{arch}.dmg"
  name "DBX"
  desc "Lightweight cross-platform database management tool"
  homepage "https://github.com/t8y2/dbx"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "dbx.app"

  zap trash: [
    "~/Library/Application Support/com.dbx.app",
    "~/Library/Caches/com.dbx.app",
    "~/Library/Logs/com.dbx.app",
    "~/Library/Preferences/com.dbx.app.plist",
    "~/Library/Saved Application State/com.dbx.app.savedState",
  ]

  caveats <<~EOS
    DBX is not signed with an Apple Developer ID. If macOS blocks it on first launch, run:
      xattr -cr /Applications/dbx.app

    Alternatively, open System Settings > Privacy & Security and choose "Open Anyway".
  EOS
end
