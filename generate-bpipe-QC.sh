#!/bin/bash
file=$1
tmpdir=$(mktemp -d)

REGISTRATIONOUTLINE="${QUARANTINE_PATH}/resources/mni_icbm152_nlin_sym_09c_minc2/mni_icbm152_t1_tal_nlin_sym_09c_outline.mnc"

create_verify_image $tmpdir/$(basename $file .mnc)_t.rgb \
-width 1920 -autocols 6 -autocol_planes t \
-row $file color:gray \
volume_overlay:$(dirname $file)/$(basename $file .mnc).beastmask.mnc volume_overlay:${REGISTRATIONOUTLINE}:1:blue

create_verify_image $tmpdir/$(basename $file .mnc)_s.rgb \
-width 1920 -autocols 6 -autocol_planes s \
-row $file color:gray \
volume_overlay:$(dirname $file)/$(basename $file .mnc).beastmask.mnc volume_overlay:${REGISTRATIONOUTLINE}:1:blue

create_verify_image $tmpdir/$(basename $file .mnc)_c.rgb \
-width 1920 -autocols 6 -autocol_planes c \
-row $file color:gray \
volume_overlay:$(dirname $file)/$(basename $file .mnc).beastmask.mnc volume_overlay:${REGISTRATIONOUTLINE}:1:blue

convert -append $tmpdir/*.rgb $2

rm -r $tmpdir
