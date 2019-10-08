# Architecture Overview

By default only nginx is exposed to the world and proxies every request on port 80, 443 and 8443 to the appropriate service.

```
    Client
      |
  TCP 80 / 443
      |
      |   +-------------------------------------+
      +-> | Nginx reverse proxy                 |
      |   | - TCP Port 80 / 443 / 8443          |
      |   | - redirects 80 to 443               |      +--------------------+
  TCP 443 |                                     |      | Synapse Homeserver |
     8443 | - /_matrix/* ----------------------------> | TCP Port 8008      |
      |   |                                     |      |                    |
   Server | - /_matrix/identity/                |      +--------------------+
          | - _matrix/client/r0/user_directory/ |
          +-------|-----------------------------+
                  |
                  |
                  |    +-----------------------+
                  +--> | mxisd Identity Server |
                       | TCP Port 8090         |
                       |                       |
                       +-----------------------+
```
