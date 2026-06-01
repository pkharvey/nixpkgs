{ lib
, stdenv
, fetchurl
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "e4thcom";
  version = "0.8.0";

  src = fetchurl {
    url =
      "https://forth-ev.de/wiki/res/lib/exe/fetch.php/projects:e4thcom:e4thcom-${version}-64.tar.gz";
    sha256 = "sha256-QVYKPioBPIULhT+3B50+6YIAIOqPNNOvlbLtczoZMDU="; # 0.8.0
    #sha256 = "sha256-RE6ZlK1Hdsh8BrOoQJwYtN8kqmAPBHTa5V9dEYTlw9o="; # 0.8.5.2
  };

  nativeBuildInputs = [ makeWrapper ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  buildPhase = ''
    runHook preBuild
    #(cd src && yes | ./make-e4thcom)
    (cd src && ./lxmake 64)
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/e4thcom

    install -m755 e4thcom $out/lib/e4thcom/e4thcom
    install -m644 e4thcom.i $out/lib/e4thcom/e4thcom.i
    makeWrapper $out/lib/e4thcom/e4thcom $out/bin/e4thcom \
      --chdir $out/lib/e4thcom

    cp *.efc $out/lib/e4thcom/
    cp *.efx $out/lib/e4thcom/
    cp *.efr $out/lib/e4thcom/

    install -Dm644 doc/e4thcom-${version}.pdf \
      $out/share/doc/e4thcom/e4thcom.pdf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Terminal for embedded Forth systems (eForth, Mecrisp, STM8, MSP430)";
    homepage = "https://forth-ev.de/wiki/doku.php/en:projects:e4thcom";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ pkharvey ];
  };
}
