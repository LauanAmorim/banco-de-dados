create database dbdistribuidora;
use dbdistribuidora;

CREATE TABLE tbestado (
    UFid INT AUTO_INCREMENT PRIMARY KEY,
    UF CHAR(2) NOT NULL
);

CREATE TABLE tbcidade (
    CidadeId INT PRIMARY KEY AUTO_INCREMENT,
    cidade VARCHAR(200) NOT NULL
);

CREATE TABLE tbbairro (
    BairroId INT AUTO_INCREMENT PRIMARY KEY,
    bairro CHAR(200) NOT NULL
);

CREATE TABLE tbendereco (
    logradouro VARCHAR(200) NOT NULL,
    BairroId INT NOT NULL,
    CepCli INT PRIMARY KEY,
    CidadeId INT NOT NULL,
    UFid INT NOT NULL,
    FOREIGN KEY (CidadeId)
        REFERENCES tbcidade (CidadeId),
    FOREIGN KEY (BairroId)
        REFERENCES tbbairro (BairroId),
    FOREIGN KEY (UFid)
        REFERENCES tbestado (UFid)
);

CREATE TABLE tbcliente (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomeCli VARCHAR(200) NOT NULL,
    NumEnd INT NOT NULL,
    compEnd VARCHAR(50),
    CepCli INT NOT NULL,
    FOREIGN KEY (CepCli)
        REFERENCES tbendereco (CepCli)
);

CREATE TABLE tbclientePJ (
    cnpj BIGINT PRIMARY KEY,
    IE BIGINT UNIQUE,
    Id INT,
    FOREIGN KEY (Id)
        REFERENCES tbcliente (Id)
);

CREATE TABLE tbclientePF (
    cpf BIGINT NOT NULL UNIQUE PRIMARY KEY,
    dataNasc DATE NOT NULL,
    RG BIGINT NOT NULL,
    RG_Dig NUMERIC(1) NOT NULL,
    Id INT,
    FOREIGN KEY (Id)
        REFERENCES tbcliente (Id)
);

CREATE TABLE tbproduto (
    codigoBarras BIGINT NOT NULL PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Valor DECIMAL(7 , 2 ) NOT NULL,
    Qtd INT
);

CREATE TABLE tbNota_Fiscal (
    NF INT PRIMARY KEY,
    totalNota DECIMAL(7 , 2 ) NOT NULL,
    dataEmissao DATE NOT NULL
);

CREATE TABLE tbfornecedor (
    Codigo BIGINT PRIMARY KEY AUTO_INCREMENT,
    CNPJ BIGINT UNIQUE,
    Nome CHAR(200) NOT NULL,
    Telefone BIGINT
);

CREATE TABLE tbcompra (
    NotaFiscal INT PRIMARY KEY,
    dataCompra DATE NOT NULL,
    valorTotal DECIMAL(7 , 2 ) NOT NULL,
    qtdTotal INT NOT NULL,
    Codigo BIGINT,
    FOREIGN KEY (Codigo)
        REFERENCES tbfornecedor (Codigo)
);

CREATE TABLE tbItemCompra (
    PRIMARY KEY (NotaFiscal , CodigoBarras),
    NotaFiscal INT,
    CodigoBarras BIGINT,
    ValorItem DECIMAL(7 , 2 ) NOT NULL,
    Qtd INT NOT NULL,
    FOREIGN KEY (NotaFiscal)
        REFERENCES tbcompra (NotaFiscal),
    FOREIGN KEY (CodigoBarras)
        REFERENCES tbproduto (codigoBarras)
);

CREATE TABLE tbvenda (
    numeroVenda INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    dataVenda DATE,
    totalVenda DECIMAL(7 , 2 ),
    Id INT NOT NULL,
    NF INT,
    FOREIGN KEY (Id)
        REFERENCES tbcliente (Id),
    FOREIGN KEY (NF)
        REFERENCES tbNota_Fiscal (NF)
);
alter table tbvenda modify dataVenda date default(current_timestamp());

CREATE TABLE tbItemVenda (
    PRIMARY KEY (NumeroVenda , CodigoBarras),
    NumeroVenda INT,
    CodigoBarras BIGINT,
    ValorItem INT NOT NULL,
    Qtd INT NOT NULL,
    FOREIGN KEY (CodigoBarras)
        REFERENCES tbproduto (codigoBarras),
    FOREIGN KEY (NumeroVenda)
        REFERENCES tbvenda (numeroVenda)
);


insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1245678937123','Revenda Chico Loco','11934567897'); 

insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1345678937123','José Faz Tudo S/A','11934567898');

insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1445678937123','Vadalto Entregas','11934567899');

insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1545678937123','Astrtogildo das Estrela','11934567800');

insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1645678937123','Amoroso e Doce','11934567801');

insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1745678937123','Marcelo Dedal','11934567802');

insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1845678937123','Franciscano Cachaça','11934567803');

insert into tbfornecedor (CNPJ, Nome, Telefone) values ('1945678937123','Joãozinho Chupeta','11934567804');

#select * from tbfornecedor;

delimiter $$  
create procedure spInsertcidade (vCidade varchar(200))
begin
	INSERT INTO tbcidade (cidade) values (vCidade);
end $$

call spInsertcidade("Rio de Janeiro");
call spInsertcidade("São Carlos");
call spInsertcidade("Campinas");
call spInsertcidade("Franco da Rocha");
call spInsertcidade("Osasco");
call spInsertcidade("Pirituba");
call spInsertcidade("Lapa");
call spInsertcidade("Ponta Grossa");

DELIMITER $$
	Create procedure spInsertUF (vUF char(2))
BEGIN
	INSERT INTO tbestado (UF) values (vUF);
END $$

call spInsertUF("SP");
call spInsertUF("RJ");
call spInsertUF("RS");
