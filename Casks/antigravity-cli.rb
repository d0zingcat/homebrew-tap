cask "antigravity-cli" do
  arch arm: "darwin-arm/cli_mac_arm64", intel: "darwin-x64/cli_mac_x64"

  version "1.0.0"
  sha256 arm:   "65c2f7b5e27a21ef983b161ed75866e89139a682adf679000e1a5d9d374e320a",
         intel: "744a1a25dcf0bf6628e3add764d2155c44d7d174edf8b181a7427f7d9fb3fb53"

  url "https://storage.googleapis.com/antigravity-public/antigravity-cli/#{version}-5288553236791296/#{arch}.tar.gz",
      verified: "storage.googleapis.com/antigravity-public/"
  name "Antigravity CLI"
  desc "Google Antigravity command-line interface"
  homepage "https://antigravity.google/cli"

  livecheck do
    url "https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests/darwin_arm64.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :big_sur

  binary "antigravity", target: "antigravity-cli"

  postflight do
    system_command "#{HOMEBREW_PREFIX}/bin/antigravity-cli",
                   args:         ["install"],
                   must_succeed: false
    system_command "/usr/bin/xattr",
                   args:         ["-d", "com.apple.quarantine", "#{HOMEBREW_PREFIX}/bin/antigravity-cli"],
                   must_succeed: false
  end

  zap trash: "~/.cache/antigravity"
end
