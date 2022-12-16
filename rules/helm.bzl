load("@bazel_skylib//lib:shell.bzl", "shell")

def _helm_chart_release_impl(ctx):
    print("analyzing", ctx.executable._crbin.path)
    cmd = "{cr_path} upload -r {github_repo} -o {github_user} -t {github_token} --skip-existing".format(
        cr_path = ctx.executable._crbin.path,
        github_repo = ctx.attr.github_repo,
        github_user = ctx.attr.github_user,
        github_token = ctx.attr.github_token,
    )
    out = ctx.actions.declare_file("helm-release.sh")
    # ctx.actions.write(
    #     output = out,
    #     content = """#!/usr/bin/env bash
    #     set -e
    #     pwd
    #     {cr_path}/cr upload -r {github_repo} -o {github_user} -t {github_token} --skip-existing
    #     """.format(
    #     cr_path = ctx.executable._crbin.short_path,
    #     github_repo = ctx.attr.github_repo,
    #     github_user = ctx.attr.github_user,
    #     github_token = ctx.attr.github_token,
    # ))
    ctx.actions.run_shell(
        command = cmd,
        use_default_shell_env = True,
        tools = ctx.files._crbin,
        outputs = [out]
    )

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
        "_crbin": attr.label(
            default = Label("//rules:cr_runtime"),
            executable = True,
            allow_single_file = True,
            cfg = "host",
        ),
    },
    executable = True,
)
