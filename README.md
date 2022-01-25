# i3-rename-workspaces
Allows you to rename i3 work spaces in i3-wm and still keep the mod+[1-9]
keybindings.
Additionally, the script for renaming the work-space makes suggestions
on what the title can be, based on the currently focused window.

## Motivation
Usually, when you rename a work-space, then the normal key-binding
`bindsym $mod+1 workspace 1` won't work anymore, because the command expects
the work-space name as an argument, and not the work-space number. This
complicates things immensely if you want renamable work-spaces, and still want
to keep the mod-plus-number key-bindings (`mod+0`, `mod+1`, ..., `mod+9`).

## Setup
Add the following to your i3 config:
```
# create the temporary directory in which the workspace names will be cached
exec_always --no-startup-id "mkdir -p /tmp/i3"

# bind the script to a key.
bindsym $mod+o exec --no-startup-id /path/to/script/i3_dmenu_suggest_ws_names.rb

bindsym $mod+1 exec /path/to/script/i3_goto_workspace.sh 1
bindsym $mod+2 exec /path/to/script/i3_goto_workspace.sh 2
   ...
bindsym $mod+9 exec /path/to/script/i3_goto_workspace.sh 9
```
of course without the `...` dots, and the `/path/to/script/` paths must also be
adjusted to where you installed the scripts to. This is just an example, you
can bind the goto script how you like. The only limitation in the moment, is
that the amount of workspaces is limited to 9, since the ruby script only
parses the first character in of the workspace name (feel free to correct that).

## Remarks
the Title suggestion script is taylored to my operating system, i.e. you
probably want to edit that and add rules and execptions based on what kind of
programs you use, and what you prefer the titles to contain.

## TODO
[ ] impl. an auto-clear script, which renames all work-spaces back to numbers,
    without the curly braces (before switching workspaces).

[ ] impl. an auto-name script, which renames all work-spaces based on it's best
    guess.
[ ] impl. a shortening function, which shortens long titles sensibly.
[ ] impl. an auto-shortening function, based on the total length of all titles:
	- if greater than some const. N, then shorten
	- shorten titles based on length, longer titles are more likely to be
     shortened than short titles
[ ] focus last focused window in work-space, when switching to that workspace.
    - move mouse to the side (ideally to the side of the last focused win).
      to prevent focus from being lost.
[ ] come up with some way to group windows into workspaces intelligently.
    - get rid of stale terminals
    - group by directory
[+] (assoc. w. bug 3) write init script which chicks if `workspace_names.txt`
    exists, if so uses that for assigning initial work-space names, instead
    of 1 through 9, 0.
[+] **HIGH PRIORITY** maybe this doesn't belong here, but write a script to
    jump to the next empty work-space (i.e. void of windows).

## Bugs
[x] 1. script fails to find focused window if the current workspace is empty,
    resulting in infinite loop in script?
[x] 2. sed occasionally fails to put title into `workspace_names.txt` because the
    string is not escaped.
[ ] 3. existing work-space names are not used during i3 restart, if
    `workspace_names.txt` is still present in `/tmp/i3/`.
[ ] 4. renaming work-space with `'` character doesn't work.

