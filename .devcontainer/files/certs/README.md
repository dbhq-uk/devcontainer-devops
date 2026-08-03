# Extra CA certificates

Drop any additional CA certificates you need the container to trust into this
directory before building the image. Files must be **PEM-encoded** and named
`*.crt` — that is what `update-ca-certificates` picks up. A single file may
contain a whole chain (issuing CA followed by root CA).

```text
.devcontainer/files/certs/
├── README.md
└── my-internal-ca.crt      # <- your chain goes here (git-ignored)
```

The `Dockerfile` copies the whole directory into
`/usr/local/share/ca-certificates/extra/` and runs `update-ca-certificates`, so
the certificates are merged into the system bundle at
`/etc/ssl/certs/ca-certificates.crt`.

That bundle is what `REQUESTS_CA_BUNDLE`, `SSL_CERT_FILE` and
`NODE_EXTRA_CA_CERTS` all point at, which covers Python (`az`, `ansible`,
`checkov`, …), `curl`, and Node.js. Node ignores the system store by default,
which is why it needs the bundle passed explicitly.

If you add no certificates the build still succeeds — the container simply
trusts the public roots shipped in the base image.

> `*.crt` and `*.pem` are git-ignored repository-wide. Keep internal CA material
> out of version control unless you have deliberately decided it is publishable.
