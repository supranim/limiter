<p align="center">
    <img src="https://raw.githubusercontent.com/supranim/limiter/main/.github/supranim-limiter.png" height="65px" alt="Supranim Rate Limiter"><br>
    A simple to use HTTP rate limiting library. Built-in memory cache,<br>
    provides an easy way to limit any action during a specific period of time.
</p>

## ✨ Key features
- [x] Framework Agnostic
- [x] Dependency-free
- [x] Open Source | `MIT` License

## Install
```bash
nimble install limiter
```

## Examples

Using **Limiter** withing your Supranim application
```nim
import supranim, limiter

proc sendConfirmationLink*(req: Request, res: Response) =
    ## Example of a ``POST`` procedure to handle confirmation links.
    let getUserId = RateLimiter.getId("send.message", 1234)
    RateLimiter.attempt(getUserId, maxAttempts = 3) do(remaining: Duration):
        res.json("Too many attempts. Try again in " & $(remaining.inSeconds) & " seconds", Http429)
    # ...
    # handle confirmation links...
    # ...
    res.json("Confirmation link sent. Check your e-mail")
```

### ❤ Contributions
If you like this project you can contribute to Tim project by opening new issues, fixing bugs, contribute with code, ideas and you can even [donate via PayPal address](https://www.paypal.com/donate/?hosted_button_id=RJK3ZTDWPL55C) 🥰

### 👑 Discover Nim language
<strong>What's Nim?</strong> Nim is a statically typed compiled systems programming language. It combines successful concepts from mature languages like Python, Ada and Modula. [Find out more about Nim language](https://nim-lang.org/)

<strong>Why Nim?</strong> Performance, fast compilation and C-like freedom. We want to keep code clean, readable, concise, and close to our intention. Also a very good language to learn in 2022.

### 🎩 License
Limiter is an Open Source Software released under `MIT` license. [Made by Humans from OpenPeep](https://github.com/openpeep).<br>
Copyright &copy; 2022 Supranim & OpenPeep &mdash; All rights reserved.

<a href="https://hetzner.cloud/?ref=Hm0mYGM9NxZ4"><img src="https://openpeep.ro/banners/openpeep-footer.png" width="100%"></a>
