<p align="center">
  <img src="https://raw.githubusercontent.com/supranim/limiter/main/.github/supranim-limiter.png" height="65px" alt="Supranim Rate Limiter"><br>
  A simple to use rate limiting library for web apps.<br>
  Provides an easy way to limit any action during a specific period of time.
</p>

## Key features
- **Simple to use**: Easy to integrate into your existing codebase.

```nim
import pkg/limiter

# Create a new rate limiter with a limit of 5 requests per minute
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
```

### ❤ Contributions & Support
- 🐛 Found a bug? [Create a new Issue](https://github.com/supranim/limiter/issues)
- 👋 Wanna help? [Fork it!](https://github.com/supranim/limiter/fork)
- 😎 [Get €20 in cloud credits from Hetzner](https://hetzner.cloud/?ref=Hm0mYGM9NxZ4)
- 🥰 [Donate via PayPal address](https://www.paypal.com/donate/?hosted_button_id=RJK3ZTDWPL55C)

### 🎩 License
MIT license. [Made by Humans from OpenPeeps](https://github.com/openpeeps).<br>
Copyright &copy; 2025 OpenPeeps & Contributors &mdash; All rights reserved.
