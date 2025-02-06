class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.0.tar.gz"
  sha256 "f6007412d5350f6bdc7c6ac6fc522139723520d6cd1d6ae0a348cfa66b2ce582"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12c40216386fbb2a42dd5e13ac7881965713147729a3320ab718ac71b10f1b65"
    sha256 cellar: :any,                 arm64_sonoma:  "a5df7ea4025f12dff44febfd2d628ed2d62a9a235df42a0b14a4c08f71adb40d"
    sha256 cellar: :any,                 arm64_ventura: "3c786d2a23fd6eedde28c98b88202e6ec1467a7b19ae89831b302629f5e38c70"
    sha256 cellar: :any,                 sonoma:        "08675e01f97c6e45269e49f08a7c76e044fbe6465eed8ee48f948174b4709341"
    sha256 cellar: :any,                 ventura:       "942d153cf0364327e988b4ca4978b7268a7bd7b0f37ce28e74ade83b93f83c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebf8426adae77f2e3db12e1b003f30f8581b5e795cd1728d2e44781de0d1cd6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = %W[
      -DDI_BUILD=Release
      -DDI_VERSION=#{version}
      -DDI_LIBVERSION=#{version}
      -DDI_SOVERSION=#{version.major}
      -DDI_RELEASE_STATUS=production
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end
