<div align="center">

# ☸️ Zero-Trust Multi-Tenant Kubernetes (AKS) Platform

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.28%2B-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![Azure AKS](https://img.shields.io/badge/Azure-AKS_Private_Cluster-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](#)
[![Calico](https://img.shields.io/badge/Security-Calico_eBPF_NetPol-10B981?style=for-the-badge&logo=tigera&logoColor=white)](#)
[![Key Vault CSI](https://img.shields.io/badge/Secrets-Key_Vault_CSI-844FBA?style=for-the-badge&logo=hashicorp&logoColor=white)](#)

**Production-hardened, zero-trust container orchestration framework deployed on private Azure Kubernetes Service (AKS) with automated GitOps delivery pipelines.**

</div>

---

## 🛡️ Architecture & Security Baselines

- 🔒 **Private Cluster Topology:** API server accessible strictly via Private Endpoints and internal jumpboxes. Zero public exposure.
- 🌐 **Calico Network Policies:** Default-deny ingress and egress across all tenant namespaces. Explicit whitelisting for DNS and inter-service telemetry.
- 🔑 **Azure Key Vault Secrets Store CSI Driver:** Elimination of hardcoded Kubernetes secrets; secrets mounted as in-memory volumes with automated 2-minute rotation.
- ⚡ **Egress Traffic Control:** Forced tunneling via User Defined Routing (UDR) through central Azure Firewall for TLS inspection.
- 📦 **Stateful Persistence:** Azure Managed Disk CSI driver with automated volume snapshotting and persistent volume claims (PVC).

```mermaid
graph LR
    subgraph Cluster["☸️ Hardened AKS Cluster (Private IPAM)"]
        ING["AGIC Ingress"] --> POD1["Axion Microservice Pod"]
        POD1 -. "Default Deny" .- POD2["Internal Database Pod"]
        POD1 --> CSI["Key Vault CSI Driver"]
    end
    CSI -. "Managed Identity" .-> KV["Azure Key Vault"]
    ING --> UDR["UDR Forced Tunnel (0.0.0.0/0)"] --> FW["Azure Firewall"]

    classDef blue fill:#0B1F3A,stroke:#0078D4,stroke-width:2px,color:#fff;
    classDef green fill:#052e16,stroke:#10b981,stroke-width:2px,color:#fff;
    class Cluster blue;
    class KV,FW green;
```

---

## 📁 Repository Structure

```
.
├── terraform/                # Infrastructure as Code for AKS cluster
│   └── main.tf               # Private AKS, node pools, CNI + Calico
├── manifests/
│   ├── calico-default-deny.yaml      # Zero-trust network policies
│   └── keyvault-secret-provider.yaml # CSI Driver SecretProviderClass
└── README.md
```

---

## 👤 Author

**Sujeet Kumar**  
*Senior DevSecOps Engineer & Enterprise Cloud Architect (17+ Years Experience)*  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://linkedin.com/in/sujeetkumar122)
[![GitHub](https://img.shields.io/badge/GitHub-Sujeetkumar122-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/Sujeetkumar122)
