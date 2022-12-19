load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def helm_chart_releaser_tools():
    http_archive(
        name = "cr",
        build_file_content = """exports_files(["cr"], visibility = ["//visibility:public"])""",
        url = "https://github.com/helm/chart-releaser/releases/download/v1.4.1/chart-releaser_1.4.1_linux_amd64.tar.gz",
    )
