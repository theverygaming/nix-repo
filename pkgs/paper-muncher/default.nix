{
  buildCutekitPackage,
  fetchFromGitHub,
  llvmPackages_20,
  liburing,
  libseccomp,
}:

let
  llvm20buildCutekitPackage = (
    buildCutekitPackage.override {
      llvmPackages = llvmPackages_20;
    }
  );
in
llvm20buildCutekitPackage (finalAttrs: {
  pname = "paper-muncher";
  version = "nightly";

  src = fetchFromGitHub {
    owner = "odoo";
    repo = "paper-muncher";
    rev = "24207ed14965963db378d1424b3587917128edf8";
    sha256 = "sha256-iESoMYMVpHXm9P5PurdJl92KubyTnVXq4c9vs5cCjEY=";
  };

  ckComponent = "paper-muncher";
  ckDepsHash = "sha256-/djSIz/KQVZLgEHzTAiKf59lA/VLuF0u7m0dQqYXGFk=";

  buildInputs = [
    liburing
    libseccomp
  ];

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
})
