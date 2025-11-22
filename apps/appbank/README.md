# 📱 FlutterBank — App Exemplo

O repositório utiliza este app como alvo da pipeline ( foco é somente um exemplo para o pipeline ) **FlutterBank**, contendo um módulo **PIX (Envio)**.

O app demonstra:

- Modularização com **Melos**  
- Arquitetura limpa aplicada  
- Gerenciamento com **Riverpod**  
- Navegação com **GoRouter**  
- Fluxos com **Command Pattern**

As chamadas externas são simuladas — o objetivo é permitir **testes reais de CI/CD**, sem necessidade de backend.

---

# 🗂 Estrutura do Projeto

```plaintext
/
├── .github/workflows/     # CI/CD completo
├── pix/                   # App (exemplo) modular
└── scripts/               # Scripts executados

```

