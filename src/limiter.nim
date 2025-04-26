# A simple HTTP rate limiting library to limit
# any action during a specific period of time.
#
# (c) 2025 Made by Humans from OpenPeeps | MIT License
#     https://github.com/supranim
#     https://supranim.com
# 
import std/[times, strutils, tables, options]

type
  Limit* = ref object
    count: uint = 1
      ## Counting the number of hits
    lastRequest: DateTime
      ## The last time the request was made.

  LimitIdentifier* = string
    ## An alias representing the identifier of the limit.
    ## This can be an IP address, an account ID or
    ## any other unique identifier that can be used
    ## to identify the user/client.
  
  Limiter* = object
    ## The rate limiter object that contains the
    ## configuration for the rate limiting and a table
    ## of the current limits for each client.
    timeToWait*: Duration = initDuration(minutes = 5)
      ## The number of minutes until the rate limit is reset.
    timeLimit*: Duration = initDuration(minutes = 1)
      ## The time interval in which the rate limit is applied.
    maximumHits*: uint = 100'u
      ## The maximum number of attempts allowed within the given number of minutes.
    limiters: TableRef[string, Limit] = newTable[LimitIdentifier, Limit]()
      ## The table of the current limits for each client.

proc hit*(rateLimiter: var Limiter, id: string): bool =
  ## Increment the counter for a given key. Use the `id`
  ## to identify each hit. Where `id` can be IP address,
  ## an account ID or any other unique identifier that
  ## can be used to identify the user/client
  if rateLimiter.limiters.hasKey(id):
    let limit = rateLimiter.limiters[id]
    if limit.count >= rateLimiter.maximumHits:
      # alright, the user has exceeded the maximum number of hits
      # so we need to check if the time limit has passed
      let lastRequest = now() - limit.lastRequest
      if lastRequest < rateLimiter.timeLimit:
        # if last request is less than the time limit
        # than force the user to wait for a certain time
        # before allowing them to make another request
        if lastRequest < rateLimiter.timeToWait:
          return
      limit.lastRequest = now()
      limit.count = 1'u
    else:
      inc(limit.count)
      limit.lastRequest = now()
  else:
    let limit = Limit(lastRequest: now())
    rateLimiter.limiters[id] = limit
  result = true

