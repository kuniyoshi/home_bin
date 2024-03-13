#!/bin/bash
project="$1"
shift
title="$*"
log_file=~/logs/pomodoro.log
notification_interval_seconds=20
lock_file=/tmp/pomodoro.is_notifying
interval_lock_file=/tmp/pomodoro.is_in_interval

pomodoro_seconds=$((25 * 60))
pomodoro_interval_seconds=$((5 * 60))
started_at=$(date +%FT%T)

echo -e "$started_at\t$project\t$title" >>"$log_file"

#osascript -e 'tell application "Twitter"' -e '  set miniaturized of window 1 to true' -e 'end tell'

sleep "$pomodoro_seconds"

started_at=$(date +%s)
touch "$lock_file"

while [ -e "$lock_file" ]
do
    elapsed=$(($(date +%s) - started_at))

    terminal-notifier -title "START INTERVAL" \
        -message "$title - $project, elapsed: $elapsed" \
        -execute "rm $lock_file"

    play_utc_voice.sh

    sleep "$notification_interval_seconds"
done

#osascript -e 'tell application "slack"' -e '  set miniaturized of window 1 to false' -e 'end tell'

sleep "$pomodoro_interval_seconds"

started_at=$(date +%s)
touch "$interval_lock_file"

while [ -e "$interval_lock_file" ]
do
    elapsed=$(($(date +%s) - started_at))

    terminal-notifier -title "DONE POMODORO" \
        -message "$title - $project, elapsed: $elapsed" \
        -execute "rm $interval_lock_file"

    play_utc_voice.sh

    sleep "$notification_interval_seconds"
done
