## ARECORD stuff
# -c = channels
# -f = sample format
# -r = sampling rate
# -t = save file type
# -D = capture device (must be created beforehand in ~/.asoundrc)
# see: https://wiki.archlinux.org/index.php/PulseAudio/Examples#ALSA_monitor_source
ARECORD=$(which arecord)
ARECORD_SAVE_FMT="wav"
ARECORD_FLAGS="-c 2 -f S16_LE -r 44100 -t $ARECORD_SAVE_FMT -D pulse_monitor"

## FLAC opts
FLAC_OPTS="-f --best -s"

record(){
    if [[ "$DUMP" = "0" ]]; then
        return
    fi

    if [[ "$1" = "stop" ]]; then
        killall -9 $ARECORD 2>&1
        echo "Stopping any registration..."
        return
    fi

    echo "Starting new registration ..."
    get_meta_all

    ITEM_PATH="$CUSTOM_MUSIC/$ARTIST_NAME"
    ITEM_PATH=${ITEM_PATH// /_}     ## space -> underscore
    #ITEM_PATH=${ITEM_PATH//\'/_}    ## single quote -> underscore

    SONG_TITLE="${ARTIST_NAME}--${ALBUM_NAME}--${TRACK_NO}--${SONG_NAME}"
    SONG_TITLE=${SONG_TITLE// /_}   ## space -> underscore
    #SONG_TITLE=${SONG_TITLE//\'/_}  ## single quote -> underscore
    SONG_TITLE=${SONG_TITLE//\//_}  ## slash -> underscore
    SONG_EXT="ogg"

    FULL_ITEM_PATH="${ITEM_PATH}/${SONG_TITLE}"

    mkdir -p "$ITEM_PATH"
    record stop

    if [[ -e ${FULL_ITEM_PATH}.${SONG_EXT} ]] && \
       [[ $(stat -c%s $FULL_ITEM_PATH.$SONG_EXT) -gt 1800000 ]];
    then
        echo "File exists. Stop."
        return 1
    fi
    echo "Recording started: ${FULL_ITEM_PATH}.${SONG_EXT} ..."
    #$ARECORD -d $SONG_LEN $ARECORD_FLAGS | flac - $FLAC_OPTS -o "$FULL_ITEM_PATH" &
    ($ARECORD -d ${SONG_LEN} ${ARECORD_FLAGS} | \
    oggenc - --tracknum "${TRACK_NO}" --artist "${ARTIST_NAME}" \
             --album "${ALBUM_NAME}" --title "${SONG_NAME}" \
             -o "${FULL_ITEM_PATH}.${SONG_EXT}" && \
             vorbisgain "${FULL_ITEM_PATH}.${SONG_EXT}" && echo) &
}
