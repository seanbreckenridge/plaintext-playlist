# plaintext-playlist

#### Rationale

I wanted a minimal, scriptable-friendly playlist for my local music, without having to rely on a third party playlist manager/GUI interface.

*This stores playlists as text files, one per playlist, where each line is the (relative) path to a song in the playlist.*

This includes a `fzf` backed interactive interface, which lets you create/edit playlists by fuzzy matching against playlist names/songs. However, you're not required to use it, you can edit the playlist by running commands like:


`cd $HOME/Music && find Daft\ Punk/2013\ -\ Random\ Access\ Memories -name "*.mp3" | sort -n >> ~/.config/plaintext_playlist/electronic.txt`

... to append the filenames of all (or some, by `grep`ing against the output/doing whatever you want to edit the playlist.txt file) of the songs in some folder to a playlist without ever running `plainplay`.

If you later want to remove songs, you could either edit the file manually and remove the corresponding lines, or use `sed` to match against the Artist/Album name to delete those lines.

Playlists are played through `mpv`, by using the `--playlist` flag, reading from `STDIN`, which could also be done without `plainplay`:


`cd $HOME/Music && mpv --playlist=- < "$HOME/.config/plaintext_playlist/electronic.txt"`

`plainplay` gives you an interactive interface to do what the commands above do, and additionally:

* the `check` command, to make sure none of your playlists are broken; all your filepaths still exist
* the `resolve` command, which tries to fix the broken paths by using the [distance between](https://github.com/life4/textdistance) the text

### Configuration/Installation

External dependencies: `mpv`, `fzf`, `python3`, (`pip3 install --user -U textdistance`). If you don't use commands that require some dependency (e.g. you never call `resolve`), the corresponding dependency isn't required. Dependencies are checked at runtime (in `bash`).

Stores configuration (playlists) at `PLAINTEXT_PLAYLIST_CONF` (defaults to `~/.config/plaintext_playlist`). If the environment variable is set, overrides the location.

Must set `PLAINTEXT_PLAYLIST_MUSIC_DIR` as an environment variable, which defines your 'root' music directory.

### Specification

To clarify, the filenames in each playlist file should have no leading `/`. As an example, if `PLAINTEXT_PLAYLIST_MUSIC_DIR="${HOME}/Music"` and you wanted to add a song at `"${HOME}/Music/ArtistName/AlbumName/Disc2/song.flac"` to the playlist, the corresponding line would be:

```
ArtistName/AlbumName/Disc2/song.flac
```

... which is then combined to `"${HOME}/Music/ArtistName/AlbumName/Disc2/song.flac"`

If you don't specify exactly that format, you can run the `check`/`resolve` commands, which will attempt to remove absolute paths/match the closest path and prompt you to update the playlist file.

