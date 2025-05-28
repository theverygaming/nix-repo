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
    rev = "49383cdf2c8711a5681024b0ad01d0e8be529fcb";
    sha256 = "sha256-6HnV5Kb0VMh5STrQW+IN1yhcs2jyAEJOrDroWSEeqz8=";
  };

  patches = [
    ./nixos-support.patch
  ];

  propagatedBuildInputs = [
    graphviz
    dataclasses-json
  ];
}
