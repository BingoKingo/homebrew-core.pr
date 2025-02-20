class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v20.15.4.tar.gz"
  sha256 "4f7020142114616ad1f96272e5d3e5959dd09b6cd1a7a8846c65956aab1b1709"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32ba6788148895835c258ec084cbf4220ecafa23f8aa8b09b7efc58da3ca1a7d"
    sha256 cellar: :any,                 arm64_sonoma:  "275d73533481113d0d6baa94bf2c5e45a8f05ad9de7ba2de3ad74b9323af2702"
    sha256 cellar: :any,                 arm64_ventura: "a5a5938f6b68b5d521c402cbb7efeb9652956703131f3fffc2551bb10cf53cbc"
    sha256                               sonoma:        "9d242a812d54cf0b1dd20998c4b094a4105f389a044ef6173422e733fc8822d1"
    sha256                               ventura:       "0848948b90d17c36556074cb46ad71b24b4aef91b4c3f92f5a659af33965069d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9ee8786e21b4e38db4a0fd3d581f7b8f2f58863ec9fee0e796ae4dae743473"
  end

  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    # Avoid passing -march=native to gfortran
    inreplace "Makefile", "-march=native", ENV["HOMEBREW_OPTFLAGS"] if build.bottle?

    system "./configure"
    system "make"
    bin.install "packmol"
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
