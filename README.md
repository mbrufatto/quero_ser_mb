# Crypto Exchange App - Desafio Técnico

Este é um aplicativo iOS desenvolvido em **SwiftUI** para listar e detalhar exchanges de criptomoedas, consumindo a API do **CoinMarketCap**. O foco principal do projeto foi a criação de uma interface performática, código limpo e uma suíte de testes de UI resiliente.

## 📱 Funcionalidades

- **Lista de Exchanges:** Visualização das principais corretoras com nome, ano de fundação e volume de transações.
- **Detalhes da Exchange:** Informações aprofundadas incluindo descrição, taxas (Maker/Taker), website oficial e lista de moedas disponíveis.
- **Busca de Dados:** Utilizei a busca local via filter para garantir uma experiência de usuário fluida e instantânea. Uma vez que já possuímos os dados mapeados na memória, realizar o filtro localmente evita requisições desnecessárias à API, economiza banda do usuário e mantém a lógica de filtragem simples, legível e de fácil manutenção dentro da ViewModel. .

## 🏗️ Arquitetura

O projeto utiliza o padrão **MVVM (Model-View-ViewModel)**.

### Decisões de Design

Para este desafio, optou-se pela utilização do fluxo de navegação nativo do SwiftUI através de `NavigationLink` e `NavigationStack` (em vez de um padrão Coordinator).

- **Navegação Declarativa:** O uso do `NavigationLink` mantém o projeto alinhado com a filosofia declarativa do SwiftUI, reduzindo o boilerplate e facilitando a manutenção.
- **Responsabilidade Única:** Cada View é responsável por disparar sua transição, enquanto a ViewModel gerencia o estado e os dados necessários para a tela de destino.
- **Segurança:** Utilização de arquivos de configuração (`.xcconfig`) para isolar chaves de API, seguindo as melhores práticas de segurança de código.

## 🧪 Testes de UI e Estabilidade

Um dos maiores desafios técnicos superados neste projeto foi a estabilização dos testes de UI em ambientes de simulação lentos.

### Estratégias de Resiliência:
- **Acessibilidade Inteligente:** Implementação de `.accessibilityIdentifier` e `.accessibilityLabel` estratégicos para garantir que o motor de teste encontre os elementos mesmo quando a hierarquia do SwiftUI é otimizada (achatada).
- **Timeouts Adaptativos:** Configuração de esperas de até 20-30 segundos para o carregamento inicial (cold start), prevenindo falhas por latência do simulador.
- **Limpeza de Dados:** Lógica de tratamento de strings nos testes para validar títulos de navegação de forma precisa, ignorando ruídos de formatação de moeda ou datas.
- **Otimização de Launch:** Uso de `launchArguments` para desativar animações do sistema durante os testes, tornando a execução mais rápida e previsível.

## ♿ Acessibilidade e Testabilidade

O app foi preparado para suportar automação e tecnologias assistivas nos fluxos críticos:
- **Identificadores Estratégicos:** Implementação de `accessibilityIdentifier` nos elementos chave da lista e da tela de detalhes, garantindo a robustez dos testes de UI.
- **Labels de Acessibilidade:** Uso de `accessibilityLabel` para simplificar a leitura de elementos complexos (como células de exchanges), assegurando que o motor de teste capture o conteúdo correto mesmo com otimizações de hierarquia do SwiftUI.

## ⚙️ Como Executar o Projeto

### Pré-requisitos
- Xcode 15.0+
- iOS 17.0+

### Passo a Passo
1. Clone o repositório:
   ```bash
   git clone [https://github.com/mbrufatto/quero_ser_mb.git](https://github.com/mbrufatto/quero_ser_mb.git)
   ```
2. Abra o arquivo ExchangeApp.xcodeproj no Xcode;
3. Crie o arquivo Secrets.xcconfig na raiz do projeto (instruções abaixo);
4. Selecione um simulador com iOS 17+ e pressione Cmd + R para rodar ou Cmd + U para os testes.

## 🔐 Configuração do Secrets (API Key)

Para que o app realize chamadas à API do CoinMarketCap, é necessário configurar sua chave de acesso:

1. Na raiz do projeto, crie um arquivo chamado `Secrets.xcconfig`.
2. Adicione o seguinte conteúdo ao arquivo:
   ```text
   API_KEY = sua_chave_aqui_sem_aspas
   ```
