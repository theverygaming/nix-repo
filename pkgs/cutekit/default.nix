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
    rev = "437084b9f917f56031b716f3306b210fca6b8e4f";
    sha256 = "sha256-+m/CcECzTwkuxeVo4XgwoBEGBD16/9Y4IKWrtaarCpo=";
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
