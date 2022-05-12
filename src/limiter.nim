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

    CallbackLimiter = proc(timeToWait: Duration) {.closure.}

    Limit = ref object
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

proc getId*[L: Limiter](limiter: L, area, key: string): string =
    result = area & ":" & key

proc hasKey[L: Limiter](limiter: var L, keyId: string): bool =
    ## Determine if given key has been limited
    result = limiter.limits.hasKey(keyId)

proc hit*[L: Limiter](limiter: var L, keyId: string) =
    ## Increment the counter for a given key for a given decay time.
    if limiter.hasKey(keyId):
        inc limiter.limits[keyId].hits

proc reset*[L: Limiter](limiter: var L, keyId: string) =
    ## Reset (delete) the limit for given key
    if limiter.hasKey(keyId):
        limiter.limits.del(keyId)

proc availableIn*[L: Limiter](limiter: var L, keyId: string): Duration =
    ## Get the number of seconds until the "key" is accessible again.
    if limiter.hasKey(keyId):
        result = limiter.limits[keyId].timeToWait - now()

proc attempts[L: Limiter](limiter: var L, keyId: string, maxAttempts: int,
                          callback: CallbackLimiter, timeToWait: TimeInterval = 1.minutes) =
    ## Adds a new Limiter for given key. 
    ## This includes 1 hit when initializing ``Limit`` object
    limiter.limits[keyId] = Limit(hits: 1, maxAttempts: maxAttempts,
                                    timeToWait: now() + timeToWait,
                                    callback: callback)

proc attempt*[L: Limiter](limiter: var L, key: string, maxAttempts: int,
                          callback: CallbackLimiter, timeToWait: TimeInterval = 1.minutes) =
    ## Attempts to execute a callback if it's not limited.
    runnableExamples:
        RateLimiter.attempt("send.message", user.id, maxAttempts = 5) do(timeToWait: Duration):
            echo "Too many attempts. Try again in " & $(timeToWait) & " seconds"
    if limiter.hasKey(key):
        limiter.hit key
        if limiter.limits[key].hits >= limiter.limits[key].maxAttempts:
            let remaining = limiter.availableIn key
            if remaining >= initDuration(minutes = 0):
                callback(remaining)
            else: limiter.reset key
    else: limiter.attempts(key, maxAttempts, callback, timeToWait)