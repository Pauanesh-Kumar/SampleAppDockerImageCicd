# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# ✅ Corrected path: copy .csproj directly
COPY ["SampleAppDockerImageCiCdLinux.csproj", "./"]
RUN dotnet restore "SampleAppDockerImageCiCdLinux.csproj"

# Copy everything else
COPY . .
WORKDIR "/src"
RUN dotnet build "SampleAppDockerImageCiCdLinux.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "SampleAppDockerImageCiCdLinux.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleAppDockerImageCiCdLinux.dll"]

#build command from power shell command prompt :   project path> docker build -t sampleappdockerimagecicdlinux SampleAppDockerImageCiCdLinux
#docker run -d -p 8080:8080 --name sampleapp sampleappdockerimagecicdlinux   -- this command is to check if docker image is working fine 
#locally and then check docker image running fine from local host with url http://localhost:8080/
#Tag Image for Versioning or Registry push. To push the docker image to docket hub or Git Hub first tag the image with this CLI - docker tag sampleappdockerimagecicdlinux pavnesht24/sampleapp:latest
#or use docker tag sampleappdockerimagecicdlinux pavnesht24/sampleapp:v1.0.0  for versioning.
#First login to docker hub with cli - 'docker login' then press enter and below is the login info
#Authenticating with existing credentials... [Username: pavnesht24]
#
#i Info → To login with a different account, run 'docker logout' followed by 'docker login'
#To remove container image locally
#docker stop sampleapp
#docker rm sampleapp
#docker rmi sampleappdockerimagecicdlinux





