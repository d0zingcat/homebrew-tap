cask "antigravity-ide" do
  arch arm: "darwin-arm", intel: "darwin-x64"

  version "2.0.1"
  sha256 arm:   "6c82dfc620fe12ac47d06ec24a5e6da98bb12061cc2b597a8c568b07717e37aa",
         intel: "8d593e432bc4289a4daa192860c46f82cd6216c188c2b319adbcae8d5d769861"

  url "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/#{version}-4861014005645312/#{arch}/Antigravity%20IDE.dmg",
      verified: "edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/"
  name "Antigravity IDE"
  desc "Agent-first integrated development environment"
  homepage "https://antigravity.google/"

  livecheck do
    url "https://antigravity-auto-updater-974169037036.us-central1.run.app/"
    regex(/Stable\s+Version:\s*(\d+(?:\.\d+)+)/i)
  end

  depends_on macos: :big_sur

  app "Antigravity IDE.app"

  zap trash: [
    "~/Library/Application Support/Antigravity IDE",
    "~/Library/Caches/com.google.antigravity-ide",
    "~/Library/Preferences/com.google.antigravity-ide.plist",
    "~/Library/Saved Application State/com.google.antigravity-ide.savedState",
  ]
end
