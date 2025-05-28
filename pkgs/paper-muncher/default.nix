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
}:

(overrideCC stdenv (
  llvmPackages_20.libcxxStdenv.cc.override {
    inherit (llvmPackages_20) bintools;
  }
)).mkDerivation
  (
    finalAttrs:
    let
      cutekitDeps = {
        "skift-org/karm" = fetchFromGitHub {
          owner = "skift-org";
          repo = "karm";
          rev = "0b2522ab29c74ad281ae74a6b797f671529e6723";
          sha256 = "sha256-0mOfrukMK6x0l/9o8nlDC5akdz+LbfP4+xp8GRT3yhc=";
        };
        # start deps of karm
        "cute-engineering/ce-heap" = fetchFromGitHub {
          owner = "cute-engineering";
          repo = "ce-heap";
          rev = "v1.1.0";
          sha256 = "sha256-ZBZa1KBgHrHFb4A2I9JtmeUDvwx9A1rNdCopnqfDKtc=";
        };
        "cute-engineering/ce-mdi" = fetchFromGitHub {
          owner = "cute-engineering";
          repo = "ce-mdi";
          rev = "v0.5.0";
          sha256 = "sha256-PfY2qYzN2xBU1EePAWGa4HVY1+tUVDpP0T9veISXl74=";
        };
        "cute-engineering/ce-libc" = fetchFromGitHub {
          owner = "cute-engineering";
          repo = "ce-libc";
          rev = "v1.1.0";
          sha256 = "sha256-98JfUC1b/NwJrOhNupBiEKRnvBzbAbj3nqsHB6+eS3M=";
        };
        "cute-engineering/ce-libm" = fetchFromGitHub {
          owner = "cute-engineering";
          repo = "ce-libm";
          rev = "v1.0.2";
          sha256 = "sha256-104yYq+9nFZs/V2XVgpQUNKaAUmsYhCOLjjSCWgUzNA=";
        };
        "cute-engineering/ce-stdcpp" = fetchFromGitHub {
          owner = "cute-engineering";
          repo = "ce-stdcpp";
          rev = "v1.3.0";
          sha256 = "sha256-bxvwbMU8rVYYWyfPVBV8ILN3L7+0Gv4bvsCEqKijG9Q=";
        };
        "cute-engineering/ce-targets" = fetchFromGitHub {
          owner = "cute-engineering";
          repo = "ce-targets";
          rev = "v0.2.0";
          sha256 = "sha256-574EljeU+eaTWeFnqh3AM9F9wWDEDcdKPnE4DlC+bbo=";
        };
        # end deps of karm
        "skift-org/hideo" = fetchFromGitHub {
          owner = "skift-org";
          repo = "hideo";
          rev = "f8e944e8cf2156ae4ea575813ace1b2e4f78520c";
          sha256 = "sha256-mE1I02mIgTarvhOiHskclDeSKzEeQK9E9BUwf74kM9c=";
        };
        # hideo depends on karm, but we already have that
        "cute-engineering/cat" = fetchFromGitHub {
          owner = "cute-engineering";
          repo = "cat";
          rev = "v0.10.0";
          sha256 = "sha256-vjsvAfmoUIlwoSefYXuoUjwxFW0htizzqP5V13P7taI=";
        };
      };
    in
    {
      pname = "paper-muncher";
      version = "nightly";

      src = fetchFromGitHub {
        owner = "odoo";
        repo = "paper-muncher";
        rev = "f7f9c30b2c9ebc8dcba4f5f04c9015d5eeb8704b";
        sha256 = "sha256-CEX6S1sYk3KGs79GuT0qMAFRsIXy7FwYBpJaDKPjQJk=";
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
        mkdir -p ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (k: v: "$(dirname $CUTEKIT_HOME/.cutekit/extern/${k})") cutekitDeps
          )
        }
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "ln -s ${v} $CUTEKIT_HOME/.cutekit/extern/${k}") cutekitDeps
        )}
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
