# Use the official .NET 9 SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY YolkPokemon/*.sln ./
COPY YolkPokemon/*.csproj ./
RUN for file in *.csproj; do dotnet restore "$file"; done

# Copy the rest of the source code
COPY . .

# Build the application
RUN dotnet publish YolkPokemon/YolkPokemon.csproj -c Release -o /app/publish

# Use the official ASP.NET 9 runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Expose port 80
EXPOSE 8081

# Set the entrypoint
ENTRYPOINT ["dotnet", "YolkPokemon.dll", "--urls", "http://*:8081"]