class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.64.4",
        revision: "04aec4f787c25a737641f3d434059880d2af0f53"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff6934550e6c9d569ab6d7095877b6d0b7c9fd24b24323bf88b93f3ddf4184d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1b95780aaa5aca6b2976d77385219d947e87506ac7fb72e15dff9bc4a412052"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53317789dbb552b29667a91b53693332161a0e57a430fef6e9ab7525aa33d522"
    sha256 cellar: :any_skip_relocation, sonoma:        "26378f7b74cb02a947f6d2811e9140d60ee06cc26c693b506873cbbd7d2e7569"
    sha256 cellar: :any_skip_relocation, ventura:       "0eff7791e51ea56e6f05cc280f2afd73801e20b331a5b1b62df89a59fc19ac5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d977eec6a83b5d7f72604d718a910a74fa944b494cd7183d95bae3b652650cf"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end
