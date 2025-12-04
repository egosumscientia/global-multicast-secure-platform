# Global Multicloud Secure Platform

Infraestructura automatizada con Terraform para crear una red privada segura entre AWS, Azure y Google Cloud (GCP) usando conexiones Site-to-Site VPN e integración de rutas privadas.

---

## Arquitectura

### AWS

* VPC `10.10.0.0/16`
* Subnet privada
* EC2 Linux
* VPN Gateway
* Customer Gateway
* Dos túneles IPsec hacia Azure y GCP
* Rutas privadas

### Azure

* VNet `10.20.0.0/16`
* Subnet `GatewaySubnet`
* Virtual Network Gateway
* Local Network Gateways (AWS y GCP)
* Conexiones VPN S2S
* VM Linux

### GCP

* VPC `10.30.0.0/16`
* HA VPN (dos túneles hacia AWS)
* VPN hacia Azure
* VM Linux
* Rutas privadas

---

## Requisitos

* Terraform >= 1.5
* AWS CLI configurado
* Azure CLI configurado
* Google Cloud SDK configurado
* Cuentas en AWS, Azure y GCP

---

## Uso

### 1. Clonar el repositorio

```bash
git clone https://github.com/<TU_USUARIO>/global-multicloud-secure-platform.git
cd global-multicloud-secure-platform
```

### 2. Crear archivo terraform.tfvars

El archivo real **no va en el repositorio**. Usa la plantilla:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edita tus IPs públicas, PSKs y credenciales.

---

## 3. Deploy

```bash
terraform init
terraform plan
terraform apply
```

---

## 4. Validación

### Azure

```bash
az network vpn-connection show --name conn-azure-aws --resource-group rg-multicloud --query connectionStatus
az network vpn-connection show --name conn-azure-gcp --resource-group rg-multicloud --query connectionStatus
```

### GCP

```bash
gcloud compute vpn-tunnels list --regions=us-central1
```

### AWS

```bash
aws ec2 describe-vpn-connections --query "VpnConnections[*].{ID:VpnConnectionId,State:State}"
```

---

## 5. Pruebas entre VMs

### Desde Azure VM

```bash
ping 10.10.2.9     # VM AWS
ping 10.30.1.2     # VM GCP
```

### Desde GCP VM

```bash
ping 10.20.2.x     # VM Azure
ping 10.10.2.9     # VM AWS
```

---

## 6. Destruir

```bash
terraform destroy
```

---

## Estructura del repositorio

```
.
├── aws/
├── azure/
├── gcp/
├── diagrams/
├── vpn/
├── terraform.tfvars.example
├── variables.tf
├── main.tf
└── README.md
```

---

## Notas

* Solo para demostración técnica.
* No subir terraform.tfvars.
* Requiere ajustar rutas si se cambian CIDRs.
