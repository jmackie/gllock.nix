# Based on:
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/screensavers/slock/default.nix
#
{ lib, stdenv, fetchFromGitHub, writeText, xorgproto, libXext, libX11, libXrandr
, glew, shader ? "circle" }:

let
  # https://github.com/kuravih/gllock/tree/master/shaders
  knownShaders = [
    "ascii"
    "blur"
    "bokeh"
    "circle"
    "crt"
    "glitch"
    "passthrough"
    "radialbokeh"
    "rain"
    "square"
  ];

in if !(lib.lists.elem shader knownShaders) then
  throw ("unknown shader: " ++ shader)
else
  let
    # Adapted from: 
    # https://github.com/kuravih/gllock/blob/master/config.mk
    mkConfig = version: ''
      # gllock version
      VERSION = ${version}

      # paths
      SHADER_LOCATION = $(out)/shaders

      # shader
      FRGMNT_SHADER = ${shader}.fragment.glsl

      PREFIX =
      DESTDIR = $(out)

      # TODO: I'm not sure this is right...
      X11INC = ${libX11.dev}/include
      X11LIB = ${libX11.dev}/lib

      # includes and libs
      INCS = -I. -I/usr/include -I$(X11INC)
      LIBS = -L/usr/lib -lc -lcrypt -L$(X11LIB) -lX11 -lGL -lGLEW -lpthread

      # flags
      CPPFLAGS = -DVERSION=\"$(VERSION)\" -DHAVE_SHADOW_H -DSHADER_LOCATION=\"$(SHADER_LOCATION)\" -DFRGMNT_SHADER=\"$(FRGMNT_SHADER)\"
      CFLAGS = -pedantic -Wall -Os $(INCS) $(CPPFLAGS)
      LDFLAGS = -s $(LIBS)

      # compiler and linker
      CC = cc
    '';

  in stdenv.mkDerivation rec {
    pname = "gllock";
    version = "0.1-alpha";

    src = fetchFromGitHub {
      owner = "kuravih";
      repo = "gllock";
      rev = "8123a6566e4e11f54b2ec1bd9469129fc44cd03b";
      sha256 = "145012lfdsrc58vdidy6vz4l324ihq35k83gxjbyv472xz6rx6nj";
    };

    buildInputs = [
      glew

      # These are naively copied from the slock derivation and may not all be
      # necessary...
      xorgproto
      libX11
      libXext
      libXrandr
    ];

    postPatch = "sed -i '/chmod u+s/d' Makefile"; # not allowed

    preBuild = ''
      cp ${writeText "config.mk" (mkConfig version)} config.mk
    '';

    # Remove the symlink to the build directory and copy files instead
    postFixup = ''
      rm $out/shaders
      cp -vR shaders $out/
    '';
  }
