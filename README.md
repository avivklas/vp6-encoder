Real FLV Encoder
================

A dockerized tool that uses MEncoder to encode FLV video files with VFW that are natively decoded on every platform without additional codecs. 

For example, Real FLV encoded video files can be played with JavaFX MediaPlayer on any platform.

A lot of features and encoder tuning options can be easily added to this machine, so feel free to ask for it and I'll add it, or contribute by yourself. 

Please use [Github issues](https://github.com/avivklas/real-flv-encoder/issues/new) to report any bug or missing feature.


Usage:
------
```bash
docker run -v my_video_files_dir:/videos avivklas/real-flv-encoder \
         -i /videos/input.mp4 \
         -o /videos/output.flv
```

or just run the following to see full usage instructions:
```bash
docker run avivklas/real-flv-encoder
```