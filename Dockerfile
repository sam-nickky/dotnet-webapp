# ================================
# 1️⃣ Build Stage (.NET 6)
# ================================
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /app

# Copy solution & project files
COPY dotnet-demoapp.sln ./
COPY src ./src

# Restore dependencies for the main project
RUN dotnet restore src/dotnet-demoapp.csproj

# Build and publish the app
RUN dotnet publish src/dotnet-demoapp.csproj -c Release -o /app/publish

# ================================
# 2️⃣ Runtime Stage (.NET 6)
# ================================
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app
COPY --from=build /app/publish .

# ✅ Force ASP.NET Core to listen on port 5000
ENV DOTNET_URLS=http://+:5000

# Expose port 5000
EXPOSE 5000

ENTRYPOINT ["dotnet", "dotnet-demoapp.dll"]

