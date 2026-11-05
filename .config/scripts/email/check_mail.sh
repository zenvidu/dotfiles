#!/usr/bin/env bash

BASE="$HOME/.config/scripts/email"
STATE="$BASE/gmail_state"

ACCOUNTS="$BASE/gmail_accounts"
#add your email accounts to a file(gmail_accounts) in the same directory as this script
#LABEL:EMAIL:APP_PASSWORD
#Ex:-
# mymain:helloworld@gmail.com:1111 aaaa 2222 bbbb

ICON_NEW=""
ICON_EMPTY=""

TOTAL_UNREAD=0
NEW_ACCOUNTS=""
TOOLTIP_TEXT=""

# Ensure state directory and file exist
mkdir -p "$BASE"
[ -f "$STATE" ] || touch "$STATE"
[ -f "$ACCOUNTS" ] || { echo '{"text": "Error", "tooltip": "Accounts file missing"}'; exit 1; }

while IFS=: read -r LABEL USER PASS; do
    [ -z "$LABEL" ] && continue

    COUNT=$(curl -su "$USER:$PASS" --silent "https://mail.google.com/mail/feed/atom" | grep -oPm1 '(?<=<fullcount>)[0-9]+')

    [ -z "$COUNT" ] && COUNT=0
    TOTAL_UNREAD=$((TOTAL_UNREAD + COUNT))

    TOOLTIP_TEXT="$TOOLTIP_TEXT$LABEL: $COUNT\n"

    PREV=$(grep "^$USER " "$STATE" | awk '{print $2}')
    PREV=${PREV:-0}

    if [ "$COUNT" -gt "$PREV" ]; then
        DIFF=$((COUNT - PREV))
        NEW_ACCOUNTS="$NEW_ACCOUNTS\n$LABEL ($DIFF new)"
    fi

    grep -v "^$USER " "$STATE" > "$STATE.tmp"
    echo "$USER $COUNT" >> "$STATE.tmp"
    mv "$STATE.tmp" "$STATE"

done < "$ACCOUNTS"

if [ -n "$NEW_ACCOUNTS" ]; then
    notify-send -a "mail" -u normal -r 9996 "New Mail" "$(printf "$NEW_ACCOUNTS")"
fi

if [ "$TOTAL_UNREAD" -gt 0 ]; then
    #TEXT="$ICON_NEW $TOTAL_UNREAD"
    TEXT="$ICON_NEW"
    CLASS="new-mail"
else
    TEXT="$ICON_EMPTY"
    CLASS="no-mail"
fi

printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$TEXT" "${TOOLTIP_TEXT%\\n}" "$CLASS"
