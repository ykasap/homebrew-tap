class MoshEaw < Formula
  desc "Remote terminal application with East Asian Width hack"
  homepage "https://mosh.org"
  license "GPL-3.0-or-later"

  head "https://github.com/ykasap/mosh.git", branch: "east-asian-width", shallow: false

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Keep C++ standard in sync with abseil.rb
    ENV.append "CXXFLAGS", "-std=c++17"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    # Prevent mosh from reporting `-dirty` in the version string.
    inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
    system "./autogen.sh"

    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
