load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_skylib//lib:shell.bzl", "shell")

def _helm_chart_release_impl(ctx):
    print("analyzing", ctx.label)
    # cmd = "cr upload -r {github_repo} -o {github_user} -t {github_token} --skip-existing >> {out_file}".format(
    #     github_repo = ctx.attr.github_repo,
    #     github_user = ctx.attr.github_user,
    #     github_token = ctx.attr.github_token,
    #     out_file = shell.quote(out.path)
    # )
    out = ctx.actions.declare_file("helm-release.sh")
    ctx.actions.write(
        output = out,
        content = """#!/usr/bin/env bash
        set -e
        pwd
        {cr_path}/cr upload -r {github_repo} -o {github_user} -t {github_token} --skip-existing
        """.format(
        cr_path = ctx.attr._cr_path,
        github_repo = ctx.attr.github_repo,
        github_user = ctx.attr.github_user,
        github_token = ctx.attr.github_token,
    ))
    # ctx.actions.run_shell(
    #     command = cmd,
    #     use_default_shell_env = True,
    #     outputs = [out]
    # )

    return [DefaultInfo(
        files = depset([out]),
        executable = out,
    )]

helm_chart_release = rule(
    implementation = _helm_chart_release_impl,
    attrs = {
        "github_repo": attr.string(default = "monorepo_example"),
        "github_user": attr.string(default = "sara4dev"),
        "github_token": attr.string(mandatory = True),
        "_cr_path": attr.label(default = "@//:cr")
    },
    executable = True,
)


def _helm_chart_releaser_download_impl(ctx):
    ctx.report_progress("downloading")
    ctx.download_and_extract(
        "https://github.com/helm/chart-releaser/releases/download/v1.4.1/chart-releaser_1.4.1_linux_amd64.tar.gz",
        sha256 = "96607338be59ba35101e3d8ff8d8cd36db5289ccb992a00b9a161001e26774ae",
        )
    ctx.report_progress("extracting")
    ctx.file("BUILD.bazel", 'exports_files(["cr"])')
    # ctx.delete("chart-releaser.tar.gz")
    

helm_chart_releaser_download = repository_rule(
    implementation = _helm_chart_releaser_download_impl,
)
