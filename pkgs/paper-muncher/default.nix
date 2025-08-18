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
    rev = "a6a82f2806318fac885d2220965624dd22f188ac";
    sha256 = "sha256-oAYuUINxhRiBNjwzgzhQ9tBZHAXXeX8nSY9xKpPeO7U=";
  };

  ckComponent = "paper-muncher";
  ckDepsHash = "sha256-AIAV3kPEiu8TpfC1Ed0GVAhu+wv62U8wXwdvi4EJnUA=";

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
