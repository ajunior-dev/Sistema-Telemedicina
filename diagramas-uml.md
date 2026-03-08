# Sistema de Telemedicina - Diagramas UML

---

## 1. Diagrama de Casos de Uso

```mermaid
graph TB
    subgraph "Sistema de Telemedicina"
        UC01[Realizar Cadastro]
        UC02[Agendar Consulta]
        UC03[Participar de Atendimento Online]
        UC04[Realizar Atendimento de Telemedicina]
        UC05[Emitir Diagnóstico]
        UC06[Emitir Receita Digital]
        UC07[Registrar Informações do Paciente]
        UC08[Auxiliar Atendimento]
        UC09[Armazenar Prontuário]
        UC10[Garantir Segurança dos Dados]
    end
    
    Paciente([Paciente])
    Medico([Médico])
    Enfermeiro([Enfermeiro])
    Sistema([Sistema])
    
    Paciente --> UC01
    Paciente --> UC02
    Paciente --> UC03
    
    Medico --> UC04
    Medico --> UC05
    Medico --> UC06
    
    Enfermeiro --> UC07
    Enfermeiro --> UC08
    
    Sistema --> UC09
    Sistema --> UC10
    
    UC04 -.include.-> UC09
    UC05 -.include.-> UC09
    UC06 -.include.-> UC09
    UC04 -.include.-> UC10
```

---

## 2. Diagrama de Classes

```mermaid
classDiagram
    class Usuario {
        -int id
        -string nome
        -string email
        -string senha
        -string cpf
        -string telefone
        +autenticar() bool
        +atualizarDados() void
    }
    
    class Paciente {
        -string historicoMedico
        -Date dataNascimento
        -string endereco
        +realizarCadastro() bool
        +agendarConsulta() bool
        +acessarProntuario() Prontuario
    }
    
    class Medico {
        -string crm
        -string especialidade
        -List~HorarioDisponivel~ agenda
        +realizarAtendimento() bool
        +emitirDiagnostico() Diagnostico
        +emitirReceita() ReceitaDigital
        +consultarProntuario() Prontuario
    }
    
    class Enfermeiro {
        -string coren
        -string setor
        +registrarInformacoes() bool
        +auxiliarAtendimento() bool
    }
    
    class Consulta {
        -int id
        -DateTime dataHora
        -string status
        -string linkVideoconferencia
        -int duracao
        +iniciar() bool
        +finalizar() bool
        +reagendar() bool
        +cancelar() bool
    }
    
    class Atendimento {
        -int id
        -DateTime dataHoraInicio
        -DateTime dataHoraFim
        -string sintomas
        -string observacoes
        +registrar() bool
        +salvarNoProntuario() bool
    }
    
    class Diagnostico {
        -int id
        -string descricao
        -string cid
        -DateTime dataEmissao
        +salvar() bool
        +consultar() string
    }
    
    class ReceitaDigital {
        -int id
        -string medicamentos
        -string posologia
        -DateTime dataEmissao
        -DateTime dataValidade
        -bool medicamentoControlado
        +gerar() bool
        +validar() bool
    }
    
    class Prontuario {
        -int id
        -DateTime dataCriacao
        -List~Atendimento~ historico
        +adicionar(Atendimento) void
        +consultar() List~Atendimento~
        +exportar() string
    }
    
    class Videoconferencia {
        -string salaId
        -string tokenAcesso
        -bool criptografiaAtiva
        +estabelecerConexao() bool
        +encerrarConexao() void
        +reconectar() bool
    }
    
    Usuario <|-- Paciente
    Usuario <|-- Medico
    Usuario <|-- Enfermeiro
    
    Paciente "1" -- "0..*" Consulta : agenda
    Medico "1" -- "0..*" Consulta : atende
    Enfermeiro "0..1" -- "0..*" Consulta : auxilia
    
    Consulta "1" -- "1" Atendimento : gera
    Consulta "1" -- "1" Videoconferencia : utiliza
    
    Atendimento "1" -- "0..1" Diagnostico : possui
    Atendimento "1" -- "0..1" ReceitaDigital : gera
    
    Paciente "1" -- "1" Prontuario : possui
    Prontuario "1" -- "0..*" Atendimento : contém
```

---

## 3. Diagrama de Sequência - Realizar Atendimento de Telemedicina

```mermaid
sequenceDiagram
    actor P as Paciente
    actor M as Médico
    actor E as Enfermeiro
    participant S as Sistema
    participant V as Videoconferência
    participant PR as Prontuário
    
    P->>S: Acessar sala virtual (horário agendado)
    M->>S: Iniciar consulta
    
    S->>S: Verificar autenticação
    
    S->>V: Estabelecer conexão segura
    V-->>P: Conectar ao médico
    V-->>M: Conectar ao paciente
    
    M->>P: Analisar sintomas
    P-->>M: Relatar sintomas
    
    opt Informações adicionais
        M->>P: Solicitar exames/informações
        P-->>M: Fornecer informações
    end
    
    opt Enfermeiro presente
        E->>S: Registrar informações clínicas
    end
    
    M->>S: Registrar diagnóstico
    S->>PR: Salvar diagnóstico
    
    opt Emitir receita
        M->>S: Emitir receita digital
        S->>S: Validar receita (RN01)
        S->>PR: Salvar receita
    end
    
    S->>PR: Salvar atendimento completo
    
    M->>S: Encerrar atendimento
    S->>V: Finalizar conexão
    
    S-->>M: Atendimento registrado
    S-->>P: Atendimento registrado
```

---

## 4. Diagrama de Sequência - Exceção: Falha de Conexão

```mermaid
sequenceDiagram
    actor P as Paciente
    actor M as Médico
    participant S as Sistema
    participant V as Videoconferência
    
    M->>V: Durante atendimento
    P->>V: Durante atendimento
    
    V->>V: Perda de conexão detectada
    
    V->>S: Notificar falha
    S->>S: Tentar reconexão automática
    
    alt Reconexão bem-sucedida
        S->>V: Restabelecer conexão
        V-->>M: Conexão restabelecida
        V-->>P: Conexão restabelecida
        M->>V: Continuar atendimento
    else Reconexão falha
        S-->>M: Informar falha de conexão
        S-->>P: Informar falha de conexão
        S->>S: Registrar consulta interrompida
        S-->>M: Opções de reagendamento
        S-->>P: Opções de reagendamento
    end
```

---

## 5. Diagrama de Atividades - Fluxo de Atendimento

```mermaid
flowchart TD
    Start([Início]) --> Login[Paciente faz login]
    Login --> Sala[Paciente entra na sala virtual]
    Sala --> Espera{Aguardar até 15 min - RN02}
    
    MedicoLogin[Médico faz login] --> MedicoInicia[Médico inicia consulta]
    
    Espera -->|Paciente presente| Conectar[Estabelecer conexão segura - RN03]
    Espera -->|Paciente ausente| Ausente[Registrar ausência]
    Ausente --> EndAusente([Fim - Consulta não realizada])
    
    MedicoInicia --> Conectar
    
    Conectar --> Videoconferencia{Conexão OK?}
    
    Videoconferencia -->|Sim| Analisar[Médico analisa sintomas]
    Videoconferencia -->|Não| Reconectar[Tentar reconexão]
    
    Reconectar --> Reconexao{Reconexão OK?}
    Reconexao -->|Sim| Analisar
    Reconexao -->|Não| Reagendar[Permitir reagendamento]
    Reagendar --> EndReagendar([Fim - Reagendar])
    
    Analisar --> SolicitaInfo{Solicitar mais informações?}
    SolicitaInfo -->|Sim| Exames[Solicitar exames/informações]
    Exames --> Analisar
    SolicitaInfo -->|Não| Enfermeiro{Enfermeiro presente?}
    
    Enfermeiro -->|Sim| RegistroEnf[Enfermeiro registra informações]
    Enfermeiro -->|Não| Diagnostico
    RegistroEnf --> Diagnostico[Médico registra diagnóstico]
    
    Diagnostico --> Receita{Emitir receita?}
    Receita -->|Sim| GerarReceita[Gerar receita digital - RN01]
    GerarReceita --> SalvarProntuario
    Receita -->|Não| SalvarProntuario[Salvar no prontuário - RN04, RN05]
    
    SalvarProntuario --> Encerrar[Encerrar atendimento]
    Encerrar --> End([Fim - Atendimento registrado])
    
    style Start fill:#90EE90
    style End fill:#90EE90
    style EndAusente fill:#FFB6C1
    style EndReagendar fill:#FFB6C1
    style SalvarProntuario fill:#87CEEB
```

---

## 6. Diagrama de Estados - Consulta

```mermaid
stateDiagram-v2
    [*] --> Agendada: Paciente agenda
    
    Agendada --> EmAndamento: Horário chegou & Paciente presente
    Agendada --> NaoRealizada: Paciente ausente (15+ min)
    Agendada --> Cancelada: Cancelamento solicitado
    
    EmAndamento --> Interrompida: Falha de conexão
    EmAndamento --> Concluída: Atendimento finalizado
    
    Interrompida --> EmAndamento: Reconexão bem-sucedida
    Interrompida --> Reagendada: Reconexão falhou
    
    Concluída --> [*]
    NaoRealizada --> [*]
    Cancelada --> [*]
    Reagendada --> Agendada
    
    note right of Agendada
        Aguarda horário marcado
    end note
    
    note right of EmAndamento
        Videoconferência ativa
        Diagnóstico sendo realizado
    end note
    
    note right of Concluída
        Prontuário atualizado
        Receita emitida (se aplicável)
    end note
```

---

## 7. Diagrama de Componentes

```mermaid
graph TB
    subgraph "Camada de Apresentação"
        UI_Paciente[Interface do Paciente]
        UI_Medico[Interface do Médico]
        UI_Enfermeiro[Interface do Enfermeiro]
    end
    
    subgraph "Camada de Aplicação"
        Auth[Módulo de Autenticação]
        Agendamento[Módulo de Agendamento]
        Atendimento[Módulo de Atendimento]
        Prontuario_Mod[Módulo de Prontuário]
        Receita_Mod[Módulo de Receita Digital]
    end
    
    subgraph "Camada de Serviços"
        Video[Serviço de Videoconferência]
        Notificacao[Serviço de Notificações]
        Criptografia[Serviço de Criptografia E2EE]
        Auditoria[Serviço de Auditoria]
    end
    
    subgraph "Camada de Dados"
        DB[(Banco de Dados)]
        Storage[(Armazenamento de Arquivos)]
    end
    
    UI_Paciente --> Auth
    UI_Medico --> Auth
    UI_Enfermeiro --> Auth
    
    UI_Paciente --> Agendamento
    UI_Paciente --> Atendimento
    
    UI_Medico --> Atendimento
    UI_Medico --> Prontuario_Mod
    UI_Medico --> Receita_Mod
    
    UI_Enfermeiro --> Atendimento
    UI_Enfermeiro --> Prontuario_Mod
    
    Atendimento --> Video
    Atendimento --> Criptografia
    Atendimento --> Prontuario_Mod
    
    Agendamento --> Notificacao
    
    Prontuario_Mod --> DB
    Prontuario_Mod --> Storage
    Prontuario_Mod --> Auditoria
    
    Receita_Mod --> DB
    Receita_Mod --> Auditoria
    
    Auth --> DB
    Agendamento --> DB
    
    Video --> Criptografia
```

---

## 8. Diagrama de Implantação

```mermaid
graph TB
    subgraph "Dispositivos do Cliente"
        Browser_Paciente[Navegador Web/App Móvel - Paciente]
        Browser_Medico[Navegador Web/Desktop App - Médico]
        Browser_Enfermeiro[Navegador Web - Enfermeiro]
    end
    
    subgraph "Zona DMZ"
        LoadBalancer[Load Balancer]
        Firewall[Firewall/WAF]
    end
    
    subgraph "Servidor de Aplicação"
        WebServer1[Servidor Web 1<br/>Nginx/IIS]
        WebServer2[Servidor Web 2<br/>Nginx/IIS]
        AppServer1[Servidor de Aplicação 1<br/>Node.js/Java/.NET]
        AppServer2[Servidor de Aplicação 2<br/>Node.js/Java/.NET]
    end
    
    subgraph "Serviços Especializados"
        VideoServer[Servidor de Videoconferência<br/>WebRTC/Jitsi/Zoom API]
        AuthServer[Servidor de Autenticação<br/>OAuth2/JWT]
    end
    
    subgraph "Camada de Dados"
        DBMaster[(Banco de Dados Master<br/>PostgreSQL/MySQL)]
        DBReplica[(Banco de Dados Réplica<br/>PostgreSQL/MySQL)]
        FileStorage[(Storage de Arquivos<br/>S3/Azure Blob)]
    end
    
    subgraph "Serviços de Backup"
        Backup[(Sistema de Backup)]
        Logs[(Sistema de Logs)]
    end
    
    Browser_Paciente -->|HTTPS| Firewall
    Browser_Medico -->|HTTPS| Firewall
    Browser_Enfermeiro -->|HTTPS| Firewall
    
    Firewall --> LoadBalancer
    
    LoadBalancer --> WebServer1
    LoadBalancer --> WebServer2
    
    WebServer1 --> AppServer1
    WebServer2 --> AppServer2
    
    AppServer1 --> AuthServer
    AppServer2 --> AuthServer
    
    AppServer1 --> VideoServer
    AppServer2 --> VideoServer
    
    AppServer1 --> DBMaster
    AppServer2 --> DBMaster
    
    DBMaster -.Replicação.-> DBReplica
    
    AppServer1 --> FileStorage
    AppServer2 --> FileStorage
    
    DBMaster --> Backup
    FileStorage --> Backup
    
    AppServer1 --> Logs
    AppServer2 --> Logs
```

---

## 9. Mapeamento de Requisitos para Diagramas

| ID Requisito | Funcionalidade | Diagramas Relacionados |
|--------------|----------------|------------------------|
| RF01 | Realizar Cadastro | Casos de Uso, Classes (Usuario, Paciente) |
| RF02 | Agendar Consulta | Casos de Uso, Classes (Consulta), Componentes |
| RF03 | Participar de Atendimento Online | Casos de Uso, Sequência, Classes (Videoconferencia) |
| RF04 | Realizar Atendimento de Telemedicina | Casos de Uso, Sequência, Atividades, Estados |
| RF05 | Emitir Diagnóstico | Classes (Diagnostico), Sequência |
| RF06 | Emitir Receita Digital | Classes (ReceitaDigital), Sequência, Componentes |
| RF07 | Registrar Informações do Paciente | Classes (Enfermeiro), Sequência |
| RF08 | Auxiliar Atendimento | Casos de Uso, Sequência |
| RF09 | Armazenar Prontuário | Classes (Prontuario), Componentes, Implantação |
| RF10 | Garantir Segurança dos Dados | Componentes (Criptografia), Implantação (Firewall) |

---

## 10. Regras de Negócio nos Diagramas

- **RN01** (Validade da Receita Digital): Implementada na classe `ReceitaDigital` com atributo `dataValidade`
- **RN02** (Tempo Máximo de Atraso): Representada no Diagrama de Atividades e de Estados
- **RN03** (Segurança e Criptografia): Presente no Diagrama de Componentes (Serviço de Criptografia E2EE) e Sequência
- **RN04** (Acesso ao Prontuário): Implementada na classe `Prontuario` com controle de acesso
- **RN05** (Registro Obrigatório): Garantida no fluxo de Sequência e Atividades, salvando automaticamente no prontuário

---

## Ferramentas de Visualização

Estes diagramas foram criados usando **Mermaid**, que pode ser visualizado em:
- GitHub
- Visual Studio Code (com extensões Mermaid)
- Editores online: https://mermaid.live/
- Ferramentas de documentação como GitBook, Notion, etc.

Para converter para outros formatos UML (PlantUML, StarUML, etc.), use ferramentas de conversão ou recrie os diagramas na ferramenta desejada.
