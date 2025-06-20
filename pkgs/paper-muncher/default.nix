{
  lib,
  stdenv,
  overrideCC,
  fetchFromGitHub,
  cutekit,
  pkg-config,
  llvmPackages_20,
  ninja,
  jq,
  liburing,
  libseccomp,
  git,
  cacert,
}:

(overrideCC stdenv (
  llvmPackages_20.libcxxStdenv.cc.override {
    inherit (llvmPackages_20) bintools;
  }
)).mkDerivation
  (
    finalAttrs:
    let
      cutekitDeps = stdenv.mkDerivation {
        name = "cutekit-deps";

        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-/djSIz/KQVZLgEHzTAiKf59lA/VLuF0u7m0dQqYXGFk=";

        nativeBuildInputs = [
          cutekit
          git
          cacert
          pkg-config
        ];

        src = fetchFromGitHub {
          owner = "odoo";
          repo = "paper-muncher";
          rev = "24207ed14965963db378d1424b3587917128edf8";
          sha256 = "sha256-iESoMYMVpHXm9P5PurdJl92KubyTnVXq4c9vs5cCjEY=";
        };

        buildPhase = ''
          runHook preBuild

          export CUTEKIT_HOME=$(mktemp -d)
          HOME="$CUTEKIT_HOME" IN_NIX_SHELL=":3" cutekit model install

          find .cutekit/extern -type d -name .git -exec rm -rf {} +

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
      pname = "paper-muncher";
      version = "nightly";

      src = fetchFromGitHub {
        owner = "odoo";
        repo = "paper-muncher";
        rev = "24207ed14965963db378d1424b3587917128edf8";
        sha256 = "sha256-iESoMYMVpHXm9P5PurdJl92KubyTnVXq4c9vs5cCjEY=";
      };

      nativeBuildInputs = [
        cutekit
        pkg-config
        ninja
        llvmPackages_20.clang-tools # https://github.com/NixOS/nixpkgs/issues/214945 - clang-scan-deps is not wrapped and will fail to find the stdlib otherwise!
        jq
      ];

      buildInputs = [
        liburing
        libseccomp
      ];

      buildPhase = ''
        runHook preBuild

        export CUTEKIT_HOME=$(mktemp -d)
        mkdir -p $CUTEKIT_HOME/.cutekit/
        ln -s ${cutekitDeps} $CUTEKIT_HOME/.cutekit/extern

        HOME="$CUTEKIT_HOME" IN_NIX_SHELL=":3" cutekit build --release --props:prefix=$out paper-muncher

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        HOME="$CUTEKIT_HOME" IN_NIX_SHELL=":3" cutekit install --release --prefix=$out --sysroot=/ paper-muncher

        runHook postInstall
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck

        TMPDIR=$(mktemp -d)

        cat << EOF > $TMPDIR/test.html
        <!DOCTYPE html>
        <html>
        <head>
        <title>meow</title>
        </head>
        <body>
        <h1>meeeow</h1>
        <p>maaaow mrrp :3</p>
        </body>
        </html>
        EOF

        $out/bin/paper-muncher --unsecure print $TMPDIR/test.html -o $TMPDIR/test.pdf
        grep "Powered By Karm PDF" $TMPDIR/test.pdf

        runHook postInstallCheck
      '';
    }
  )
