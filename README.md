# Guild Wars JSON Data

## All Data in `.json` Files!

Use however you like

## Creating a Postgres Database (optional)

> Follow these instructions to turn the JSON files into a normalized Postgres DB! You don't need to keep using Supabase afterwards if you don't want since it creates a regular Postgres DB you can connect to!

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

> **Note for maintainers:** If you've updated JSON data files, regenerate migrations first with `node scripts/generate-seed-migrations.js`

```bash
npx supabase migration up --linked
```

### 4. Seed the database

After running migrations, populate the database with data:

```bash
cd supabase
npm install
npm run seed
```

This will:
- Load all 10 Guild Wars professions
- Load all profession attributes and rank titles
- Import all skills from the JSON data files

See `supabase/README.md` for more details on the database setup and seeding process.
