Library of bpipe functions for processing minc files
====================================================

Designed to run with

```
> bpipe run -d output minc-library.bpipe input/*.mnc
```

By default only runs denoise and n4correct, to add other steps to the pipeline edit the ``preprocess`` segment
