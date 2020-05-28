# plaintext-playlist

Status: The `resolve` command is not done yet, everything else is functional.

```
Usage: plaintext [-h] [-] [COMMAND [ARGS]]

  Interactive terminal playlist manager, storing contents in readable text files
  run without a COMMAND to drop into interactive mode

  add and remove defaults to presenting you an
  fzf interface to add/remove items.

  A hyphen (-) can be passed with add
  to instead recieve filenames from stdin
  expects filenames to be in the correct format
  (cd to your Music dir and use find for good results)

  e.g.: find somedirectory -name "*.flac" | plainplay - add rock

  <playlist> specifies either the
  name (without the location/.txt extension)
  or the location of one of the playlists

add <playlist>                | Adds one or more songs to a playlist
remove <playlist>             | Removes one of more songs from a playlist
play <playlist>               | Play songs from a playlist
shuffle <playlist>            | Shuffle songs from a playlist
list <playlist>               | List songs in a playlist
playlist-create <playlist>    | Creates a new playlist - a playlist file
playlist-remove <playlist>    | Removes an existing playlist - deletes a playlist file
playlist-list                 | List the full paths of each of your playlist files
playlistdir                   | Print the location of the playlist directory
check                         | Makes sure that all songs in all your playlists exist
resolve                       | Attempts to fix broken paths in playlists
```

## Rationale

I wanted a minimal, scriptable-friendly playlist for my local music, without having to rely on a third party playlist manager/GUI interface.

_This stores playlists as text files, one per playlist, where each line is the (relative) path to a song in the playlist._

This includes a `fzf` backed interactive mode, which lets you create/edit playlists by fuzzy matching against playlist names/songs. However, you're not required to use it, you can edit the playlist by running commands like:

`cd $HOME/Music && find Daft\ Punk/2013\ -\ Random\ Access\ Memories -name "*.mp3" | sort -n >> ~/.local/share/plaintext_playlist/electronic.txt`

... to append the filenames of all (or some, by `grep`ing against the output/doing whatever you want to edit the playlist.txt file) of the songs in some folder to a playlist without ever running `plainplay`.

If you later want to remove songs, you could either edit the file manually and remove the corresponding lines, or use `sed` to match against the Artist/Album name to delete those lines.

Playlists are played through `mpv`, by using the `--playlist` flag, reading from `STDIN`, which could also be done without `plainplay`:

`cd $HOME/Music && mpv --playlist=- < "$HOME/.local/share/plaintext_playlist/electronic.txt"`

`plainplay` gives you an interactive mode to do what the commands above do, and additionally:

- the `check` command, to make sure none of your playlists are broken; all your filepaths still exist
- the `resolve` command, which tries to fix the broken paths by using the [distance between](https://github.com/life4/textdistance) the text

### Configuration/Installation

External dependencies: `mpv`, `fzf`, `python3`, (`pip3 install --user -U textdistance`). If you don't use commands that require some dependency (e.g. you never call `resolve`), the corresponding dependency isn't required. Dependencies are checked at runtime (in `bash`).

Stores configuration (playlists) at `PLAINTEXT_PLAYLIST_PLAYLISTS` (defaults to `~/.local/share/plaintext_playlist`). If the environment variable is set, overrides the location.

Must set `PLAINTEXT_PLAYLIST_MUSIC_DIR` as an environment variable, which defines your 'root' music directory. If you don't have one place you keep all your music, you can set your `$HOME` directory, or `/`, which would cause the playlist files to use absolute paths instead.

To install, download `plainplay` and put it on your `$PATH` somewhere, e.g.:

`curl -s https://raw.githubusercontent.com/seanbreckenridge/plaintext-playlist/master/plainplay > ~/.local/bin/plainplay`

### Specification

To clarify, the filenames in each playlist file should have no leading `/`. As an example, if `PLAINTEXT_PLAYLIST_MUSIC_DIR="${HOME}/Music"` and you wanted to add a song at `"${HOME}/Music/ArtistName/AlbumName/Disc2/song.flac"` to the playlist, the corresponding line would be:

```
ArtistName/AlbumName/Disc2/song.flac
```

... which is then combined to `"${HOME}/Music/ArtistName/AlbumName/Disc2/song.flac"`

If you don't specify exactly that format, you can run the `check`/`resolve` commands, which will attempt to remove absolute paths/match the closest path and prompt you to update the playlist file.
