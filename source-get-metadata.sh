
get_meta_tracknum(){
    DBUS_OUTPUT=$( query_spotify_dbus )
    TRACK_NO=$( echo "$DBUS_OUTPUT" | grep "\"xesam:trackNumber\"" -A 1 | grep variant | \
                      cut -d " " -f 2- | rev | cut -d " " -f 1 | rev | xargs printf "%02d\n")
}

get_meta_length(){
    DBUS_OUTPUT=$( query_spotify_dbus )
    SONG_LEN=$( echo "$DBUS_OUTPUT" | grep "\"mpris:length\"" -A 1 | grep variant | \
                      cut -d " " -f 2- | rev | cut -d " " -f 1 | rev )
    # convert ms in secs
    SONG_LEN=$( echo "$SONG_LEN/1000000" | bc )
}

get_meta_name(){
    DBUS_OUTPUT=$( query_spotify_dbus )
    SONG_NAME=$( echo "$DBUS_OUTPUT" | grep "\"xesam:title\"" -A 1 | grep variant | \
                       cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)
}

get_meta_album(){
    DBUS_OUTPUT=$( query_spotify_dbus )
    ALBUM_NAME=$( echo "$DBUS_OUTPUT" | grep "\"xesam:album\"" -A 1 | grep variant | \
                        cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)
}

get_meta_artist(){
    DBUS_OUTPUT=$( query_spotify_dbus )
    ARTIST_NAME=$(echo "$DBUS_OUTPUT" | grep "\"xesam:artist\"" -A 2 | grep -v xesam | grep string | \
                         cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)
}

query_spotify_dbus(){
    SVC="spotify" # "vlc", "spotify", etc.
    dbus-send --print-reply --session \
              --dest=org.mpris.MediaPlayer2.$SVC \
              /org/mpris/MediaPlayer2 \
              org.freedesktop.DBus.Properties.Get \
              string:'org.mpris.MediaPlayer2.Player' \
              string:'Metadata'
}

get_meta_all(){
    DBUS_OUTPUT=$( query_spotify_dbus )

    TRACK_NO=$( echo "$DBUS_OUTPUT" | grep "\"xesam:trackNumber\"" -A 1 | grep variant | \
                      cut -d " " -f 2- | rev | cut -d " " -f 1 | rev | xargs printf "%02d\n")
    SONG_LEN=$( echo "$DBUS_OUTPUT" | grep "\"mpris:length\"" -A 1 | grep variant | \
                      cut -d " " -f 2- | rev | cut -d " " -f 1 | rev )
    # convert ms in secs
    SONG_LEN=$( echo "$SONG_LEN/1000000" | bc )
    SONG_NAME=$( echo "$DBUS_OUTPUT" | grep "\"xesam:title\"" -A 1 | grep variant | \
                       cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)
    ALBUM_NAME=$( echo "$DBUS_OUTPUT" | grep "\"xesam:album\"" -A 1 | grep variant | \
                        cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)
    ARTIST_NAME=$(echo "$DBUS_OUTPUT" | grep "\"xesam:artist\"" -A 2 | grep -v xesam | grep string | \
                         cut -d\" -f 2- | rev | cut -d\" -f 2- | rev)
}
