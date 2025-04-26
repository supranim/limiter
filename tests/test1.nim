import std/[unittest, os, times]
import ../src/limiter

test "hit rate limiter":
  var rateLimiter = Limiter(
    maximumHits: 5'u,
    timeLimit: initDuration(seconds = 1),
    timeToWait: initDuration(seconds = 2)
  )
  # Simulate hits
  for i in 0 ..< 5:
    if i < 5:
      assert rateLimiter.hit("127.0.0.1")
    else:
      assert not rateLimiter.hit("127.0.0.1")
  sleep(3000)
  assert rateLimiter.hit("127.0.0.1")