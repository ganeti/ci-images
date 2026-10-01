#!/bin/bash

set -eu

# pcre old
#LIBGHC_REGEX="libghc-regex-pcre-dev libpcre3-dev"
# pcre new
#LIBGHC_REGEX="libghc-regex-pcre2-dev libpcre2-dev"
# tdfa (new default)
LIBGHC_REGEX="libghc-regex-tdfa-dev"

# set DISTRIBUTION
case ${RELEASE} in
	focal|jammy|noble|resolute)
		DISTRIBUTION=ubuntu
		;;
	*)
		DISTRIBUTION=debian
		;;
esac

# set PYTHON
case ${RELEASE} in
	focal|jammy)
		PYTHON=python
		;;
	*)
		PYTHON=python3
		;;
esac

# extras
case ${RELEASE} in
        # old distros
	focal|jammy)
		EXTRA="libcurl4-openssl-dev"
		;;
        # new distros with >=python-3.12, where Ganeti-3.1 should run
	trixie|noble|resolute)
		EXTRA="python3-pyasyncore"
		;;
esac

cat << EODF
FROM ${DISTRIBUTION}:${RELEASE}
ARG         DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y dist-upgrade

RUN apt-get update && apt-get install --yes --no-install-recommends \\
  adduser \\
  build-essential \\
  automake \\
  pandoc \\
  ${PYTHON}-all \\
  git \\
  ghc \\
  ghc-ghci \\
  cabal-install \\
  libghc-cabal-dev \\
  libghc-case-insensitive-dev \\
  libghc-curl-dev \\
  libghc-json-dev \\
  libghc-snap-server-dev \\
  libghc-network-dev \\
  libghc-parallel-dev \\
  libghc-utf8-string-dev \\
  libghc-deepseq-dev \\
  libghc-hslogger-dev \\
  libghc-cryptonite-dev \\
  libghc-text-dev \\
  libghc-hinotify-dev \\
  libghc-base64-bytestring-dev \\
  libghc-zlib-dev \\
  ${LIBGHC_REGEX} \\
  libghc-attoparsec-dev \\
  libghc-vector-dev \\
  libghc-lifted-base-dev \\
  libghc-lens-dev \\
  libghc-psqueue-dev \\
  libghc-test-framework-quickcheck2-dev \\
  libghc-test-framework-hunit-dev \\
  libghc-temporary-dev \\
  libghc-old-time-dev \\
  black \\
  pylint \\
  python3-bitarray \\
  python3-mock \\
  python3-openssl \\
  python3-paramiko \\
  python3-pycurl \\
  python3-pyinotify \\
  python3-pyparsing \\
  python3-pytest \\
  python3-simplejson \\
  python3-sphinx \\
  python3-yaml \\
  python3-pip \\
  graphviz \\
  openssh-client \\
  procps \\
  qemu-utils \\
  shelltestrunner \\
  socat \\
  iproute2 ${EXTRA:-} && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -r build && useradd -r -g build build
EODF
