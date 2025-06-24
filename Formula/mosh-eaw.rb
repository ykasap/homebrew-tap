class MoshEaw < Formula
  desc "Remote terminal application with East Asian Width hack"
  homepage "https://mosh.org"

  head "https://github.com/ykasap/mosh.git", branch: "east-asian-width", shallow: false

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  option "with-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on "tmux" => :build if build.with?("test") || build.bottle?

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
