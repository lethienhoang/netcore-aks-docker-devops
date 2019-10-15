FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["Aks.App/Aks.App.csproj", "Aks.App/"]
RUN dotnet restore "Aks.App/Aks.App.csproj"
COPY . .
WORKDIR "/src/Aks.App"
RUN dotnet build "Aks.App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Aks.App.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Aks.App.dll"]
