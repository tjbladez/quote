## Quotes ##

Maintain and quote your awesome quotes from movies, games and other sources from command line, plug it to any of
your apps/projects.

### Quoting ###

To get a random quote:
<code>quote</code>

To search for a specific quote check usage:
<code>quote -h</code>

### Adding quote ###

To add a quote:
<code>quote --add <argument></code>

Note: Your argument needs to be a valid JSON containing source, context, quote, theme params.

### Deleting quote(s) ###

WIP

### Configuring ###

You can see pretty colorized output if you set environment variable `QUOTE_COLORIZE` to 'true'.
You can specify your own path to quotes files via environment variable `QUOTE_SOURCE`.

## To-do ##

 * Full text searching
 * Allowing to spawn quote server
 * Move quotes from json to nosql store




