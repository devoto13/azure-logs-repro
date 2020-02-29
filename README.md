# Reproduction steps

The problem is that Container Instance stops sending logs to Log Analytics on every second restart.

This repository contains a small image, which prints couple of lines of output every 5 seconds. Image is built and pushed to the Docker hub, but source files are available in the repository for the reference. Commands used to prepare this image:

```
docker build . -t devoto13/log-analytics-repro
docker push devoto13/log-analytics-repro
```

To prepare the infrastructure create a resource group and deploy ARM template using Azure CLI. This will create two resources: Container Instance and Log Analytics. Make sure to change resource group name and set a unique prefix for resource names.

```
az group create --name plus1-tools-demo-rg --location westeurope
az group deployment create --resource-group plus1-tools-demo-rg --mode Complete --template-file template.json --parameters unique_prefix=plus1cloud-demo
```

To observe the issue:

1. Open Container Instance resource in Azure Portal and observe some logs in the Logs tab.
1. Open Log Analytics resource in Azure Portal and observe same logs (compare using timestamps) by running the query (`ContainerInstanceLog_CL | order by TimeGenerated desc | project Message`). Note that it may take a bit of time until logs are available, just try in a couple of minutes.
1. Open Container Instance resource in Azure Portal and click Restart on top. Observe some logs in the Logs tab.
1. Open Log Analytics resource in Azure Portal and observe logs from the previous step (compare using timestamps) are missing. Note that waiting does not helps, logs after container restart never appear.
1. Open Container Instance resource in Azure Portal and click Restart on top. Observe some logs in the Logs tab.
1. Repeat steps 2-5.
