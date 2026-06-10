# Apache AirByte 
```
https://github.com/airbytehq/airbyte 
```
Luego de guardar en Program Files Airbyte, deben correr el siguiente script (Si estan en windows)
```
$abctlPath = "C:\Program Files\abctl\abctl"
$current = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$current;$abctlPath", "Machine")
$env:Path += ";$abctlPath"
abctl version
```

```bash 
# Verifica que abctl quedó bien instalado
abctl version

# Levanta toda la instancia local
abctl local install

abctl local install --low-resource-mode

abctl local credentials

abctl local install --username admin --password tu_clave

abctl local status        # ver el estado de la instancia
abctl local uninstall     # apaga y quita Airbyte (conserva los datos)
abctl --help              # lista completa de comandos y flags
```

```bash 
docker run --name nifi -p 8443:8443 -d -e SINGLE_USER_CREDENTIALS_USERNAME=admin -e SINGLE_USER_CREDENTIALS_PASSWORD=claseDatos2026! apache/nifi:latest
```
