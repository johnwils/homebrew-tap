cask "windrose" do
  version "0.7.4"
  sha256 "442d4f4fe107f50e611b2e1f4569b1f0662e2f559770a49df2c70a1f303e8c81"

  url "https://updates.index9.dev/windrose/releases/Windrose-#{version}.dmg",
      verified: "updates.index9.dev/windrose/"
  name "Windrose"
  desc "Fan control for Apple Silicon Macs"
  homepage "https://index9.dev/windrose"

  livecheck do
    url "https://updates.index9.dev/windrose/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  # Real floor is macOS 13.3 (LSMinimumSystemVersion). Homebrew can only say
  # Ventura (13.0); macOS itself refuses to launch the app below 13.3.
  depends_on macos: ">= :ventura"

  app "Windrose.app"

  uninstall quit: "dev.index9.windrose"

  # The fan service is an SMAppService daemon that Homebrew can't unregister.
  # Run Windrose's own "Uninstall Windrose…" first. zap then sweeps the same
  # paths it removes. The Pro licence (Keychain) and the cache shared with
  # Whetstone (~/Library/Caches/telemetrysignalcache) are deliberately kept.
  zap delete: "/Library/Application Support/Windrose",
      trash:  [
        "~/Library/Application Support/Windrose",
        "~/Library/Caches/dev.index9.windrose",
        "~/Library/HTTPStorages/dev.index9.windrose",
        "~/Library/Preferences/dev.index9.windrose.plist",
        "~/Library/Saved Application State/dev.index9.windrose.savedState",
        "~/Library/WebKit/dev.index9.windrose",
      ]

  caveats <<~EOS
    Windrose must stay in /Applications for its fan service to register.
    To remove it, use Uninstall Windrose… in Windrose's ⋯ or status menu.
    It removes the fan service cleanly; `brew uninstall --zap` can't.
  EOS
end
