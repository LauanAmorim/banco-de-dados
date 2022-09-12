drop database dbEmpresa;
create database dbEmpresa;
use dbEmpresa;

create table tbFuncionario (
	FuncId int auto_increment primary key,
    FuncNome varchar(200) not null,
    FuncEmail varchar(200) not null
);

insert into tbFuncionario (FuncNome, FuncEmail) 
										values ("Maria", "maria@teste.com"),
                                        ("Antonio Pedro", "ant@escola.com"),
                                        ("Monica Cascão", "moc@escola.com");

select * from tbFuncionario;

create table tbFuncHistorico like tbFuncionario;

select * from tbFuncHistorico;
describe tbFuncHistorico;

alter table tbFuncHistorico modify FuncId int not null;


alter table tbFuncHistorico drop primary key;

alter table tbFuncHistorico add Atualizacao datetime;
alter table tbFuncHistorico add Situacao varchar(20);
alter table tbFuncHistorico add constraint pkIdFuncHistorico primary key(FuncId, Atualizacao, Situacao);
describe tbFuncHistorico;

delimiter //
create trigger trgFuncHistoricoInsert after insert on tbFuncionario
	for each row
begin
	insert into tbFuncHistorico
		set FuncId = new.FuncId,
			FuncNome = new.FuncNome,
            FuncEmail = new.FuncEmail,
            Atualizacao = current_timestamp(),
            Situacao = "Novo";
end;
//

insert into tbFuncionario (FuncNome, FuncEmail)
							values ("Will Jr", "willj@escola.com");




delimiter //
create trigger trgFuncHistoricoDelete before delete on tbFuncionario
	for each row
begin
	insert into tbFuncHistorico
		set FuncId = old.FuncId,
			FuncNome = old.FuncNome,
            FuncEmail = old.FuncEmail,
            Atualizacao = current_timestamp(),
            Situacao = "Excluído";
end;
//


delete from tbFuncionario where FuncId = 3;


delimiter //
create trigger trgFuncHistoricoAtualizar before update on tbFuncionario
	for each row
begin
	insert into tbFuncHistorico
		set FuncId = old.FuncId,
			FuncNome = old.FuncNome,
            FuncEmail = old.FuncEmail,
            Atualizacao = current_timestamp(),
            Situacao = "Velho";
	insert into tbFuncHistorico
		set FuncId = new.FuncId,
			FuncNome = new.FuncNome,
            FuncEmail = new.FuncEmail,
            Atualizacao = current_timestamp(),
            Situacao = "Novo";
end;
//

update tbFuncionario set funcNome = 'Maria', funcEmail = 'maria@teste.com' where FuncId = 1;

                            
select * from tbFuncionario;
select * from tbFuncHistorico;
