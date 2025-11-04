{
  lib,
  stdenv,
  overrideCC,
  llvmPackages,
  cutekit,
  pkg-config,
  git,
  cacert,
  ninja,
  jq,
}:

let
  ckStdenv = (
    overrideCC stdenv (
      llvmPackages.libcxxStdenv.cc.override {
        inherit (llvmPackages) bintools;
      }
    )
  );
in
lib.extendMkDerivation {
  constructDrv = ckStdenv.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      name ? "${args.pname}-${args.version}",
      src ? null,
      nativeBuildInputs ? [ ],

      ckDepsHash ? "",
      ckComponent ? "",
      ...
    }@args:
    let
      cutekitExternDeps = ckStdenv.mkDerivation {
        name = "${name}-cutekit-deps";

        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = ckDepsHash;

        inherit src;

        nativeBuildInputs = [
          cutekit
          pkg-config
          git
          cacert
        ];

        # we remove all git hooksfrom the sources because they would get patched and then contain nix store paths
        # which is not allowed for fixed-output derivations..
        buildPhase = ''
          runHook preBuild

          HOME="$(mktemp -d)" IN_NIX_SHELL=":3" cutekit install
          find .cutekit/extern -type d -path "*/.git/hooks" -exec rm -rf {} +

          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall

          cp -r .cutekit/extern $out

          runHook postInstall
        '';
      };
    in
    {
      nativeBuildInputs = [
        cutekit
        pkg-config
        ninja
        llvmPackages.clang-tools # https://github.com/NixOS/nixpkgs/issues/214945 - clang-scan-deps is not wrapped and will fail to find the stdlib otherwise!
        jq
        git
      ] ++ nativeBuildInputs;

      buildPhase = ''
        export CUTEKIT_HOME=$(mktemp -d)
        mkdir -p $CUTEKIT_HOME/.cutekit/
        ln -s ${cutekitExternDeps} $CUTEKIT_HOME/.cutekit/extern
        export GIT_CONFIG_GLOBAL="$(mktemp)"
        git config --file "$GIT_CONFIG_GLOBAL" --add safe.directory '*'

        runHook preBuild

        HOME="$CUTEKIT_HOME" IN_NIX_SHELL=":3" cutekit build --release --props:prefix=$out ${ckComponent}

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        HOME="$CUTEKIT_HOME" IN_NIX_SHELL=":3" cutekit package --release --prefix=$out --sysroot=/ ${ckComponent}

        runHook postInstall
      '';
    };
}
