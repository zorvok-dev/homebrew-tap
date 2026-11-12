class Zorvok < Formula
  desc "CocoaPods-compatible iOS dependency manager and package registry client"
  homepage "https://github.com/zorvok-dev/zorvok-ios"
  url "https://github.com/zorvok-dev/zorvok-ios/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "b991b0d31b0c01c2718455a2ebfc04935efb32f8af10978cd1dc04f430453dbc"
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
