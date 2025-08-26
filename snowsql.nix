{ lib
, stdenv
, fetchurl
, rpmextract
, patchelf
, makeWrapper
, libz
, openssl
, libxcrypt-legacy
}:

stdenv.mkDerivation rec {
  pname = "snowsql";
  version = "1.4.4";

  src = let
    sources = {
      x86_64-linux = {
        url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.4/linux_x86_64/snowflake-snowsql-${version}-1.x86_64.rpm";
        sha256 = "sha256-rLUOMZySCkc/eM4T0A29ULvaZvqOuep2ycFNmKtv6J8=";
      };
      aarch64-linux = {
        url = "https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.4/linux_aarch64/snowflake-snowsql-${version}-1.aarch64.rpm";
        sha256 = "sha256-Ol+N/trv2ay6j1UAuzwD6IEIk3UNhcZhRfMEBXzsyOs=";
      };
    };
  in fetchurl sources."${stdenv.system}";

  nativeBuildInputs = [ rpmextract makeWrapper ];

  libPath = lib.makeLibraryPath [
    libz
    openssl
    libxcrypt-legacy
  ];

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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
