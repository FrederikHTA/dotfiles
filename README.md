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

The bar uses a Kanagawa wave-inspired palette and transparent, floating panels
inspired by [wthrajat's dotfiles](https://github.com/wthrajat/dotfiles-mac).

- Left: FlashSpace workspaces (highlighted active workspace) and the focused app.
- Right: Spotify song/artist while playing, weather in Celsius, volume, battery
  percentage, and date/time. Click the date to open Calendar.
- Rectangle leaves 20 points between windows and around the visible bar pills;
  the outer pills align with the 20-point window margins.
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

### Rectangle gaps

Rectangle's 20-point gap applies to screen edges and between snapped windows.
The visible 24-point pills are centered in the 40-point bar, so their bottom is
32 points from the top of the screen. Reserve those 32 points separately; the
window gap then leaves another 20 points below the pills. With the menu bar
hidden, external displays need a 32-point top reservation. This MacBook already
reserves 32 points for its notch, so it needs no additional reservation:

```sh
defaults write com.knollsoft.Rectangle gapSize -float 20
defaults write com.knollsoft.Rectangle applyGapsToMaximize -int 1
defaults write com.knollsoft.Rectangle skipGapTopEdge -bool false
defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 32
defaults write com.knollsoft.Rectangle screenEdgeGapTopNotch -int 0
defaults write com.knollsoft.Rectangle screenEdgeGapLeft -int 0
defaults write com.knollsoft.Rectangle screenEdgeGapRight -int 0
defaults write com.knollsoft.Rectangle screenEdgeGapBottom -int 0
```

The notch-specific value replaces the regular top reservation on notched
displays. These are logical points, not physical Retina pixels. If the bar
changes, use `max(0, visible pill bottom - macOS reserved top inset)` for each
display type; the inset is `NSScreen.frame.maxY - NSScreen.visibleFrame.maxY`.

Quit and reopen Rectangle, then re-snap existing windows. These gaps apply to
Rectangle layouts, not manual dragging or native macOS fullscreen.

### Permissions and Spotify

Grant FlashSpace and Rectangle their requested Accessibility permissions.
Allow SketchyBar to control Spotify when macOS asks; the widget only reads the
playing track and does not change playback. It hides when paused, stopped, or
closed. Spotify notifications update it on track changes, with a 10-second
fallback refresh. It uses the desktop app, not Spotify's web player.

### Weather

Weather uses [wttr.in](https://wttr.in/) without an API key and refreshes every
30 minutes and on wake. It is set to Aarhus, Denmark; requests disclose your IP
address to the service. To choose another city, edit the URL in
`macos/sketchybar/plugins/weather.sh` (encode spaces as `%20`), then reload the
bar. If the service is unavailable, the pill shows `Weather --°C`.

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
bash macos/sketchybar/tests/layout.sh
bash macos/sketchybar/tests/widgets.sh
```

The installer checks simulate macOS, Linux, and Windows platform names. Native
Windows symlink privileges and macOS GUI permissions still need checking on the
corresponding machine.
