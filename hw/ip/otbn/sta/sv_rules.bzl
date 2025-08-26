def _sv2v_impl(ctx):
    outs = []
    for src in ctx.files.srcs:
        if not src.basename.endswith(".sv"):
            continue

        out = ctx.actions.declare_file("src/" + src.basename[:-3] + ".v")

        pkgs = []

        for f in ctx.files.pkgs:
           sp = f.short_path
           if sp.endswith("_pkg.sv") and sp.rsplit("/", 2)[-2] == "rtl":
               pkgs.append(f.path)

#        pkgs = [f.path for f in ctx.files.pkgs if f.basename.endswith("_pkg.sv")]
        inc_dirs = [f.dirname for f in ctx.files.includes]

#        print(" ".join(pkgs))

        args = ctx.actions.args()
        # Use src.path (absolute in exec sandbox), not src.short_path
        args.add_all([src.path, out.path, " ".join(pkgs), inc_dirs[0], " ".join(["--define="+d for d in ctx.attr.defines])])

        ctx.actions.run(
            inputs = [src] + ctx.files.pkgs + ctx.files.includes,
            outputs = [out],
            executable = ctx.executable.tool,
            arguments = [args],
            tools = [ctx.executable.tool],
            mnemonic = "SV2V",
            progress_message = "Converting %s → %s" % (src.short_path, out.basename),
        )
        outs.append(out)

    return DefaultInfo(files = depset(outs))


sv2v_rule = rule(
    implementation = _sv2v_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".sv"]),
        # The converter binary/script (e.g. sv2v). Runs in exec config.
        "tool": attr.label(executable = True, cfg = "exec"), #, allow_single_file = True),
        # Extra runtime files the tool might read (e.g. include files)
        "defines": attr.string_list(),
        "pkgs": attr.label_list(allow_files = True),
        "includes": attr.label_list(allow_files = True),
    },
)

