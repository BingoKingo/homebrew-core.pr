class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.45.8.tar.gz"
  sha256 "6045b1d4d5b70ef3e035a9d735dd9c41caa6db0124a024a07f4071759e0e72f0"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de03b809fb2b111d1e91ad6a103471837f4f4ebbcce4dd253511b4fc7e98d029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "439373bd31c3044aa3efd24509e095b0c37ef4b17e8b7ab5085e28e7b55abb67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12a2fa8a3e93f01ba7453d3f973b980861efa97689908afa0e67708374cf41e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f56d014e773a15b465a084250d3e8bb829ce309229fe697ebf3eab00fef83d"
    sha256 cellar: :any_skip_relocation, ventura:       "6828912ec1c70408413473bc9082da80752848e3c7c83684f4751b1923213304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83fad73c0b9af9b32064beb840215ff2f53305eb5294271577c00910167c401c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
