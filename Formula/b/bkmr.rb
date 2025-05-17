class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.22.3.tar.gz"
  sha256 "3d3dd95c2a787c7530fb5d58faa1167e3d503158683e66e50a765a672aafcbc2"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05df7f5cd7fa1d1f9dcca18c09a2f56678d47e757de228ac0af4430702f7c3f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c21ec3072556e42db18f90841cff443dc982e12562e3abcb1d78d739a2d8553"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "051559244f9da17ad2f96d3d0537ab13ee7eb99541be28dedcfbebc696483024"
    sha256 cellar: :any_skip_relocation, sonoma:        "f257755357b9966d73ff05d29cf1539754695a2ff93ebb58519604beed866193"
    sha256 cellar: :any_skip_relocation, ventura:       "dcb441e08657c67e07ed124a9351577ec5a4c9947a4142ada500ca62fe0eeba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50302d9da04630bc7b6c624621fb04942441792d5c666bf78676b7e47400221d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146a4697f35129596e1e13ba43baabdb10e17faa85944fa2fd180d971e955ad6"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
