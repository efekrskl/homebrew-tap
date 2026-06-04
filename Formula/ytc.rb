class Ytc < Formula
  desc "YouTube chat in the terminal."
  homepage "https://github.com/efekrskl/youtube-chat-rs"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/efekrskl/youtube-chat-rs/releases/download/v0.1.1/youtube-chat-rs-aarch64-apple-darwin.tar.xz"
      sha256 "98f6bc71b682ee020fbbfab3b87adfdfa71a1ba8c6adac9337bc339fcd71f1db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/efekrskl/youtube-chat-rs/releases/download/v0.1.1/youtube-chat-rs-x86_64-apple-darwin.tar.xz"
      sha256 "4ed89ad2311bf389634f1f7d5eb30621922d1d9022dbdb1c934e5c8e4eae9470"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/efekrskl/youtube-chat-rs/releases/download/v0.1.1/youtube-chat-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b5ba005d77b98f2e3f2b97ad3c4f83009d1dfdbf2a9794903cb8c9c849c105c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/efekrskl/youtube-chat-rs/releases/download/v0.1.1/youtube-chat-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2e8a409a93ed013ca451d8abeaa44dce76f672a68774cce09cfda571bbd9fd06"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ytc" if OS.mac? && Hardware::CPU.arm?
    bin.install "ytc" if OS.mac? && Hardware::CPU.intel?
    bin.install "ytc" if OS.linux? && Hardware::CPU.arm?
    bin.install "ytc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
