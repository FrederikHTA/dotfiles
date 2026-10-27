# Dotfiles

Editor configuration and personal agent skills, plus a macOS-only SketchyBar setup.

## Link the configuration

From this checkout:

```sh
bash ./symlinks.sh
```

The script works from any checkout location. It selects the Zed config path for
the host OS and links Neovim, IdeaVim, and the existing agent skills. Existing
configs and conflicting symlinks are preserved as `.backup`, `.backup.1`, etc.;
rerunning it leaves correct links alone.

**Only macOS (`Darwin`) links `macos/sketchybar/` to `~/.config/sketchybar`.**
Linux and Windows do not install, link, or configure any macOS desktop apps.
The installer only creates links; it does not install software, start services,
or change application preferences. Windows requires a Bash environment and
permission to create symlinks.

## macOS: SketchyBar + FlashSpace

The bar uses [FelixKratz's palette](https://github.com/FelixKratz/dotfiles/blob/master/.config/sketchybar/colors.lua)
and rounded panels, without his other dotfiles or Lua setup.

- Left: FlashSpace workspaces (off-white active, grey inactive) and the focused app.
- Right: Spotify song/artist while playing, volume, battery percentage, date/time.
- A 40px bar stays above normal windows; Rectangle reserves the matching gap.
- Workspace/window shortcuts remain owned by FlashSpace and Rectangle. No new
  global keybindings or mouse controls are installed.

### Prerequisites

Install SketchyBar, FlashSpace, Rectangle, and Hack Nerd Font on the Mac. Spotify
is optional. For example, using Homebrew:

```sh
brew tap FelixKratz/formulae
brew install sketchybar
brew install --cask flashspace rectangle font-hack-nerd-font
# Optional:
brew install --cask spotify
```

Then run `bash ./symlinks.sh`. Start the bar with `brew services start sketchybar`,
or use `sketchybar --reload` if it is already running.

### FlashSpace hooks

Enable **Integrations** in FlashSpace and set these commands:

**Run script on workspace change:**

```sh
sketchybar --trigger flashspace_workspace_change WORKSPACE="$WORKSPACE" DISPLAY="$DISPLAY"
```

**Run script on profile change:**

```sh
sketchybar --reload
```

Set up workspace names, apps, displays, and keyboard shortcuts in FlashSpace.
Profiles are intentionally not copied into this repo: display assignments and
app choices are machine-specific. The bar reads the active profile at startup
and reloads when the profile changes.

### Rectangle gap

Reserve the bar's height when snapping or maximizing windows:

```sh
defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 40
```

Quit and reopen Rectangle, then re-snap existing windows. Keep this value equal
to `height` in `macos/sketchybar/sketchybarrc` if changing the bar height. This
does not constrain manual window dragging or native macOS fullscreen; use
Rectangle **Maximize** to fill the screen below the bar.

### Permissions and Spotify

Grant FlashSpace and Rectangle their requested Accessibility permissions.
Allow SketchyBar to control Spotify when macOS asks; the widget only reads the
playing track and does not change playback. It hides when paused, stopped, or
closed. Spotify notifications update it on track changes, with a 10-second
fallback refresh. It uses the desktop app, not Spotify's web player.

### Editing

`~/.config/sketchybar` is a symlink into this repo. Edit the tracked files, then:

```sh
sketchybar --reload
```

Colours live in `macos/sketchybar/colors.sh`; the layout is in `sketchybarrc`, and
widget scripts are in `plugins/`. Never commit local backup directories,
application preferences, or permission databases.

## Checks

These tests use temporary homes and mocked app commands; they do not alter your
real configuration, window layout, audio, or Spotify playback.

```sh
bash tests/symlinks.sh
bash macos/sketchybar/tests/flashspace.sh
bash macos/sketchybar/tests/widgets.sh
```

The installer checks simulate macOS, Linux, and Windows platform names. Native
Windows symlink privileges and macOS GUI permissions still need checking on the
corresponding machine.
