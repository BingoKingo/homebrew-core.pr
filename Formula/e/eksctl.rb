class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.203.0",
      revision: "00788c83782ee147c602698393d96ed50dde61ec"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bea552f9d81b62d5a53973af929c82f66288b6795bcf7c18db43f19c6b70d5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c28b6dc430756329d46668989a4eba7c125d1e18f2320e91a60420db3f509e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80ff5949907f4e87d6c260e1db19db4b926e5cefbb795ab423619a6493374f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ecf18f8c2186895d23712a62101d172cdc71b002cb7376d47fcc03c63d2368a"
    sha256 cellar: :any_skip_relocation, ventura:       "27bac6b0d8e693739bba37c453ec03ab15a076b1da7e1f6d957ceb416fb1baf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d440beb94532a2b45ea204cc96f5350bdf5ad607ba7e50b18ea1c376409b9c3"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
