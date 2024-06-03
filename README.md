# warlock

## Symlinking `node_modules`

1. Symlink each package's `node_modules` directory to point into `bazel-bin`
    ```bash
    yq -r '.importers | keys | .[]' pnpm-lock.yaml | xargs -I{} ln -sF ../../bazel-bin/{}/node_modules {}
    ```
1. Build with Bazel (no `pnpm install` necessary)
    ```bash
    bazel build //...
    ```

## Symlinking `dist` + `pnpm install`

1. Symlink each package's `dist` directory to point into `bazel-bin`:
    ```bash
    yq -r '.importers | keys | map(select(. != ".")) | .[]' pnpm-lock.yaml | xargs -I{} ln -s ../../bazel-bin/{}/dist {}/dist
    ```
1. Run PNPM to setup `node_modules` in the source tree
    ```bash
    pnpm install
    ```
1. Build with Bazel
    ```bash
    bazel build //...
    ```

## Hard linking `dist` + `pnpm install`
1. Run PNPM to setup `node_modules` in the source tree
    ```bash
    pnpm install
    ```
1. Build with Bazel
    ```bash
    bazel build //...
    ```
1. Hard link each package's `dist` directory to mirror the contents of `bazel-bin`
    ```
    yq -r '.importers | keys | map(select(. != ".")) | .[]' pnpm-lock.yaml | xargs -I{} rsync -a --link-dest=$PWD/bazel-bin/{}/dist $PWD/bazel-bin/{}/dist {}
    ```
