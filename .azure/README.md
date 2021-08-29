# Azure

## Setting up a build task for the container

```powershell
$AzAccount = az login --tenant $($env:TenantId)

$ACR_TASK = az acr task create `
  --registry            sqlhorizons `
  --name                pwshAgentImageBuild `
  --context             "https://github.com/SQLHorizons/ses-acr-ado-agent.git#main" `
  --file                Dockerfile `
  --arg                 FROM_TAG=7.1.4-ubuntu-20.04 `
  --arg                 PWSH_CORE_REPO=mcr.microsoft.com/powershell `
  --arg                 PESTER_VERSION=5.3.0 `
  --arg                 ANALYZER_VERSION=1.20.0 `
  --arg                 AZP_AGENT_VERSION=2.191.1 `
  --image               ado.pwsh.agent:$(cat version.txt) `
  --git-access-token    $env:ACR_TOKEN
##  az acr task delete -n pwshAgentImageBuild -r sqlhorizons -y
```
