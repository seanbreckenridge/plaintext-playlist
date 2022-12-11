#!/bin/zsh
# https://github.com/seanbreckenridge/plaintext-playlist.git
# --msg-level=file=error removes the 'reading from stdin...' info message
alias mpv-from-stdin='mpv --playlist=- --no-audio-display --msg-level=file=error'
alias mpv-shuffle='mpv-from-stdin --shuffle'
# change directory to music/playlist directories
alias cm='cd "${PLAINTEXT_PLAYLIST_MUSIC_DIR:-${XDG_MUSIC_DIR:-"${HOME}/Music"}}"'
alias cdpl='cd "${PLAINTEXT_PLAYLIST_PLAYLISTS}"'
# shorthands
alias play='plainplay'
alias pplay='plainplay play'
alias splay='plainplay shuffle'
alias splayall='fd . "$PLAINTEXT_PLAYLIST_PLAYLISTS" -X plainplay shuffleall'
# list/play all music that matches 'rg' pattern
playrg_f() {
	cm
	# https://github.com/seanbreckenridge/core/blob/main/shellscripts/unique
	fd . "$(plainplay playlistdir)" --type file -X cat | unique | rg -i "$*"
}
# play all paths that match whatever I pass as positional arguments
playrg-_f() {
	cm
	playrg_f "$*" | mpv-from-stdin
}
# use aliases so that the 'cd' actually changes directory in the shell
alias playrg='cm; playrg_f'
alias 'playrg-=cm; playrg-_f'
# fzf to play music
alias playfzf='cm; rg --color never --with-filename --no-heading "" "${PLAINTEXT_PLAYLIST_PLAYLISTS}/"*.txt | sed -e "s|^${PLAINTEXT_PLAYLIST_PLAYLISTS}/||" | fzf'
alias 'playfzf-=playfzf | cut -d":" -f2- | mpv-from-stdin'
