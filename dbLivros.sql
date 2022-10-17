drop database if exists dbdistribuidoraa;
create database if not exists dbdistribuidoraa;
use dbdistribuidoraa;
set foreign_key_checks=0;
set sql_safe_updates=0;

create table tbproduto(
	codigobarras char(14) primary key,
	nomeprod varchar(200) not null,
	precounitarioprod decimal(7,2) not null,
	qtd int not null
);

create table tbfornecedor(
	codfornecedor char(10) primary key,
	nomefornecedor varchar(200) not null,
	cnpj varchar(14) not null unique,
	telfornecedor char(11)
);

create table tbcliente(
	idcli int auto_increment primary key,
	nomecli varchar(200) not null,
	numend char(6) not null,
	cep char(8) not null,
	compend varchar(50) not null
);


create table tbbairro(
	idbairro int primary key auto_increment,
	bairro varchar(200) not null
);

create table tbcidade(
	idcidade int primary key auto_increment,
	cidade varchar(200) not null
);

create table tbestado(
	iduf int primary key auto_increment,
	uf varchar(200) not null
);

create table tbclijuridico(
	idcli int,
	cnpj char(18) not null primary key,
	ie bigint
);


create table tbclifisico(
	idcli int,
	cpf char(11) not null primary key,
	rg char(9) not null,
	nasc date,
	rgdigito char(1) not null
);


create table tbvenda(
	numerovenda int auto_increment not null primary key,
	datavenda date,
	totalvenda decimal(7,2) not null,
	idcli int,
	nf int
);


create table tbcompra(
	notafiscal int primary key,
	datacompra date not null,
	valortotal decimal(7,2),
	qtdtotal int not null,
	codigo char(10)
);

create table tbitemvenda(
	numerovenda int not null primary key auto_increment,
	codigobarras char(14),
	valoritem decimal(7,2) not null,
	qtd int not null
);

create table tbnotaFiscal(
	nf int primary key,
	totalnota decimal(7,2) not null,
	dataemissao date not null
);

create table tbendereco(
	logradouro varchar(200) not null,
	cep char(8) primary key,
	idbairro int not null, /* FK */
	idcidade int not null, /* FK */
	iduf int not null /* FK */
);

create table tbitemcompra(
	qtd int not null,
	valoritem decimal(7, 2) not null,
	notafiscal int,
	codigobarras char(14),
	primary key (notafiscal, codigobarras),
	foreign key (notafiscal)
		references tbcompra (notafiscal),
	foreign key (codigobarras)
		references tbproduto (codigobarras)
);   
    
alter table tbclijuridico add constraint fk_idcli__ foreign key (idcli) references tbcliente(idcli);
alter table tbclifisico add constraint fk_idcli_ foreign key (idcli) references tbcliente(idcli);
alter table tbcliente add constraint fk_cep foreign key (cep) references tbendereco(cep);

-- datavenda current(defaut())

alter table tbvenda add constraint fk_idcli foreign key (idcli) references tbcliente(idcli);
alter table tbvenda add constraint fk_nf foreign key (nf) references tbnotaFiscal(nf);

alter table tbitemvenda add constraint fk_numerovenda foreign key (numerovenda) references tbvenda(numerovenda);
alter table tbitemvenda add constraint fk_codigobarras_ foreign key (codigobarras) references tbproduto(codigobarras);

alter table tbcompra add constraint fk_codigo foreign key (codigo) references tbfornecedor(codfornecedor);

alter table tbendereco add constraint fk_idbairro foreign key (idbairro) references tbbairro(idbairro);
alter table tbendereco add constraint fk_idcidade foreign key (idcidade) references tbcidade(idcidade);
alter table tbendereco add constraint fk_iduf foreign key (iduf) references tbestado(iduf);

/* ------ EXERCÍCIO 1 ------ */

insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(1, "Revenda Chico Loco", 1245678937123, 11934567897);
insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(2, "José Faz Tudo S/A", 1345678937123, 11934567898);
insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(3, "Valdatas Entregas", 1445678937123, 11934567899);
insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(4, "Astrolgido das Estrelas", 1545678937123, 11934567800);
insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(5, "Amoroso e Doce", 1645678937123, 11934567801);
insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(6, "Marcelo dedal", 1745678937123, 11934567802);
insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(7, "Franciscano Cachaça", 1845678937123, 11934567803);
insert into tbfornecedor(codfornecedor, nomefornecedor, cnpj, telfornecedor) values(8, "Joãozinho Chupeta", 1945678937123, 11934567804);

-- select * from tbfornecedor;


/* ------ EXERCÍCIO 2 ------ */


delimiter $$
create procedure spInsertCidade(vIdCidade int, vCidade varchar(200))
begin
insert into tbcidade(idcidade, cidade) values (vIdCidade, vCidade);
end
$$

/* ------ EXERCÍCIO 3 ------ */

delimiter $$
create procedure spInsertUF(vIdUF int, UF varchar(200))
begin
insert into tbestado(iduf, uf) values (vIdUF, UF);
end
$$

/* ------ EXERCÍCIO 4 ------ */

delimiter $$
create procedure spInsertBairro(vIdBairro int, Bairro varchar(200))
begin
insert into tbbairro(idbairro, bairro) values (vIdBairro, Bairro);
end
$$

/* ------ EXERCÍCIO 5 ------ */

delimiter $$
create procedure spInsertProdutos(vCodigodeBarras char(14), vNomeProd varchar(200), vPrecounitarioprod decimal(7,2), vQtd int)
begin
insert into tbproduto(codigobarras, nomeprod, precounitarioprod, qtd) values (vCodigodeBarras, vNomeProd, vPrecounitarioprod, vQtd);
end
$$
 
/* ------ EXERCÍCIO 6 ------ */

delimiter $$
create procedure spInserEndereco(vCep decimal(8,0), vLogradouro varchar (200), vBairro varchar(200), Vcidade varchar (200), vEstado char(2))
begin

	if exists (select * from tbendereco where cep = vCep) then
	select 'Cep já cadastrado';


	elseif not exists (select * from tbendereco where cep = vCep) then
	if not exists (select idbairro from tbbairro where bairro = vBairro) then
	insert into tbbairro(bairro) values (vBairro);
	end if;

	if not exists(select iduf from tbestado where uf = vEstado) then
	insert into tbestado(uf) values (vEstado);
	end if;

	if not exists(select idcidade from tbcidade where cidade = vCidade) then
	insert into tbcidade(cidade) values (vCidade);
	end if;


	set @codbairro = (select idbairro from tbbairro where bairro = vBairro);
	set @codestado = (select iduf from tbestado where uf = vEstado);
	set @codcidade = (select idcidade from tbcidade where cidade = vCidade);

	end if;

	insert into tbendereco(cep, logradouro, idbairro, idcidade, iduf) values (vCep, vLogradouro, @codbairro, @codcidade, @codestado);
end $$

/* ------ EXERCÍCIO 7 ------ */

delimiter $$
create procedure spInsertRegistros(vNomecli varchar(200), vNumend char(6), vCompend varchar(50), vCep char(8), vCpf char(11), vRg char(9), vRgdigito char(1), vNasc date)
begin

if not exists (select * from tbcliente where cep = vCep) then
insert into tbcliente(nomecli, numend, compend, cep) values (vNomecli, vNumend, vCompend, vCep);
set @idCli = (select max(idcli) from tbcliente);
insert into tbclifisico(cpf, rg, rgdigito, nasc, idcli) values (vCpf, vRg, vRgdigito, vNasc, @idCli);

elseif exists (select * from tbcliente where cep = vCep) then
select 'Cliente já cadastrado';

end if;

end
$$

/* ------ EXERCÍCIO 8 ------ */

delimiter $$
create procedure spInsertClientePJ
(
vNomeCli varchar(200),vCNPJ char(18),vIE varchar(11),vCep decimal(8,0),vLogradouro varchar(200),vNumEnd char(6),vCompEnd varchar(50),vBairro varchar(200),vCidade varchar(200),vEstado varchar(200)
)
begin
    if not exists(select * from tbclijuridico where cnpj = vCNPJ) then
    if not exists(select * from tbendereco where cep = vCep) then
    call spInserEndereco(vCep,vLogradouro,vBairro,vcidade,vEstado);
    end if;
  
        insert into tbcliente(nomecli, numend, compend, cep) values (vNomeCli, vNumEnd, vCompEnd, vCep);
        set @idCli = (select max(idcli) from tbcliente);
        insert into tbclijuridico(cnpj, ie, idcli) values (vCNPJ, vIE, @IdCli);
        
        else
        select "Cliente já cadastrado";
        
    end if;
end
$$

/* ------ EXERCÍCIO 9 ------ */

-- drop procedure spInsertCompra;

delimiter $$ 
create procedure spInsertCompra(vNotaFiscal int, vFornecedor varchar(200), vCodigoBarras char(14), vQtd int)
begin
		if (select codfornecedor from tbfornecedor where nomefornecedor = vFornecedor) then
			set @ValorItem = (select precounitarioprod from tbproduto where codigobarras = vCodigoBarras);
            set @DataCompra = current_date();
			set @ValorTotal = (@valoritem * vQtd);
			set @IdFornecedor = (select codfornecedor from tbfornecedor where nomefornecedor = vFornecedor);
            if not exists (select nf from tbnotafiscal where nf = vNotaFiscal) then
					insert into tbnotafiscal(nf, totalnota, dataemissao) values (vNotaFiscal, @ValorTotal, @DataCompra);
					insert into tbcompra(notafiscal, datacompra, valortotal, qtdtotal, codigo) values (vNotaFiscal, @DataCompra, @ValorTotal, 0, @IdFornecedor);
					insert into tbitemcompra(qtd, valoritem, notafiscal, codigobarras) values (vQtd, @ValorItem, vNotaFiscal, vCodigoBarras);
                    elseif exists (select codigobarras from tbitemcompra where codigobarras = vCodigoBarras) then
					select "já existe";

			else
				insert into tbitemcompra(qtd, valoritem, notafiscal, codigobarras) values (vQtd, @ValorItem, vNotaFiscal, vCodigoBarras);
                
			end if;
		else
			select "O fornecedor não existe, portanto a compra não pode ser feita";
		end if;
        
end 
$$

delimiter $$
create trigger trg_UpdateCompra after insert on tbitemcompra
for each row
begin
	update tbcompra set qtdtotal = qtdtotal + new.qtd where notafiscal = new.notafiscal;
end
$$

/* select * from tbcompra;
select * from tbfornecedor;
select * from tbnotafiscal;
select * from tbitemcompra;*/

/* ------ EXERCÍCIO 10 ------ */

delimiter $$
create procedure spInsertVenda(vCliente varchar(200),vDataVenda date,vCodigoBarras char(14),vQtd int, vNotaFiscal int)
begin

	if not exists (select * from tbcliente where nomecli = vCliente) then
			select "cliente não existe";
	
		else if not exists (select * from tbitemcompra where codigobarras = vCodigoBarras) then
			select "produto não existe";
		
			else
				set @dataVenda = str_to_date(vDataVenda, '%Y-%m-%d');
				set @idCliente = (select idcli from tbcliente where nomecli = vCliente);
                set @valoritem = (select precounitarioprod from tbproduto where codigobarras = vCodigoBarras);
                set @totalvenda = (@valoritem * vQtd);
				insert into tbvenda(idcli,datavenda,nf, totalvenda) values (@idCliente,@dataVenda,vNotaFiscal, @totalvenda);
				insert into tbitemvenda(codigobarras,valoritem,qtd) values (vCodigoBarras,@valoritem,vQtd);
                
			end if; 
        
	end if;

end
$$

/* ------ EXERCÍCIO 11 ------ */

delimiter $$
create procedure spInsertNF(vNotaFiscal int, vCliente varchar(200) , vDataEmissao date)
begin
        if not exists (select * from tbcliente where nomecli = vCliente) then
			select "cliente não existe";
			else if not exists (select * from tbnotafiscal where nf = vNotaFiscal) then
				set @dataEmissao = str_to_date(vDataEmissao, '%Y-%m-%d');
                set @dataEmissao = CURRENT_DATE();
				set @idCliente = (select idcli from tbcliente where nomecli = vCliente);
				set @totalVenda = (select sum(totalvenda) from tbvenda where idcli = @idCliente);
				insert into tbnotafiscal(nf, totalnota, dataemissao) values (vNotaFiscal ,@totalVenda, @dataEmissao);
				else if exists(select * from tbnotafiscal where nf = vNotaFiscal) then
					select "Nota fiscal já existe";
				end if;
			end if;
		end if;
end
$$





/*
*
*
* DAQUI EM DIANTE COMEÇA A ACONTECER OS BAGULHO DOIDO !!!
*
*
*/







/* ------ EXERCÍCIO 12 ------ */

call spInsertProdutos(12345678910130, "Camisa de Poliéster", 35.61, 100);
call spInsertProdutos(12345678910131, "Blusa Frio Moletom", 200.00, 100);
call spInsertProdutos(12345678910132, "Vestido Decote Redondo", 144.00, 50);

/* ------ EXERCÍCIO 13 ------ */

delete from tbproduto where codigobarras = "12345678910116";
delete from tbproduto where codigobarras = "12345678910117";

-- select * from tbproduto;


/* ------ EXERCÍCIO 14 ------ */

delimiter $$
create procedure spAtualizaProduto(vCodBarras decimal(14,0), vNome varchar(200), vPrecoUnitarioProd decimal(6, 2))
begin
	if (select codigobarras from tbproduto where codigobarras = vCodBarras) then
		update tbproduto
    set nomeprod = vNome, precounitarioprod = vPrecoUnitarioProd where codigobarras = vCodBarras; 
	else
		select "Produto não existe";
	end if;
end $$

call spAtualizaProduto(12345678910111, 'Rei de Papel Mache', 64.50);
call spAtualizaProduto(12345678910112, 'Bolinha de Sabão', 120.00);
call spAtualizaProduto(12345678910113, 'Carro Bate Bate', 64.00);

-- select * from tbproduto;


/* ------ EXERCÍCIO 15 ------ */

delimiter $$
create procedure spInsertExibeProduto()
begin
	select * from tbproduto;
end
$$

call spInsertExibeProduto();

-- select * from tbproduto;

/* ------ EXERCÍCIO 16 ------ */

create table tbprodutohistorico like tbproduto;

-- select * from tbprodutohistorico;
-- describe tbprodutohistorico;

/* ------ EXERCÍCIO 17 ------ */

alter table tbprodutohistorico add ocorrencia varchar(20);
alter table tbprodutohistorico add atualizacao datetime;

-- select * from tbprodutohistorico;
-- describe tbprodutohistorico;

/* ------ EXERCÍCIO 18 ------ */

alter table tbprodutohistorico drop primary key;
alter table tbprodutohistorico add constraint pk_id_produtohistorico primary key (codigobarras, ocorrencia, atualizacao);

-- describe tbprodutohistorico;


/* ------ EXERCÍCIO 19 ------ */

delimiter $$
create trigger trg_ProdutoInsert after insert on tbproduto
for each row 
begin 
	insert into tbprodutohistorico
		set codigobarras = New.codigobarras,
			nomeprod = New.nomeprod,
			precounitarioprod = New.precounitarioprod,
			qtd = New.qtd,
			Ocorrencia = "Novo",
			Atualizacao = current_timestamp();
end
$$

call spInsertProdutos(12345678910119, 'Água mineral', 1.99, 500);


/*select * from tbprodutohistorico;
select * from tbproduto;
describe tbproduto;*/


/* ------ EXERCÍCIO 20 ------ */

delimiter $$
create trigger trg_ProdutoAtua after update on tbproduto
for each row 
begin 
	insert into tbprodutohistorico 
		set codigobarras = New.codigobarras,
			nomeprod = New.nomeprod,
			precounitarioprod = New.precounitarioprod,
			qtd = New.qtd,
			Ocorrencia = "Atualizado",
			Atualizacao = current_timestamp();
end
$$

call spAtualizaProduto(12345678910119, 'Água mineral', 2.99);

/*
select * from tbprodutohistorico;
select * from tbproduto;
describe tbproduto;
*/


/* ------ EXERCÍCIO 21 ------ */

call spInsertExibeProduto();

/* ------ EXERCÍCIO 22 ------ */

call spInsertVenda('Disney Chaplin', '2022-09-19', 12345678910111, 1, null);

/*
select * from tbproduto;
select * from tbitemvenda;
select * from tbcliente;
select * from tbvenda;
*/

/* ------ EXERCÍCIO 23 ------ */

select * from tbvenda order by datavenda desc limit 1;

/* ------ EXERCÍCIO 24 ------ */

select * from tbitemvenda order by numerovenda desc limit 1;

/* ------ EXERCÍCIO 25 ------ */

/*
select * from tbcliente;
drop procedure spConsultaCliente;
*/

delimiter $$
create procedure spConsultaCliente(vNomecli varchar(200))
begin	
    select * from tbcliente where nomecli = vNomecli;
end 
$$

call spConsultaCliente("Disney Chaplin");


/* ------ EXERCÍCIO 26 ------ */

/*
describe tbproduto;
describe tbitemvenda
*/

delimiter $$
create trigger trgAtualizaQtd after insert on tbitemvenda
for each row
begin
    update tbproduto set qtd = (qtd - new.qtd) where codigobarras = new.codigobarras;
end
$$

/*
select * from tbitemvenda;
select * from tbproduto;
*/


/* ------ EXERCÍCIO 27 ------ */

call spInsertVenda("Paganada","2022-09-26",12345678910114,15,359);

-- SHOW CREATE PROCEDURE spInsertVenda;

/* ------ EXERCÍCIO 28 ------ */

select * from tbitemvenda;
select * from tbproduto;

/* ------ EXERCÍCIO 29 ------ */

delimiter $$
create trigger trgAtualizaQtdCompra after insert on tbitemcompra
for each row
begin
    update tbproduto set qtd = (qtd + new.qtd) where codigobarras = new.codigobarras;
end
$$

call spInsertCompra(21550, 'Marcelo Dedal', 12345678910113, 200);

/*
select * from tbitemcompra;
select * from tbproduto;
*/


/* ------ EXERCÍCIO 30 ------ */

call spInsertCompra(10548, 'Amoroso e Doce', 12345678910111, 100);

/*
select * from tbfornecedor;
select * from tbcompra;
select * from tbitemcompra;
select * from tbproduto;
*/


/* ------ EXERCÍCIO 31 ------ */

call spInsertExibeProduto();


/* ------ EXERCÍCIO 32 ------ */

SELECT 
    *
FROM
    tbcliente
        INNER JOIN
    tbclifisico ON tbcliente.idcli = tbclifisico.idcli


/* ------ EXERCÍCIO 33 ------ */

SELECT 
    *
FROM
    tbcliente
        INNER JOIN
    tbclijuridico ON tbcliente.idcli = tbclijuridico.idcli


/* ------ EXERCÍCIO 34 ------ */

select tbcliente.idcli, tbcliente.nomecli, tbclijuridico.cnpj, tbclijuridico.ie, tbclijuridico.idcli  from tbcliente
inner join tbclijuridico on tbcliente.idcli = tbclijuridico.idcli;


/* ------ EXERCÍCIO 35 ------ */

select tbcliente.idcli as Código, tbcliente.nomecli as Nome, tbclifisico.cpf as CPF, tbclifisico.rg as RG, tbclifisico.nasc as "Data de Nascimento"
from tbcliente
inner join tbclifisico on tbcliente.idcli = tbclifisico.idcli;


/* ------ EXERCÍCIO 36 ------ */

select tbcliente.idcli, tbcliente.nomecli, tbcliente.numend, tbcliente.compend, tbcliente.cep, tbclijuridico.cnpj, tbclijuridico.ie, tbclijuridico.idcli, 
tbendereco.logradouro, tbendereco.idbairro, tbendereco.idcidade, tbendereco.iduf, tbendereco.cep
from tbcliente
inner join tbclijuridico on tbcliente.idcli = tbclijuridico.idcli
inner join tbendereco on tbendereco.cep = tbcliente.cep;


/* ------ EXERCÍCIO 37 ------ */

select * from tbcidade;
select * from tbbairro;
select * from tbestado;

select tbcliente.idcli, tbcliente.nomecli, tbcliente.numend, tbendereco.logradouro, tbcliente.compend, tbbairro.bairro, tbcidade.cidade, tbestado.uf
from tbcliente
inner join tbcliente;

/*
select tbcliente.idcli, tbcliente.nomecli, tbcliente.numend, tbcliente.compend, tbcliente.cep, tbclijuridico.cnpj, tbclijuridico.ie, tbclijuridico.idcli, 
tbendereco.logradouro, tbendereco.idbairro, tbendereco.idcidade, tbendereco.iduf, tbendereco.cep
from tbcliente
inner join tbclijuridico on tbcliente.idcli = tbclijuridico.idcli
inner join tbendereco on tbendereco.cep = tbcliente.cep;
inner join tbendereco on tbendereco.idbairro = tbbairro.idbairro;
*/
