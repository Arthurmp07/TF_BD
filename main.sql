1) --  Fazer o DER (DIAGRAMA DE ENTIDADE RELACIONAL)(DUDA)
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

4) -- Consultas requeridas (4.1 a 4.10) — apenas os comandos SQL + explicação curta (Zelli e Eduardo)
  
/* 
4.1. Listar o nome dos professores que tenham idade menor do que 25 anos e que ministraram 
disciplinas em 20252; 
*/ 
SELECT Professor.Nome  
    FROM Professor INNER JOIN Turma ON Professor.NumeroProf = Turma.NumeroProf 
    WHERE Professor.Idade < 25 
    AND Turma.Semestre = 20252 ;

/* 
4.2. Listar o nome dos professores, em ordem alfabética, que ministraram a disciplina de código 10001 
(para esta questão escolha algum código de disciplina cadastrado no seu banco de dados); 
*/ 
SELECT Professor.Nome  
    FROM Professor INNER JOIN Turma ON Professor.NumeroProf = Turma.NumeroProf 
    WHERE Turma.CodigoDisc = 10001 
    ORDER BY Professor.Nome; 

/* 
4.3. Qual a quantidade de disciplinas, com carga horária maior do que 60 horas, que cada professor 
com idade maior do que 65 anos já ministrou. A saída para esta questão deve ser o nome do 
professor e a quantidade de disciplinas ministradas. 
*/ 
SELECT Professor.Nome, COUNT(*) AS Qnt_Disciplinas 
    FROM Professor INNER JOIN Turma ON Professor.NumeroProf = Turma.NumeroProf 
                   INNER JOIN Disciplina ON Turma.CodigoDisc = Disciplina.CodigoDisc 
    WHERE Disciplina.CargaHoraria > 60 
    AND Professor.Idade > 65 
    GROUP BY Professor.Nome; 

/* 
4.4. Liste o número de matrícula e nome dos alunos, juntamente com o nome das disciplinas cursadas 
por ele e a nota que obteve em cada disciplina, mas somente para disciplinas em que o aluno foi 
aprovado com nota maior ou igual a 7. 
*/ 
SELECT Aluno.MatriculaAluno AS Matrícula, Aluno.Nome, Disciplina.Nome AS Disciplina, Historico.Nota 
    FROM Aluno INNER JOIN Historico ON Aluno.MatriculaAluno = Historico.MatriculaAluno 
               INNER JOIN Disciplina ON Historico.CodigoDisc = Disciplina.CodigoDisc 
    WHERE Historico.Nota >= 7; 

/* 
4.5. Liste o número de matrícula dos alunos e a média geral de suas notas, ou seja, a média deverá 
considerar todas as notas, mesmo aquelas de disciplinas em que ele foi reprovado, ou seja, onde 
teve nota inferior a 7. 
*/ 
SELECT Aluno.MatriculaAluno AS Matrícula, AVG(Historico.Nota) AS Média_Notas 
    FROM Aluno INNER JOIN Historico ON Aluno.MatriculaAluno = Historico.MatriculaAluno 
    GROUP BY Aluno.MatriculaAluno; 

/* 
4.6. Liste todas as disciplinas cadastradas no banco de dados e a quantidade de alunos matriculados 
nessas disciplinas em 20252. Para esta questão, garanta que algumas disciplinas estejam 
cadastradas no banco de dados, mas sem alunos matriculados em 20252. 
*/ 
SELECT Disciplina.CodigoDisc, Disciplina.Nome AS Nome_Disc, COUNT(*) AS Alunos_20252 
    FROM Disciplina INNER JOIN Historico ON Disciplina.CodigoDisc = Historico.CodigoDisc 
                    INNER JOIN Aluno ON Aluno.MatriculaAluno = Historico.MatriculaAluno 
    WHERE Aluno.Status = 'matriculado' 
    AND Historico.Semestre = 20252 
    GROUP BY Disciplina.CodigoDisc, Disciplina.Nome; 

/* 
4.7. Liste o nome das disciplinas que não tiveram alunos matriculados em 20252. 
*/ 
SELECT Disciplina.Nome AS Nome_Disc FROM Disciplina  
    WHERE Disciplina.CodigoDisc NOT IN (SELECT Historico.CodigoDisc FROM Historico WHERE Historico.Semestre = 20252) 
    GROUP BY Disciplina.CodigoDisc, Disciplina.Nome; 

/* 
4.8. Liste o nome dos professores que ministraram todas as disciplinas cadastradas neste banco de 
dados, não importando o semestre em que ministraram. 
*/ 
SELECT Professor.Nome 
    FROM Professor INNER JOIN Turma ON Professor.NumeroProf = Turma.NumeroProf 
    GROUP BY Professor.NumeroProf, Professor.Nome 
    HAVING COUNT(DISTINCT Turma.CodigoDisc) = (SELECT COUNT(DISTINCT Historico.CodigoDisc) FROM Historico); 

/* 
4.9. Liste o total de carga já cursada por cada aluno. Liste o nome do aluno e o total de carga horária 
cursada pelo aluno. 
*/ 
SELECT Aluno.Nome AS Matricula, SUM(Disciplina.CargaHoraria) AS carga_horária_total 
    FROM Aluno INNER JOIN Historico ON Aluno.MatriculaAluno = Historico.MatriculaAluno 
               INNER JOIN Disciplina ON Historico.CodigoDisc = Disciplina.CodigoDisc 
    GROUP BY Aluno.MatriculaAluno, Aluno.Nome; 

/* 
4.10. Liste os semestres em que houve mais de 5 alunos matriculados em cada disciplina que teve 
oferta naquele semestre. 
*/
SELECT DISTINCT semestre
FROM (
  SELECT t.semestre,
         t.codigoDisc,
         COUNT(DISTINCT h.matriculaAluno) AS qtd_alunos
  FROM TURMA t
  JOIN HISTORICO h ON t.codigoDisc = h.codigoDisc AND t.semestre = h.semestre
  GROUP BY t.semestre, t.codigoDisc
  HAVING COUNT(DISTINCT h.matriculaAluno) > 5
);




