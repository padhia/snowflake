{ lib
, stdenv
, fetchurl
, rpmextract
, patchelf
, makeWrapper
, openssl
, libxcrypt-legacy
}:

stdenv.mkDerivation rec {
  pname = "snowsql";
  version = "1.4.3";

  src = fetchurl {
    url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.4/linux_x86_64/snowflake-snowsql-${version}-1.x86_64.rpm";
    sha256 = "sha256-8+LG7KkkO5kYPHBpMnXXCXbZmJpc/mS/9JujHShw/ZU=";
  };

  nativeBuildInputs = [ rpmextract makeWrapper ];

  libPath = lib.makeLibraryPath [ openssl libxcrypt-legacy ];

  buildCommand = ''
    mkdir -p $out/bin/
    cd $out
    rpmextract $src
    rm -R usr/bin
    mv usr/* $out
    rmdir usr

    ${patchelf}/bin/patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        lib64/snowflake/snowsql/snowsql

    makeWrapper $out/lib64/snowflake/snowsql/snowsql $out/bin/snowsql \
      --set LD_LIBRARY_PATH "${libPath}":"${placeholder "out"}"/lib64/snowflake/snowsql \
  '';

  meta = with lib; {
    description = "Command line client for the Snowflake database";
    homepage = "https://www.snowflake.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ andehen padhia ];
    platforms = [ "x86_64-linux" ];
  };
}
