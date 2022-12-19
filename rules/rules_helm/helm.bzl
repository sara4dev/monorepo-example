load("@bazel_skylib//lib:shell.bzl", "shell")

def _helm_chart_package_impl(ctx):
    out_log = ctx.actions.declare_file("out.log")
    pkg_cmd = "{cr_path} package {src_path}/ >> {out_log}".format(
        cr_path = ctx.executable._crbin.path,
        src_path = ctx.files.srcs[0].dirname,
        out_log = out_log.path,
    )

    ctx.actions.run_shell(
        command = pkg_cmd,
        inputs = ctx.files.srcs,
        use_default_shell_env = True,
        tools = ctx.files._crbin,
        outputs = [out_log]
    )

    return [DefaultInfo(
        files = depset([out_log]),
    )]


helm_chart_package = rule(
    implementation = _helm_chart_package_impl,
    attrs = {
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True,
        ),
        "_crbin": attr.label(
            default = Label("//rules/rules_helm:chart_releaser_runtime"),
            executable = True,
            allow_single_file = True,
            cfg = "host",
        ),
    },
    executable = False,
)

def _helm_chart_release_impl(ctx):
    print("analyzing", )
    cmd = "{cr_path} upload -r {github_repo} -o {github_user} -t {github_token} --skip-existing".format(
        cr_path = ctx.executable._crbin.path,
        github_repo = ctx.attr.github_repo,
        github_user = ctx.attr.github_user,
        github_token = ctx.attr.github_token,
    )
    out = ctx.actions.declare_file("helm-release.sh")
    
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
            default = Label("//rules/rules_helm:chart_releaser_runtime"),
            executable = True,
            allow_single_file = True,
            cfg = "host",
        ),
    },
    executable = True,
)
