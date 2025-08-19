#!/bin/bash

rm -f t/otpauth.t
export LC_ALL="en_US.UTF-8"

if [[ -f Build.PL ]]; then
    perl Build.PL
    perl ./Build
    perl ./Build test
    # Make sure this goes in vendor
    perl ./Build install --installdirs vendor
elif [[ -f Makefile.PL ]]; then
    # Make sure this goes in vendor
    perl Makefile.PL INSTALLDIRS=vendor NO_PACKLIST=1 NO_PERLLOCAL=1
    make
    if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
         make test -j"${CPU_COUNT}"
    fi
    make install
else
    echo 'Unable to find Build.PL or Makefile.PL. You need to modify build.sh.'
    exit 1
fi
