import std/unittest
from std/os import sleep

import limiter

test "can get key by area:user_id":
    let getUserId = RateLimiter.getId("login", "cec91ebed1de")
    check(getUserId == "login:cec91ebed1de")

test "can limit access by no. of attempts":
    var
        status: int
        attempts = 0
    let getUserId = RateLimiter.getId("login", "cec91ebed1de")
    while true:
        if attempts == 10: break
        RateLimiter.attempt(getUserId, maxAttempts = 5) do(timeToWait: Duration):
            status = 429
        inc attempts
        sleep(100)

    check(RateLimiter.getHits(getUserId) == 10)
    let remaining = RateLimiter.availableIn(getUserId)
    check(remaining < initDuration(minutes = 1))
