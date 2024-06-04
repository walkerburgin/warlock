load("@aspect_rules_js//js:defs.bzl", "js_library")
load("@aspect_rules_ts//ts:defs.bzl", "ts_project", "ts_config")
load("@npm//:defs.bzl", "npm_link_all_packages")
load("@npm//:vite/package_json.bzl", vite_bin = "bin")

def library_npm_package():
    name = Label("//" + native.package_name()).name

    npm_link_all_packages(name = "node_modules")

    tsconfig = "{name}_tsconfig".format(name = name)
    ts_config(
        name = tsconfig,
        src = "tsconfig.json",
        deps = [":node_modules"]
    )

    ts_project(
        name = "dist",
        srcs = native.glob(["src/**"]),
        assets = native.glob(["src/**"], exclude=["**/*.ts", "**/*.tsx"]),
        tsconfig = tsconfig,
        composite = True,
        declaration = True,
        declaration_map = True,
        out_dir = "dist",
        root_dir = "src",
        source_map = True,
        deps = [
            ":node_modules",
            "//:node_modules",
        ],
    )

    js_library(
        name = name,
        srcs = [
            "package.json",
            ":dist"
        ],
        data = [":node_modules"],
        visibility = ["//visibility:public"]
    )

def bundle_npm_package():
    name = Label("//" + native.package_name()).name

    npm_link_all_packages(name = "node_modules")

    tsconfig = "{name}_tsconfig".format(name = name)
    ts_config(
        name = tsconfig,
        src = "tsconfig.json",
        deps = [":node_modules"]
    )

    ts_project(
        name = "typescript",
        root_dir = "src",
        srcs = native.glob(["src/**"]),
        assets = native.glob(["src/**"], exclude = ["**/*.ts", "**/*.tsx"]),
        tsconfig = tsconfig,
        composite = True,
        deps = [":node_modules", "//:node_modules"],
        declaration = True,
        declaration_map = True,
        source_map = True,
        out_dir = "build/ts",
    )

    vite_bin.vite(
        name = "dist",
        srcs = ["package.json", ":typescript", "vite.config.mts", "index.html"],
        chdir = native.package_name(),
        args = [
            "build",
            "--config",
            "vite.config.mts",
            "-m",
            "production",
        ],
        env = {
            "FORCE_COLOR": "1",
        },
        out_dirs = ["dist"],
        silent_on_success = False,
        visibility = ["//visibility:public"],
    )

    vite_bin.vite_binary(
        name = "dev",
        data = ["package.json", ":typescript", "vite.config.mts", "index.html"],
        chdir = native.package_name(),
        args = [
            "--config",
            "vite.config.mts",
            "--force",
        ],
        env = {
            "FORCE_COLOR": "1",
        },
        visibility = ["//visibility:public"],
    )

    js_library(
        name = name,
        srcs = [
            "package.json",
            ":dist"
        ],
        data = [":node_modules"],
        visibility = ["//visibility:public"]
    )