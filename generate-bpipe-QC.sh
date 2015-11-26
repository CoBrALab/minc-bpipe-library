#!/bin/bash
file=$1
tmpdir=$(mktemp -d)

create_verify_image $tmpdir/$(basename $file .mnc)_t.rgb \
-width 1920 -autocols 6 -autocol_planes t \
-row $file color:gray \
volume_overlay:$(basename $file .mnc).beastmask.mnc

create_verify_image $tmpdir/$(basename $file .mnc)_s.rgb \
-width 1920 -autocols 6 -autocol_planes s \
-row $file color:gray \
volume_overlay:$(basename $file .mnc).beastmask.mnc

create_verify_image $tmpdir/$(basename $file .mnc)_c.rgb \
-width 1920 -autocols 6 -autocol_planes c \
-row $file color:gray \
volume_overlay:$(basename $file .mnc).beastmask.mnc

convert -append $tmpdir/*.rgb $2

rm -r $tmpdir
