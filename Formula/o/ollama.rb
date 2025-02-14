class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.5.10",
      revision: "c03e2487355047963c9f32b0ab480901b2671731"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9ed7eb67408d9cec94f664f69f7b83aadc14422c563869f9f0283a493bfb8ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0429c76633eae573a975b93439f9f1749784e7bdce0c9b9f0bb27d58ef229ba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55d834f494d310e659e00f16e4a20ed65b0a3fc728abd8cf9b455c893de95174"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8381de55b7d1333dc6ac6e769d665ceeea400dfbdba43e434242af5f25bdec0"
    sha256 cellar: :any_skip_relocation, ventura:       "8699cae342e330489d999f5ab37b58fae00734192e0b5d4bf69b01b510877a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa6584ccdb9615ae9594306851a909e5bcf27959487ec56104e938d37e6ccc3"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Silence tens of thousands of SDK warnings
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    ldflags = %W[
      -s -w
      -X=github.com/ollama/ollama/version.Version=#{version}
      -X=github.com/ollama/ollama/server.mode=release
    ]

    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec bin/"ollama", "serve" }
    sleep 3
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
