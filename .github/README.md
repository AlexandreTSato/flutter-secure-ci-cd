![alt text](image-3.png)

<br>

# 🔐 CI/CD Seguro para Aplicativos Flutter  
Pipeline Android com ferramentas Open Source · Segurança Mobile · Supply Chain · SAST/DAST

---

# 🏷️ Badges Profissionais

<p align="left">

<img src="https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-blue?logo=githubactions&logoColor=white" />
<img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
<img src="https://img.shields.io/badge/Android-Secure-green?logo=android" />

<img src="https://img.shields.io/badge/SAST-MobSF-informational?logo=security" />
<img src="https://img.shields.io/badge/SAST-Custom%20Rules-grey?logo=gnu-bash" />

<img src="https://img.shields.io/badge/DAST-mitmproxy-critical?logo=hackthebox" />

<img src="https://img.shields.io/badge/Secrets-Gitleaks-orange?logo=git" />
<img src="https://img.shields.io/badge/Secrets-Detect--Secrets-orange?logo=github" />

<img src="https://img.shields.io/badge/SCA-Trivy-yellow?logo=aqua" />
<img src="https://img.shields.io/badge/SCA-OSV.dev-yellow?logo=oss" />

<img src="https://img.shields.io/badge/SLSA-L3-purple?logo=googlecloud" />
<img src="https://img.shields.io/badge/Supply--Chain-Cosign-purple?logo=sigstore" />

</p>

---

# 🚀 Visão Geral

Este repositório apresenta um pipeline completo de **CI/CD seguro para Flutter (Android)**, usando **somente ferramentas open-source** ou gratuitas.  
A pipeline cobre:

- Segurança mobile automatizada  
- Análises SAST e DAST  
- Supply Chain Security (SLSA + Cosign)  
- Secret scanning em múltiplas camadas  
- Build Android com gates de segurança  
- Flutter modular com Melos  
- App real como alvo (FlutterBank – módulo PIX)

O objetivo é oferecer um **exemplo profissional de pipeline**, útil para profissionais que desejam aprender ou adotar CI/CD seguro para apps Flutter com foco em ferramentas open-source.

---

# 🛡️ Segurança Aplicada ao Pipeline

A pipeline implementa verificações automáticas que cobrem uma parte essencial dos padrões modernos de segurança mobile e supply chain.

---

# 📌 OWASP Mobile Top 10 (Cobertura Automática via CI/CD)

| Risco | O que é analisado | Ferramentas |
|---|---|---|
| **M1 – Uso Impróprio da Plataforma** | Manifest, permissões, exported components, debuggable | MobSF + Regras Customizadas |
| **M2 – Armazenamento Inseguro** | Dados sensíveis, hardcoded secrets, arquivos expostos | MobSF + Binary Secret Scan |
| **M3 – Comunicação Insegura** | SSL Pinning, TrustManager, cleartext traffic, ataques MITM | mitmproxy + checks customizados |
| **M4 – Autenticação Insegura** | Análise estática parcial | MobSF |
| **M5 – Autorização Insegura** | Rotas e endpoints acessíveis (estático) | MobSF |
| **M6 – Código Inseguro** | API insegura, exceptions, lógica arriscada | MobSF |
| **M7 – Falhas de Logging** | Side channels, logs sensíveis | MobSF |
| **M8 – Dependências Vulneráveis** | CVEs em bibliotecas Android e Dart | Trivy + OSV.dev |
| **M9 – Funcionalidades Expostas** | Segredos, chaves, debug | Gitleaks + Detect-Secrets |
| **M10 – Extensibilidade Insegura** | Broadcasts/receivers e exports | MobSF |

> Importante: cobertura baseada **exclusivamente em ferramentas automáticas de CI/CD para Android**.

---

# 📘 MASVS — Mobile Application Security Verification Standard

O pipeline atende principalmente **MASVS-L1** e partes relevantes de **MASVS-L2**, incluindo comunicação, resiliência e cadeia de suprimentos.

| Categoria | Cobertura | Ferramentas |
|---|---|---|
| **V1 – Arquitetura & Build** | Manifest seguro, permissões e metadata | MobSF + Custom SAST |
| **V2 – Armazenamento** | Busca por dados sensíveis | Binary Scan |
| **V3 – Criptografia** | Crypto insegura (verificação estática) | MobSF |
| **V5 – Comunicação** | SSL Pinning + DAST | mitmproxy |
| **V7 – Supply Chain** | Proveniência, SCA e assinaturas | Cosign + OSV + Trivy |

---

# 🔗 Supply Chain Security (SLSA)

| Processo | Cobertura | Ferramentas |
|---|---|---|
| **Proveniência** | Build autenticado com OIDC | slsa-framework |
| **Integridade** | Assinatura e verificação | Cosign |
| **SCA** | Auditoria de dependências | Trivy + OSV Scanner |

---

# 🛠️ Ferramentas (Open Source)

## 🔍 SAST / SCA

| Ferramenta | Função |
|---|---|
| **MobSF** | Análise estática da APK/Manifest |
| **Gitleaks** | Secret scanning no repositório |
| **Detect-Secrets** | Pre-commit para evitar novos segredos |
| **Binary Secret Scan** | Busca por segredos no APK compilado |
| **Trivy** | SCA – vulnerabilidades em libs Android e Dart |
| **OSV Scanner** | Auditoria de dependências Pub |
| **Custom SAST (bash)** | Heurísticas avançadas: Pinning, TrustManager, crypto fraca |

---

## ⚔️ DAST / Enforcement

| Ferramenta | Finalidade |
|---|---|
| **mitmproxy** | Teste automatizado de MITM + validação de pinning |
| **OWASP ZAP** | Segurança das APIs externas consumidas pelo app |
| **Cosign** | Assinatura + verificação de integridade |
| **Scripts Customizados** | Integração entre MobSF e validações de pinning |

---

# 🔒 Gates de Segurança

| Etapa | Verificação | Gate |
|---|---|---|
| **Pre-commit** | Segredos + lint | ❌ Novo segredo = bloqueado |
| **CI** | SAST + SCA + testes | ❌ HIGH/CRITICAL = bloqueado |
| **Build Android** | Hardening + MobSF | ❌ Falhas críticas = bloqueado |
| **DAST** | MITM / SSL Pinning | ❌ Pinning falhou = bloqueado |
| **Supply Chain** | Cosign + SLSA | ❌ Proveniência inválida = bloqueado |

---

# 📱 FlutterBank — App Exemplo

O repositório utiliza este app como alvo da pipeline ( foco é somente um exemplo para o pipeline ) **FlutterBank**, contendo um módulo **PIX (Envio)**.

O app demonstra:

- Modularização com **Melos**  
- Arquitetura limpa aplicada  
- Gerenciamento com **Riverpod**  
- Navegação com **GoRouter**  
- Fluxos com **Command Pattern**

![alt text](Screenshot_1763233812-1.png) ![alt text](Screenshot_1763233847.png)

As chamadas externas são simuladas — o objetivo é permitir **testes reais de CI/CD**, sem necessidade de backend.

---

# 🗂 Estrutura do Projeto

```plaintext
/
├── .github/workflows/     # CI/CD completo
├── pix/                   # App (exemplo) modular
└── scripts/               # Scripts executados

```

# ⭐ Destaques Técnicos

- 🛠️ Projeto em desenvolvimento e evolução contínua para aprofundar maturidade de segurança  
- Pipeline **totalmente automatizada** com foco em segurança mobile  
- Verificações SAST, DAST e Supply Chain integradas ao fluxo  
- Cobertura prática dos principais vetores de ataque mobile (OWASP Mobile)  
- Execução de **MITM automatizado** com validação de SSL Pinning  
- Builds Android reforçados por **MobSF + regras customizadas**  
- Segurança aplicada **do commit ao deploy**, com gates por estágio  


<br>

# 💡 Próximos Passos

- Expandir instrumentação para requisitos de **MASVS-L2**  
- Implementar esteira para **deploy da Play Store** 
 

