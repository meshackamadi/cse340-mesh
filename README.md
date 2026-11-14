# cse340-mesh
This Repo will house my learnings for Web Backend Development.

## Database configuration

Set either `DB_URL` or `DATABASE_URL` to the PostgreSQL connection string before
starting the server. Render PostgreSQL services usually provide `DATABASE_URL`;
copy that value into the web service's environment variables.

SSL is enabled by default for hosted PostgreSQL databases. Set `DB_SSL=false`
only when connecting to a local PostgreSQL server that does not support SSL.
