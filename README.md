# utc

The universal transpiler collection

## Usage

1. Add `utc` as a dependency in your `build.zig.zon`
```zig
.{
    .name = "<name_of_your_package>",
    .version = "<version_of_your_package>",
    .dependencies = .{
        .zodbc = .{
            .url = "https://github.com/rupurt/utc/archive/<git_tag_or_commit_hash>.tar.gz",
            .hash = "<package_hash>",
        },
    },
}
```

Set `<package_hash>` to `12200000000000000000000000000000000000000000000000000000000000000000`, and Zig will provide the correct found value in an error message.

2. Add `utc` as a dependency module in your `build.zig`
```zig
// ...
const utc_dep = b.dependency("utc", .{ .target = target, .optimize = optimize });
exe.root_module.addImport("utc", zodbc_dep.module("utc"));
```

## Development

```shell
> nix develop -c $SHELL
```

```shell
> make
```

```shell
> make test
```

```shell
> make run
```

```shell
> make clean
```

```shell
> make build
```

```shell
> make exec
```

# License

`utc` is released under the [MIT license](./LICENSE)
