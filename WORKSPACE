load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "googleapis",
    sha256 = "9d1a930e767c93c825398b8f8692eca3fe353b9aaadedfbcf1fca2282c85df88",
    strip_prefix = "googleapis-64926d52febbf298cb82a8f472ade4a3969ba922",
    urls = [
        "https://github.com/googleapis/googleapis/archive/64926d52febbf298cb82a8f472ade4a3969ba922.zip",
    ],
)
load("@googleapis//:repository_rules.bzl", "switched_rules_by_language")
switched_rules_by_language(
    name = "com_google_googleapis_imports",
)



#load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
#
#http_archive(
#    name = "rules_rust",
#    sha256 = "049fe1866e36f7c46cd266b66bad160a9a792e90e5ddd2baeae48fadeea94832",
#    urls = ["https://github.com/bazelbuild/rules_rust/releases/download/0.34.0/rules_rust-v0.34.0.tar.gz"],
#)
#
#load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains")
#
#rules_rust_dependencies()
#
#rust_register_toolchains()