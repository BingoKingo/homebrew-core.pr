class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.568.tar.gz"
  sha256 "1a70b3912424aba75d920688e14299d9320f02e62fa96542c0ac9092c41498ec"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc672e078729189c2da9f2b5eb737b6523961bdb6fa3ddc8a70e7e9235f2db06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ee759ea3c9856b102fba2081a68ce522fc4d8b3cee37d7de8b40d09016d8ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c3bc704dfa523febb5d45bb145fc0eab77b4bcef7f9e5e32a90d26381564d89"
    sha256 cellar: :any_skip_relocation, sonoma:        "6595d9eea0a2a09d35a63ab42e79be45117d7292e9277d40f395eb72ce84d0e5"
    sha256 cellar: :any_skip_relocation, ventura:       "40178f404576fd067199dffae27b74d1999db4b27f0ee4aa70e3f0358fe01b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d3a0ac38c8424ef53ac10af11bf060eb6d0e1bbd9c34c062bee2c188f9d1bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
