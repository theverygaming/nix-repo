# From: https://github.com/nix-community/nur-packages-template/tree/217bb6ddda79da71ff514dac0af80f70525849dc

# MIT License

# Copyright (c) 2018 Francesco Gazzetta

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

{
  pkgs ? import <nixpkgs> { },
}:

rec {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  # VLF tooling
  ebnaut = pkgs.callPackage ./pkgs/ebnaut { };
  ebsynth = pkgs.callPackage ./pkgs/ebsynth { };
  vlfrx-tools = pkgs.callPackage ./pkgs/vlfrx-tools { };

  # fox32 tooling
  fox32asm = pkgs.callPackage ./pkgs/fox32asm { };

  cutekit = pkgs.python3Packages.callPackage ./pkgs/cutekit { };
  buildCutekitPackage = pkgs.callPackage ./pkgs/buildCutekitPackage { inherit cutekit; };

  paper-muncher = pkgs.callPackage ./pkgs/paper-muncher { inherit buildCutekitPackage; };

  kicadAddons = pkgs.lib.recurseIntoAttrs {
    jlcpcb-tools = pkgs.kicad.callPackage ./pkgs/kicadAddons/jlcpcb-tools { };
  };

  splat = pkgs.callPackage ./pkgs/splat { };
}
