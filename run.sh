#!/bin/sh

show_help() {
cat << EOF
Usage: [-h] [-i INPUT] [-o OUTFILE] [-q QUALITY] [-b BITRATE TYPE]...
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

OPTIND=1

while getopts hvi:o:q:b: opt; do
    case $opt in
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

echo $conf_filename

VP6_CONF_FILE=$CONF_DIR/$conf_filename

echo $VP6_CONF_FILE

wine $MENCODER_PATH $input_file \
  -ovc vfw \
  -xvfwopts codec=$CODECS_DIR/vp6vfw.dll:compdata=$VP6_CONF_FILE \
  -oac mp3lame \
  -lameopts cbr:br=64 \
  -af lavcresample=22050 \
  -of lavf \
  -vf flip \
  -o $output_file
