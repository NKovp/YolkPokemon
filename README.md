# YolkPokemon API

A REST API for managing Pokémon and Trainers, built with ASP.NET 9, PostgreSQL 17, and Entity Framework Core 9 (Database-First approach).

---

## 🛠 Requirements

- [.NET SDK 9](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)
- [PostgreSQL 17](https://www.postgresql.org/download/)
- EF Core 9 (via NuGet or CLI)
- pgAdmin or any other PostgreSQL client

---

## 📦 Setup Instructions

### 1. Clone the project

```bash
git clone https://github.com/your-username/YolkPokemon.git
cd YolkPokemon
```

---

### 2. Create and prepare the database

Use pgAdmin or psql to run the following SQL scripts located in the `Source` folder:

#### ➤ Step 1:
```sql
-- create_pokemon_db.sql
```
This script creates the database and base tables.

#### ➤ Step 2:
```sql
-- pokemon_database_complete.sql
```
This script inserts seed data into the database.

---

### 3. Configure the connection string

Open the file:

```
appsettings.Development.json
```

And add the following block (or update it if it already exists):

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=pokemon_db;Username=postgres;Password=your-password"
  }
}
```

📌 Replace `your-password` with your actual PostgreSQL password.

---

### 4. Build the project

```bash
dotnet build
```

---

### 5. Run the application

```bash
dotnet run
```

The API will be available at:  
[http://localhost:8081](http://localhost:8081)

---

## 🧪 Swagger UI

Once running, you can access the interactive API documentation at:

```
http://localhost:8081/swagger
```

---

## 🔧 Technology Stack

- ASP.NET Core 9
- PostgreSQL 17
- EF Core 9 (Database-First)
- Swagger / OpenAPI
- Docker (for production)
- Railway (for deployment)

---

## 🧹 Useful Commands

```bash
# Restore dependencies
dotnet restore

# Build the project
dotnet build

# Run the application
dotnet run

# (Optional) Scaffold EF models again
dotnet ef dbcontext scaffold "Host=...;Database=...;" Npgsql.EntityFrameworkCore.PostgreSQL -o Models
```

---

## ❓ Troubleshooting

- Make sure PostgreSQL is running
- Confirm the connection string is correct
- Ensure both SQL scripts were executed successfully

---

🚀 Happy coding!