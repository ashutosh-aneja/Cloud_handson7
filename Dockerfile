#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["DockerDemo1.csproj", ""]
RUN dotnet restore "./DockerDemo1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DockerDemo1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerDemo1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerDemo1.dll"]