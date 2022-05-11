# A simple to use HTTP rate limiting library to limit
# any action during a specific period of time.
# 
# This package is part of Supranim Hyper Framework.
# 
# Supranim is a simple MVC-style web framework for building
# fast web applications, REST API microservices and other cool things.
#
# (c) 2021 Limiter is released under MIT License
#          Made by Humans from OpenPeep
#          
#          https://github.com/supranim
#          https://supranim.com

import std/[tables, times]

type
    Limit = ref object
        key: string
            ## The rate limit signature key.
        maxAttempts: int
            ## The maximum number of attempts allowed within the given number of minutes.
        timeToWait: TimeInterval
            ## The number of minutes until the rate limit is reset.
        callback: proc() {.closure.}

    Limiter = object
        limiters: TableRef[string, Limit]

var RateLimiter* = Limiter()

proc attempt*[L: Limiter](limiter: var L, key: string, maxAttempts: int, callback: proc(), secsToWait: TimeInterval = minute(1)) =
    ## Attempts to execute a callback if it's not limited.

proc availableIn*[L: Limiter](limiter: var L, key: string): TimeInterval =
    ## Get the number of seconds until the "key" is accessible again.
    result = limiter[key].timeToWait

proc tooManyAttempts*[L: Limiter](limiter: var L, key: string, maxAttempts: int)
    ## Determine if the given key has been "accessed" too many times.
    runnableExamples:
        if RateLimiter.tooManyAttempts("message", user.id, perMinute = 5)
            let remaning = RateLimiter::availableIn("message", user.id);
            return fmt"You may try again in {remaning} seconds.";

proc hit*[L: Limiter](limiter: var L) =
    ## Increment the counter for a given key for a given decay time.
