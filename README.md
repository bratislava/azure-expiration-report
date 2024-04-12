# Azure Application's Secret Expiration Report

A small & simple runnable [PowerShell](https://learn.microsoft.com/en-us/powershell/) script that creates expiration report of all Azure Applications Secrets under specific [Tenant](https://learn.microsoft.com/en-us/microsoft-365/enterprise/subscriptions-licenses-accounts-and-tenants-for-microsoft-cloud-offerings?view=o365-worldwide#tenants).

## Usage

### Prerequisites

1. To get the report your need to setup following environment variables for connecting to your specific Azure AD

```bash
export AZURE_USERNAME=example-aa00-bb11-cc33-987654aa3210
export AZURE_PASSWORD=SuperSecretAndProperlyLongPassword
export AZURE_TENANTID=example-aa00-bb11-cc33-987654aa3210
```

2. Also, install into your PowerShell [Active Directory](https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps) module. 

### Running 

To run the report, you just simply run 

```pwsh
./ServicePrincipalExpirationReport.ps1
```

Every secret will be on separate line `json` formatted with one field being `status: (WARN|OK)`, which indicates, if secret is near End-Of-Life (EOL).  
You can specify how many days before you like to set the state to `WARN` by setting the `--days` parameter

```pwsh
./ServicePrincipalExpirationReport.ps1 --days=30
```

Meaning, every secret 30 days before expire will have status `WARN`.

### Docker

If you don't want to install PS and respective modules, we also provide a [`Dockerfile`](./Dockerfile), that you can use to build image with everything already preconfigured.

```bash
docker build -t expiration-report:latest .
```

and just simple run it, like

```bash
docker run -it --rm \
  --env AZURE_USERNAME='example-aa00-bb11-cc33-987654aa3210' \
  --env AZURE_PASSWORD='SuperSecretAndProperlyLongPassword' \
  --env AZURE_TENANTID='example-aa00-bb11-cc33-987654aa3210' \ 
  expiration-report:latest
```

## Credits

Taken and adjusted from Elan Shudnow's [Azure Code](https://github.com/ElanShudnow/AzureCode/blob/main/PowerShell/ServicePrincipalExpirationReport/ServicePrincipalExpirationReport.ps1)
