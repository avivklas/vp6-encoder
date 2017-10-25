#!/usr/bin/env bash

set -e
set -u

show_help() {
cat << EOF
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
    -f FPS VALUE    specify an fps. otherwise the input file's fps will be used
    -n              no audio
    -v              verbose mode. Can be used multiple times for increased
                    verbosity.
EOF
}

MENCODER_PATH=/var/opt/MPlayer/mencoder
CODECS_DIR=/usr/lib/codecs
CONF_DIR=/usr/lib/vp6conf

output_file=""
input_file=""
quality=3
bitrate_method="vbr"
verbose=0
scale_value=""
crop_value=""
expand_value=""
fps=""
nosound=false
noskip=false

while getopts hvni:o:q:b:s:c:e:f: opt; do
    case ${opt} in
        h)
            show_help
            exit 0
            ;;
        v)  verbose=$((verbose+1))
            ;;
        o)  output_file=$OPTARG
            ;;
        i)  input_file=$OPTARG
            ;;
        q)  quality=$OPTARG
            ;;
        b)  bitrate_method=$OPTARG
            ;;
        s)  scale_value=$OPTARG
            ;;
        c)  crop_value=$OPTARG
            ;;
        e)  expand_value=$OPTARG
            ;;
        f)  fps=$OPTARG
            ;;
        n)  nosound=true
            ;;
        k)  noskip=true
            ;;
        *)
            show_help >&2
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [ -z "$input_file" ]
then
    echo "-i must be set with the input file path\n" >&2
    show_help
    exit 1
fi

if [ -z "$output_file" ]
then
    echo "-o must be set with the desired output file path\n" >&2
    show_help
    exit 1
fi

conf_filename=""

case "$quality" in
    1 )
        conf_filename="500kbps" ;;
    2 )
        conf_filename="800kbps" ;;
    3 )
        conf_filename="1000kbps" ;;
    4 )
        conf_filename="1200kbps" ;;
    5 )
        conf_filename="1500kbps" ;;
    * )
        conf_filename="1000kbps" ;;
esac

case "$bitrate_method" in
    "cbr" )
        conf_filename="${conf_filename}_cbr.mcf" ;;
    "vbr" )
        conf_filename="${conf_filename}_vbr.mcf" ;;
    * )
        conf_filename="${conf_filename}_vbr.mcf" ;;
esac

VP6_CONF_FILE=${CONF_DIR}/${conf_filename}

cmd="$MENCODER_PATH $input_file
  -ovc vfw
  -xvfwopts codec=$CODECS_DIR/vp6vfw.dll:compdata=$VP6_CONF_FILE
  -forceidx
  -o $output_file"

if [ ${nosound} == true ] ; then
    cmd="$cmd -nosound"
else
    cmd="$cmd -oac copy"
fi

if [ ! -z "$fps" ]; then
    cmd="$cmd -fps $fps"
fi

if [ ${noskip} == true ]; then
    cmd="$cmd -noskip -mc 0"
fi

vf="-vf harddup"

if [ ! -z "$crop_value" ]
then
    vf="$vf,crop=$crop_value"
fi

if [ ! -z "$scale_value" ]
then
    vf="$vf,scale=$scale_value"
fi

if [ ! -z "$expand_value" ]
then
    vf="$vf,expand=$expand_value"
fi

cmd="$cmd $vf"

echo $cmd

wine ${cmd}
