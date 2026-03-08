# Sistema de Telemedicina
## Engenharia de Requisitos

---

# 1. Tabela de Rastreabilidade de Requisitos

A tabela de rastreabilidade relaciona **atores do sistema** com **funcionalidades (requisitos funcionais)**, permitindo verificar quais partes do sistema atendem cada usuário.

| ID | Ator | Funcionalidade | Descrição | Prioridade |
|----|------|---------------|-----------|-----------|
| RF01 | Paciente | Realizar Cadastro | Permitir que o paciente crie uma conta no sistema | Alta |
| RF02 | Paciente | Agendar Consulta | Permitir que o paciente selecione data e horário disponíveis para atendimento | Alta |
| RF03 | Paciente | Participar de Atendimento Online | Permitir acesso à consulta de telemedicina por vídeo | Alta |
| RF04 | Médico | Realizar Atendimento de Telemedicina | Permitir que o médico conduza a consulta remota | Alta |
| RF05 | Médico | Emitir Diagnóstico | Permitir registro do diagnóstico após o atendimento | Alta |
| RF06 | Médico | Emitir Receita Digital | Permitir geração de prescrição médica digital | Alta |
| RF07 | Enfermeiro | Registrar Informações do Paciente | Permitir atualização de dados clínicos ou triagem | Média |
| RF08 | Enfermeiro | Auxiliar Atendimento | Permitir suporte ao médico durante a consulta | Média |
| RF09 | Sistema | Armazenar Prontuário | Manter histórico médico seguro do paciente | Alta |
| RF10 | Sistema | Garantir Segurança dos Dados | Proteger informações sensíveis conforme normas de segurança | Alta |

---

# 2. Caso de Uso: Realizar Atendimento de Telemedicina

## Identificação

| Campo | Descrição |
|------|-----------|
| Nome do Caso de Uso | Realizar Atendimento de Telemedicina |
| ID | UC-04 |
| Atores | Médico (principal), Paciente (secundário), Enfermeiro (opcional) |
| Descrição | Permite que o médico realize uma consulta remota com o paciente utilizando recursos de videoconferência e registre o diagnóstico no sistema. |
| Pré-condições | Paciente deve possuir consulta previamente agendada e estar autenticado no sistema. Médico deve estar autenticado e disponível para atendimento. |

---

## Fluxo Principal

1. O **Paciente** acessa o sistema e entra na sala de atendimento virtual no horário agendado.  
2. O **Médico** acessa o sistema e inicia a consulta de telemedicina.  
3. O sistema estabelece a conexão de **videoconferência segura** entre médico e paciente.  
4. O **Médico** analisa os sintomas relatados pelo paciente.  
5. O **Médico** pode solicitar informações adicionais ou exames.  
6. O **Enfermeiro**, se presente, pode registrar informações clínicas complementares.  
7. O **Médico** registra o diagnóstico no sistema.  
8. O **Médico** pode emitir uma **receita digital** ou recomendações médicas.  
9. O sistema salva automaticamente o atendimento no **prontuário eletrônico do paciente**.  
10. O atendimento é encerrado.

---

## Fluxos de Exceção

### E1 – Falha de Conexão

1. Durante a consulta ocorre perda de conexão com a internet.  
2. O sistema tenta reconectar automaticamente.  
3. Caso a reconexão falhe, o sistema informa aos usuários e permite reagendamento da consulta.

---

### E2 – Paciente Ausente

1. O médico inicia a consulta.  
2. O paciente não entra na sala virtual dentro do tempo limite.  
3. O sistema registra a ausência do paciente.  
4. A consulta é marcada como **não realizada**.

---

### E3 – Falha na Autenticação

1. O usuário tenta acessar o atendimento sem autenticação válida.  
2. O sistema bloqueia o acesso.  
3. O sistema solicita login novamente.

---

## Pós-condições

- O atendimento é registrado no **prontuário eletrônico do paciente**.  
- O diagnóstico fica disponível para consulta posterior.  
- Caso exista receita médica, ela é armazenada digitalmente no sistema.  
- O histórico da consulta fica registrado para auditoria.

---

# 3. Regras de Negócio (RN)

### RN01 – Validade da Receita Digital
Receitas médicas emitidas pelo sistema possuem validade de **30 dias**, salvo medicamentos controlados que seguem regulamentação específica.

---

### RN02 – Tempo Máximo de Atraso
O paciente pode entrar na consulta com até **15 minutos de atraso**. Após esse período, o atendimento poderá ser cancelado automaticamente.

---

### RN03 – Segurança e Criptografia
Todos os dados de comunicação entre médico e paciente devem utilizar **criptografia ponta a ponta (E2EE)** para garantir confidencialidade.

---

### RN04 – Acesso ao Prontuário
Somente **profissionais de saúde autorizados** e o próprio paciente podem acessar os dados do prontuário eletrônico.

---

### RN05 – Registro Obrigatório de Atendimento
Todo atendimento realizado deve gerar automaticamente um **registro no prontuário eletrônico**, incluindo:
- data
- horário
- médico responsável
- diagnóstico
- observações clínicas

---

# 4. Observações Técnicas

O sistema deve seguir princípios de segurança e privacidade de dados, podendo atender regulamentações como:

- LGPD (Lei Geral de Proteção de Dados)
- Normas de segurança da informação em saúde
- Boas práticas de prontuário eletrônico

---

