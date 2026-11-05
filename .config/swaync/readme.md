
- man 5 swaync - to see config options and defaults
- https://docs.gtk.org/gtk4/css-properties.html#images - gtk 4 css props
- `pkill swaync; GTK_DEBUG=interactive swaync` - launch swaync with gtk
  debugger, press the element picker button, open the notifications and click
  element you are interested in
- `find ~/.config/swaync -type f -name "*.css" | entr -p -s "swaync-client -rs; say hi; swaync-client -t"`
- styles reference file: `/etc/xdg/swaync/style.css`

swaync-client -C # close all notifications
swaync-client -rs # reload css
swaync-client -R # reload config file


```bash
# [body] markup:
# https://specifications.freedesktop.org/notification-spec/latest/ar01s04.html
# -u critical
# -t 5000

notify-send "Test noicon notification" "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ut mauris quis ante bibendum ..."

```

below is the previously used way to get a sound when a notification is received

"scripts": {
        "play-notification-sound": {
            "exec": "bash ~/.config/scripts/notify.sh",
            "app-name": "(?i)^(?!task$)(?!wallvas$)(?!satty$)(?!discord$).*$"
        }
