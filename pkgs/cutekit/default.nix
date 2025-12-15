{
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  graphviz,
  dataclasses-json,
}:

buildPythonApplication {
  pname = "cutekit";
  version = "0.10.7";
  pyproject = true;

  build-system = [
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "cute-engineering";
    repo = "cutekit";
    rev = "eb95ee85f77603db5dda57f8290459dafbc0d171";
    sha256 = "sha256-K8VshFM+2mWPk5FamDZqmJOYIaAdc7Qa9uL3YimMn2g=";
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
