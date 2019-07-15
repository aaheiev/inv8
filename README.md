# Jets Project

This README would normally document whatever steps are necessary to get the application up and running.

Things you might want to cover:

* Dependencies
* Configuration
* Database setup
* How to run the test suite
* Deployment instructions

## Deployment

### Dev (remote)

```bash
JETS_ENV=development JETS_ENV_REMOTE=1 jets deploy
```

```bash
JETS_ENV=stage JETS_ENV_REMOTE=1 jets server
JETS_ENV=stage jets dynamodb:migrate dynamodb/migrate/20190207220149-create_projects_migration.rb
JETS_ENV=production jets dynamodb:migrate dynamodb/migrate/20190207220149-create_projects_migration.rb
JETS_ENV=stage JETS_ENV_REMOTE=1 jets deploy
```