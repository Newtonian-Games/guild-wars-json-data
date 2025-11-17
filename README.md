# Guild Wars JSON Data

## All Data in `.json` Files!

Use however you like

## Creating a Postgres Database (optional)

> Follow these instructions to turn the JSON files into a normalized Postgres DB! You don't need to keep using Supabase afterwards if you don't want since it creates a regular Postgres DB you can connect to.

To run migrations for this project, use the Supabase CLI:

### Prerequisites

* supabase.com account/project setup
* Node/Npm installed (we recommend using Node Version Manager (NVM))

### 1. Login

```bash
npx supabase login
```

### 2. Link to your project

> Find the project ID by visiting your supabase.com dashboard for the project and looking at the ID in the URL

```bash
npx supabase link --project-ref <project-id>
```

### 3. Run migrations

> This creates all tables AND seeds them with relational data!

```bash
npx supabase migration up --linked
```

> **Note for maintainers:** If you've updated JSON data files, regenerate migrations first with `node scripts/generate-seed-migrations.js`


## Self-Host Supabase (Optional)

> If you prefer to self-host supabase, follow the guide: [Supabase Local DB](https://supabase.com/docs/guides/local-development)
