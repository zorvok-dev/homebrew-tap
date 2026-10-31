class Zorvok < Formula
  desc "CocoaPods-compatible iOS dependency manager and package registry client"
  homepage "https://github.com/zorvok-dev/zorvok-ios"
  url "file:///tmp/zorvok-release/zorvok-ios-0.1.0.tar.gz"
  sha256 "697bfd8da9f1ff6dccd81d9a243e7625baf2f752051e196f27d30d68bab6ff50"
  license "MIT"
  head "https://github.com/zorvok-dev/zorvok-ios.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/zorvok-dev/zorvok-ios/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/zorvok"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zorvok --version")
    assert_match "USAGE", shell_output("#{bin}/zorvok --help")

    # `doctor` must run cleanly with no arguments and no network access —
    # it only inspects the local environment (brief: CLI must be
    # CI/scriptable-friendly).
    system bin/"zorvok", "doctor"
  end
end
