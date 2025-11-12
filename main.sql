1) --  Fazer o DER (DIAGRAMA DE ENTIDADE RELACIONAL)
2)
DROP TABLE HISTORICO CASCADE CONSTRAINTS;
DROP TABLE TURMA CASCADE CONSTRAINTS;
DROP TABLE ALUNO CASCADE CONSTRAINTS;
DROP TABLE PROFESSOR CASCADE CONSTRAINTS;
DROP TABLE DISCIPLINA CASCADE CONSTRAINTS;


CREATE TABLE DISCIPLINA (
  codigoDisc    NUMBER,
  nome          VARCHAR2(100),
  departamento  VARCHAR2(50),
  cargaHoraria  NUMBER DEFAULT 60,
  CONSTRAINT pk_disciplina PRIMARY KEY (codigoDisc),
  CONSTRAINT ck_disciplina_carga CHECK (cargaHoraria IN (30,60,120))
);


CREATE TABLE PROFESSOR (
  numeroProf   NUMBER,
  nome         VARCHAR2(100),
  idade        NUMBER,
  salario      NUMBER,
  departamento VARCHAR2(50),
  CONSTRAINT pk_professor PRIMARY KEY (numeroProf),
  CONSTRAINT ck_professor_idade CHECK (idade BETWEEN 0 AND 70)
);


CREATE TABLE ALUNO (
  matriculaAluno NUMBER,
  nome           VARCHAR2(100),
  idade          NUMBER,
  endereco       VARCHAR2(200),
  status         VARCHAR2(30) DEFAULT 'matriculado',
  CONSTRAINT pk_aluno PRIMARY KEY (matriculaAluno),
  CONSTRAINT ck_aluno_status CHECK (status IN ('matriculado','não matriculado','evadido'))
);


CREATE TABLE TURMA (
  codigoDisc NUMBER,
  semestre   VARCHAR2(10),
  numeroProf NUMBER,
  CONSTRAINT pk_turma PRIMARY KEY (codigoDisc, semestre),
  CONSTRAINT fk_turma_disciplina FOREIGN KEY (codigoDisc)
    REFERENCES DISCIPLINA (codigoDisc),
  CONSTRAINT fk_turma_professor FOREIGN KEY (numeroProf)
    REFERENCES PROFESSOR (numeroProf)
);

CREATE TABLE HISTORICO (
  matriculaAluno NUMBER,
  codigoDisc     NUMBER,
  semestre       VARCHAR2(10),
  nota           NUMBER,
  CONSTRAINT pk_historico PRIMARY KEY (matriculaAluno, codigoDisc, semestre),
  CONSTRAINT fk_historico_aluno FOREIGN KEY (matriculaAluno)
    REFERENCES ALUNO (matriculaAluno),
  CONSTRAINT fk_historico_turma FOREIGN KEY (codigoDisc, semestre)
    REFERENCES TURMA (codigoDisc, semestre),
  CONSTRAINT ck_historico_nota CHECK (nota BETWEEN 0 AND 10)
);

3)
-- PROFESSOR (válidos)
INSERT INTO PROFESSOR (numeroProf, nome, idade, salario, departamento) VALUES (1, 'Ana Silva', 34, 7500, 'Comp. Sci');
INSERT INTO PROFESSOR (numeroProf, nome, idade, salario, departamento) VALUES (2, 'Bruno Costa', 24, 6800, 'Matematica');
INSERT INTO PROFESSOR (numeroProf, nome, idade, salario, departamento) VALUES (3, 'Clara Souza', 67, 9000, 'Física');
INSERT INTO PROFESSOR (numeroProf, nome, idade, salario, departamento) VALUES (4, 'Daniel Reis', 70, 12000, 'Comp. Sci');

-- DISCIPLINA (válidos)
INSERT INTO DISCIPLINA (codigoDisc, nome, departamento, cargaHoraria) VALUES (10001, 'Programação I', 'Comp. Sci', 60);
INSERT INTO DISCIPLINA (codigoDisc, nome, departamento) VALUES (10002, 'Matemática Discreta', 'Matematica'); 
-- O INSERT acima NÃO fornece cargaHoraria -> será aplicado o DEFAULT 60
INSERT INTO DISCIPLINA (codigoDisc, nome, departamento, cargaHoraria) VALUES (10003, 'Física Básica', 'Física', 30);
INSERT INTO DISCIPLINA (codigoDisc, nome, departamento, cargaHoraria) VALUES (10004, 'Algoritmos', 'Comp. Sci', 120);

-- ALUNO (válidos)
INSERT INTO ALUNO (matriculaAluno, nome, idade, endereco, status) VALUES (1001, 'Joao Pereira', 20, 'Rua A, 123', 'matriculado');
INSERT INTO ALUNO (matriculaAluno, nome, idade, endereco) VALUES (1002, 'Maria Lima', 22, 'Av. B, 45'); 
-- O INSERT acima NÃO fornece status -> será aplicado DEFAULT 'matriculado'
INSERT INTO ALUNO (matriculaAluno, nome, idade, endereco, status) VALUES (1003, 'Pedro Almeida', 23, 'Rua C, 9', 'não matriculado');

-- TURMA (válidos) - ligar disciplinas já criadas a professores e semestre
INSERT INTO TURMA (codigoDisc, semestre, numeroProf) VALUES (10001, '20252', 1);
INSERT INTO TURMA (codigoDisc, semestre, numeroProf) VALUES (10002, '20252', 2);
INSERT INTO TURMA (codigoDisc, semestre, numeroProf) VALUES (10003, '20251', 3);
INSERT INTO TURMA (codigoDisc, semestre, numeroProf) VALUES (10004, '20252', 4);

-- HISTORICO (válidos)
INSERT INTO HISTORICO (matriculaAluno, codigoDisc, semestre, nota) VALUES (1001, 10001, '20252', 8.5);
INSERT INTO HISTORICO (matriculaAluno, codigoDisc, semestre, nota) VALUES (1001, 10002, '20252', 6.0);
INSERT INTO HISTORICO (matriculaAluno, codigoDisc, semestre, nota) VALUES (1002, 10001, '20252', 7.5);
INSERT INTO HISTORICO (matriculaAluno, codigoDisc, semestre, nota) VALUES (1003, 10003, '20251', 9.0);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Erros que tem que inseri pra printa pro trabalho dps: 
-- os INSERTs que geram erro, capture as telas/prints conforme o enunciado — eles vão levantar mensagens de violação de constraint (FK / PK / CHECK).


-- ERRO - Integridade Referencial (inserir TURMA com codigoDisc que NÃO existe)
-- ERRO esperado: violação de FK (fk_turma_disciplina)
INSERT INTO TURMA (codigoDisc, semestre, numeroProf) VALUES (99999, '20252', 1);

-- ERRO - Integridade de Entidade (inserir ALUNO com PK nula ou duplicada)
-- ERRO esperado: violação de PK (pk_aluno) se matriculaAluno já existir; ou de NOT NULL se a PK fosse nula
-- (ex.: duplicata de 1001)
INSERT INTO ALUNO (matriculaAluno, nome, idade, endereco) VALUES (1001, 'Duplicado', 21, 'Rua X');

-- ERRO - Validação CHECK (idade ou carga fora do permitido)
-- ERRO esperado: violação de CHECK (ck_professor_idade)
INSERT INTO PROFESSOR (numeroProf, nome, idade, salario, departamento) VALUES (5, 'Idade Errada', 80, 5000, 'Teste');

------------------------------------------------------------------------------------------------------------------------------------------

4) -- Consultas requeridas (4.1 a 4.10) — apenas os comandos SQL + explicação curta






