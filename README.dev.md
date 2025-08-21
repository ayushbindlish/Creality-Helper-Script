# Developer Notes

## Debug flag

Run `./helper.sh -d` or `./helper.sh --debug` to enable debug mode. This exports `DEBUG=1`, sets `PS4='+ $0:$LINENO '` and enables shell tracing with `set -x` so each sourced script prints commands with file paths. When enabled, the `run` helper also prints the function it executes and skips clearing the screen.
