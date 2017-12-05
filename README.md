VP6 Encoder
================

A dockerized tool that uses MEncoder to encode FLV video files with VFW that are natively decoded on every platform without additional codecs. 

For example, Real FLV encoded video files can be played with JavaFX MediaPlayer on any platform.

A lot of features and encoder tuning options can be easily added to this machine, so feel free to ask for it and I'll add it, or contribute by yourself. 

Please use [Github issues](https://github.com/avivklas/real-flv-encoder/issues/new) to report any bug or missing feature.


Usage:
------
```bash
docker run -v my_video_files_dir:/videos avivklas/vp6-encoder \
         -i /videos/input.mp4 \
         -o /videos/output.flv
```

or just run the following to see full usage instructions:
```bash
docker run avivklas/vp6-encoder

Usage: [-h] [-i INPUT] [-o OUTFILE] [-q QUALITY] [-b BITRATE TYPE] [-s SCALE VALUE] [-c CROP VALUE]...
Encodes almost any video file with vfw to flv

    -h              display this help and exit
    -i INPUT        the file to be converted
    -o OUTFILE      the encoded result file path
    -q QUALITY      the desired output quality (default=3):
                        1 - lowest (500kbps)
                        2 - low (800kbps)
                        3 - medium (1000kbps)
                        4 - high (1200kbps)
                        5 - highest (1500kbps)
    -b BITRATE TYPE the bitrate type to be used (cbr or vbr) (default=vbr).
    -s SCALE VALUE  scale value in the form of w:h
    -c CROP VALUE   crop value in the form of w:h
    -e EXPAND VALUE expand value in the form of w:h:x:y:o:a:r
                    (read more on http://www.mplayerhq.hu/DOCS/man/en/mplayer.1.html#VIDEO FILTERS)
    -v              verbose mode. Can be used multiple times for increased
                    verbosity.

```
