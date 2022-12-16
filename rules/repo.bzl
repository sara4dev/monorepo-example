load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# def _helm_chart_releaser_tool_impl(ctx):
#     ctx.report_progress("downloading")
#     ctx.download_and_extract(
#         "https://github.com/helm/chart-releaser/releases/download/v1.4.1/chart-releaser_1.4.1_linux_amd64.tar.gz",
#         sha256 = "96607338be59ba35101e3d8ff8d8cd36db5289ccb992a00b9a161001e26774ae",
#         )
#     ctx.report_progress("extracting")
#     ctx.file("BUILD.bazel", 'exports_files(["cr"]) , visibility = ["//visibility:public"])')
#     ctx.delete("chart-releaser_1.4.1_linux_amd64.tar.gz")
    

# helm_chart_releaser_tool = repository_rule(
#     implementation = _helm_chart_releaser_tool_impl,
# )


def helm_chart_releaser_tools():
    http_archive(
        name = "cr",
        build_file_content = """exports_files(["cr"], visibility = ["//visibility:public"])""",
        url = "https://github.com/helm/chart-releaser/releases/download/v1.4.1/chart-releaser_1.4.1_linux_amd64.tar.gz",
    )
