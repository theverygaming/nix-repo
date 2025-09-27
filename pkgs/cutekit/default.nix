{
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  graphviz,
  dataclasses-json,
}:

buildPythonApplication {
  pname = "cutekit";
  version = "nightly";
  pyproject = true;

  build-system = [
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "cute-engineering";
    repo = "cutekit";
    rev = "620ace3bedef82b03af2dd02f30cf3baa08fdb5f";
    sha256 = "sha256-VZAaB9Ckl/Q/Lc0LXHP4eNY7S2agkGPtoTUUQGHhbxs=";
  };

  patches = [
    ./nixos-support.patch
    ./requirements.patch
  ];

  propagatedBuildInputs = [
    graphviz
    dataclasses-json
  ];
}
