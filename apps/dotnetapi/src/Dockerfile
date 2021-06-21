
# Get Base Image (Full .NET Core SDK)
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app
# Copy csproj and restore
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
HEALTHCHECK --interval=15s --timeout=4s CMD curl -f http://localhost/health || exit 1
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "dotnetapi.dll"]