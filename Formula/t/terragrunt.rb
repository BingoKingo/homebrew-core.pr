class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.73.9.tar.gz"
  sha256 "ddc54dbfeca6912547201d804dbb5e8d69f6c067551868c2257f34d9110d0045"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92118702cd08140b49b4153c6a92fa8db162e2e0215dbbbd26901aee8bb6c3d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92118702cd08140b49b4153c6a92fa8db162e2e0215dbbbd26901aee8bb6c3d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92118702cd08140b49b4153c6a92fa8db162e2e0215dbbbd26901aee8bb6c3d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "57014dbf3270c74f76fab9e9fdb5ea54783adaa7136d70bcadcad613ff8277e1"
    sha256 cellar: :any_skip_relocation, ventura:       "57014dbf3270c74f76fab9e9fdb5ea54783adaa7136d70bcadcad613ff8277e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f9bae14eb3af33a8189921dc4a24a8df60c3633dae9a1cced5fd89112dd83f"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
