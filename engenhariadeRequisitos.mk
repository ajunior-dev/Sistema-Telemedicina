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

As regras de negócio definem restrições e políticas que controlam o funcionamento do sistema de telemedicina.

---

## RN01 – Validade da Receita Digital

Toda receita médica emitida pelo sistema deve possuir uma validade máxima de **30 dias** a partir da data de emissão.

Caso o medicamento seja classificado como **controlado**, a validade deverá seguir as normas da legislação sanitária vigente.

---

## RN02 – Tempo Máximo de Atraso para Consulta

O paciente pode acessar a sala de teleconsulta com um atraso máximo de **15 minutos** após o horário agendado.

Após esse período:

- a consulta poderá ser marcada como **não realizada**
- o médico poderá **encerrar a sessão**
- o paciente deverá **realizar um novo agendamento**

---

## RN03 – Registro Obrigatório de Atendimento

Todo atendimento realizado deve ser automaticamente registrado no **prontuário eletrônico do paciente**, contendo:

- data do atendimento
- profissional responsável
- sintomas relatados
- diagnóstico
- prescrições médicas (quando aplicável)

Esse registro não pode ser removido, apenas **atualizado por profissionais autorizados**.

---

## RN04 – Controle de Acesso ao Prontuário

O acesso ao prontuário do paciente deve obedecer às seguintes regras:

- Pacientes podem visualizar **apenas seus próprios dados**
- Médicos podem acessar prontuários de pacientes **sob sua responsabilidade**
- Enfermeiros podem visualizar informações clínicas **necessárias para assistência**
- Todos os acessos devem ser **registrados para auditoria**

---

## RN05 – Segurança da Comunicação

Toda comunicação realizada durante a consulta online deve utilizar **criptografia segura**, garantindo:

- confidencialidade
- integridade das informações
- proteção contra acesso não autorizado

A comunicação deve ocorrer por meio de **conexões seguras (HTTPS e criptografia de mídia)**.

---

## RN06 – Autenticação Obrigatória

Todos os usuários do sistema (pacientes, médicos e enfermeiros) devem realizar **autenticação antes de acessar o sistema**, utilizando:

- e-mail e senha
ou
- sistema de autenticação seguro (ex: OAuth ou autenticação institucional)

---

## RN07 – Agendamento de Consultas

Consultas de telemedicina devem ser previamente agendadas pelo paciente com base na **disponibilidade da agenda do médico**.

O sistema deve impedir:

- agendamentos em horários já ocupados
- sobreposição de consultas

---

## RN08 – Registro de Falhas de Atendimento

Caso ocorra falha de conexão durante a consulta:

- o sistema deve tentar **reconexão automática**
- caso a reconexão falhe, o atendimento deve ser marcado como **interrompido**
- deve ser disponibilizada opção de **reagendamento**

---

## RN09 – Histórico de Atendimentos

O sistema deve manter o histórico completo de consultas do paciente, incluindo:

- consultas realizadas
- consultas canceladas
- consultas não realizadas

Essas informações devem permanecer disponíveis para **consulta futura no prontuário**.

---

## RN10 – Auditoria de Ações

Todas as ações relevantes realizadas no sistema devem ser registradas em um **log de auditoria**, incluindo:

- acesso a prontuários
- emissão de receitas
- alterações em dados médicos
- realização de atendimentos

---

# 4. Observações Técnicas

O sistema deve seguir princípios de segurança e privacidade de dados, podendo atender regulamentações como:

- LGPD (Lei Geral de Proteção de Dados)
- Normas de segurança da informação em saúde
- Boas práticas de prontuário eletrônico

---

