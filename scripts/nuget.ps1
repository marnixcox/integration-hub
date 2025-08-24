# This script packs and pushes NuGet packages to your Azure Artifacts feed
# Make sure to install Powershell first
# winget install Microsoft.PowerShell

$env:ORG_NAME = 'YourDevOpsOrganisation'
$env:PROJECT_NAME = 'YourDevOpsProject'
$env:FEED_NAME = 'YourFeedName'

dotnet pack src/model/model.csproj --output nupkgs-model
dotnet pack src/library/library.csproj --output nupkgs-library

# Uncomment nuget push lines once DevOps feed setup is completed
#dotnet nuget push --api-key az --skip-duplicate --source https://pkgs.dev.azure.com/$env:ORG_NAME/$env:PROJECT_NAME/_packaging/$env:FEED_NAME/nuget/v3/index.json nupkgs-model\*.nupkg
#dotnet nuget push --api-key az --skip-duplicate --source https://pkgs.dev.azure.com/$env:ORG_NAME/$env:PROJECT_NAME/_packaging/$env:FEED_NAME/nuget/v3/index.json nupkgs-library\*.nupkg

