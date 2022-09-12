create database db_escola;
use db_escola;

create table tb_cliente(
	ClienteID int auto_increment primary key,
    CliNome varchar(150) not null,
    CliEmail varchar(150) not null
);

DELIMITER $$
create procedure spInsertProcedure(vCliNome varchar(150), vCliEmail varchar(150))
BEGIN
	if not exists (select CliEmail from tb_cliente where CliEmail = vCliEmail) then
		insert into tb_cliente (CliNome, CliEmail) values (vCliNome, vCliEmail);
	else 
		select "Email já registrado";
    end if;
END;
$$

call spInsertProcedure('Carlos', 'cc@escola.com');
call spInsertProcedure('Davizinho', 'zinho@escola.com');
call spInsertProcedure('Lindinha', 'lindi@escola.com');

select * from tb_cliente;
