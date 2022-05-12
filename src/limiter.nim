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
export times

type

    CallbackLimiter = proc(timeToWait: int64) {.closure.}

    Limit = ref object
        key: string
            ## The rate limit signature key.
        hits: int
            ## Counting the number of attempts
        maxAttempts: int
            ## The maximum number of attempts allowed within the given number of minutes.
        timeToWait: DateTime
            ## The number of minutes until the rate limit is reset.
        callback: CallbackLimiter

    Limiter = object
        limits: TableRef[string, Limit]

var RateLimiter* = Limiter(limits: newTable[string, Limit]())

proc hit*[L: Limiter](limiter: var L, key: string) =
    ## Increment the counter for a given key for a given decay time.
    inc limiter.limits[key].hits

proc reset*[L: Limiter](limiter: var L, key: string) =
    ## Reset the counter for given key
    limiter.limits.del(key)

proc attempt*[L: Limiter](limiter: var L, key: string, maxAttempts: int, callback: CallbackLimiter, timeToWait: TimeInterval = 1.minutes) =
    ## Attempts to execute a callback if it's not limited.
    if limiter.limits.hasKey(key):
        limiter.hit(key)
        if limiter.limits[key].hits >= limiter.limits[key].maxAttempts:
            let remaining = limiter.limits[key].timeToWait - now()
            if remaining >= initDuration(minutes = 0):
                callback(remaining.inSeconds)
            else:
                limiter.reset key
    else:
        limiter.limits[key] = Limit(key: key, maxAttempts: maxAttempts, timeToWait: now() + timeToWait, callback: callback)
        limiter.hit(key)

proc availableIn*[L: Limiter](limiter: var L, key: string): TimeInterval =
    ## Get the number of seconds until the "key" is accessible again.
    result = limiter[key].timeToWait

proc tooManyAttempts*[L: Limiter](limiter: var L, key: string, maxAttempts: int) =
    ## Determine if the given key has been "accessed" too many times.
    runnableExamples:
        if RateLimiter.tooManyAttempts(user.id, perMinute = 5):
            let remaning = RateLimiter.availableIn(user.id)
            return fmt"You may try again in {remaning} seconds."
