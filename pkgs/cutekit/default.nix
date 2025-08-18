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
    rev = "676bc7ffb26a605dd51541c731b13ad492f45777";
    sha256 = "sha256-OrKhOC24ZQ9e3wljm90iIuLrGU+FsgmQlXy5q7cD930=";
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
