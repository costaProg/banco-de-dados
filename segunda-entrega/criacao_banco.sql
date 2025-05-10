CREATE DATABASE HotelHease;

USE HotelHease;

CREATE TABLE Hotel(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	CNPJ VARCHAR(20) NOT NULL UNIQUE,
	Nome VARCHAR(50) NOT NULL,
	Capacidade INT(10) NOT NULL CHECK(Capacidade > 0)
);

CREATE TABLE HotelEndereco(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	FkHotel INT(11) NOT NULL,
	Rua VARCHAR(30) NOT NULL,
	Numero INT(8) NOT NULL CHECK(Numero > 0),
	Bairro VARCHAR(30) NOT NULL,
	Cidade VARCHAR(20) NOT NULL,
	Estado VARCHAR(20) NOT NULL,
	Cep CHAR(10),
	FOREIGN KEY(FkHotel) REFERENCES Hotel(ID)
);

CREATE TABLE HotelContato(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	FkHotel INT(11) NOT NULL,
	Email VARCHAR(30),
	Telefone VARCHAR(20),
	FOREIGN KEY(FkHotel) REFERENCES Hotel(ID)
);

CREATE TABLE Quarto(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	FkHotel INT(11) NOT NULL,
	Categoria VARCHAR(10) NOT NULL CHECK(Categoria IN ('Standard', 'Master', 'Deluxe')),
	Numero INT(6) NOT NULL,
	Status VARCHAR(10) NOT NULL CHECK(Status IN('Disponível', 'Ocupado', 'Manutenção')),
	FOREIGN KEY(FkHotel) REFERENCES Hotel(ID),
	UNIQUE(FkHotel, Numero)
);

CREATE TABLE Pessoa(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	CPF CHAR(14) UNIQUE,
	PrimeiroNome VARCHAR(30) NOT NULL,
	NomeMeio VARCHAR(30),
	UltimoNome VARCHAR(30)
);
	
CREATE TABLE PessoaEndereco(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	FkPessoa INT(11) NOT NULL,
	Rua VARCHAR(30) NOT NULL,
	Numero CHAR(8),
	Bairro VARCHAR(30) NOT NULL,
	Cidade VARCHAR(20) NOT NULL,
	Estado VARCHAR(20) NOT NULL,
	Cep CHAR(10),
	FOREIGN KEY(FkPessoa) REFERENCES Pessoa(ID)
);

CREATE TABLE PessoaContato(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	FkPessoa INT(11) NOT NULL,
	Email VARCHAR(30) UNIQUE,
	Telefone VARCHAR(20),
	FOREIGN KEY(FkPessoa) REFERENCES Pessoa(ID)
);

CREATE TABLE Hospede(
	FkPessoa INT(11) NOT NULL PRIMARY KEY,
	FOREIGN KEY(FkPessoa) REFERENCES Pessoa(ID)
);

CREATE TABLE Funcionario(
	FkPessoa INT(11) NOT NULL PRIMARY KEY,
	FkHotel INT(11) NOT NULL,
	Funcao VARCHAR(50) NOT NULL,
	FOREIGN KEY(FkPessoa) REFERENCES Pessoa(ID),
	FOREIGN KEY(FkHotel) REFERENCES Hotel(ID)
);

CREATE TABLE Reserva(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	DataCheckIn DATE NOT NULL,
	DataCheckOut DATE NOT NULL,
	ValorPago DOUBLE(8, 2) 	NOT NULL,
	Status VARCHAR(15) NOT NULL CHECK(Status IN('Em andamento', 'Concluída', 'Cancelada')),
	FkHotel INT(11) NOT NULL,
	FkQuarto INT(11) NOT NULL,
	FkHospede INT(11) NOT NULL,
	FOREIGN KEY(FkHotel) REFERENCES Hotel(ID),
	FOREIGN KEY(FkQuarto) REFERENCES Quarto(ID),
	FOREIGN KEY(FkHospede) REFERENCES Hospede(FkPessoa)
);

CREATE TABLE ServicoAdicional(
	ID INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	NomeServico VARCHAR(60) NOT NULL,
	Descricao TEXT,
	Preco DOUBLE(8, 2) NOT NULL
);

CREATE TABLE Contrata(
	FkReserva INT(11) NOT NULL,
	FkServicoAdicional INT(11) NOT NULL,
	PRIMARY KEY (FkReserva, FkServicoAdicional),
	FOREIGN KEY(FkReserva) REFERENCES Reserva(ID),
	FOREIGN KEY(FkServicoAdicional) REFERENCES ServicoAdicional(ID)
);


#Hotel
INSERT INTO Hotel (CNPJ, Nome, Capacidade) VALUES
('11.111.111/0001-11', 'Hotel Sol', 100),
('22.222.222/0002-22', 'Hotel Mar', 80);

#Endereços Hotel 
INSERT INTO HotelEndereco (FkHotel, Rua, Numero, Bairro, Cidade, Estado, Cep) VALUES
(1, 'Av. Brasil', 100, 'Centro', 'João Pessoa', 'PB', '58000-000'),
(2, 'Rua Atlântica', 200, 'Beira Mar', 'Recife', 'PE', '50000-000');

#Contatos Hotel
INSERT INTO HotelContato (FkHotel, Email, Telefone) VALUES
(1, 'contato@hotelsol.com', '(83) 99999-0001'),
(2, 'contato@hotelmar.com', '(81) 98888-0002');

#Quartos
INSERT INTO Quarto (FkHotel, Categoria, Numero, Status) VALUES
(1, 'Standard', 101, 'Disponível'),
(1, 'Standard', 102, 'Ocupado'),
(1, 'Deluxe', 201, 'Ocupado'),
(2, 'Standard', 101, 'Disponível'),
(2, 'Master', 202, 'Manutenção');

#Pessoas (Hóspedes + Funcionários)
INSERT INTO Pessoa (CPF, PrimeiroNome, NomeMeio, UltimoNome) VALUES
('000.000.000-01', 'Carlos', NULL, 'Silva'),
('000.000.000-02', 'Maria', 'Lima', 'Souza'),
('000.000.000-03', 'Ana', NULL, 'Ferreira'),
('000.000.000-04', 'João', 'Pedro', 'Pereira'),
('000.000.000-05', 'Fernanda', NULL, 'Oliveira'),
('000.000.000-06', 'Teste', NULL, 'Teste');

#Endereços pessoas
INSERT INTO PessoaEndereco (FkPessoa, Rua, Numero, Bairro, Cidade, Estado, Cep) VALUES
(1, 'Rua A', '10', 'Centro', 'JP', 'PB', '58000-001'),
(2, 'Rua B', '20', 'Centro', 'JP', 'PB', '58000-002'),
(3, 'Rua C', '30', 'Centro', 'JP', 'PB', '58000-003'),
(4, 'Rua D', '40', 'Centro', 'JP', 'PB', '58000-004'),
(5, 'Rua E', '50', 'Centro', 'JP', 'PB', '58000-005'),
(6, 'Rua F', '60', 'Centro', 'JP', 'PB', '58000-006');

#Contato
INSERT INTO PessoaContato (FkPessoa, Email, Telefone) VALUES
(1, 'carlos@email.com', '(83) 98888-0001'),
(2, 'maria@email.com', '(83) 98888-0002'),
(3, 'ana@email.com', '(83) 98888-0003'),
(4, 'joao@email.com', '(83) 98888-0004'),
(5, 'fernanda@email.com', '(83) 98888-0005'),
(6, 'teste@email.com', '(83) 98888-0006');

#Hospedes
INSERT INTO Hospede (FkPessoa) VALUES (1), (2), (3), (4);

#Funcionário
INSERT INTO Funcionario (FkPessoa, FkHotel, Funcao) VALUES
(5, 1, 'Recepcionista');

#Reservas (datas controladas para as queries)
INSERT INTO Reserva (DataCheckIn, DataCheckOut, ValorPago, Status, FkHotel, FkQuarto, FkHospede) VALUES
('2025-05-08', '2025-05-12', 800.00, 'Em andamento', 1, 2, 1),
('2025-05-01', '2025-05-03', 400.00, 'Concluída', 1, 3, 1),
('2025-05-02', '2025-05-04', 600.00, 'Cancelada', 1, 3, 2),
('2025-04-25', '2025-04-30', 700.00, 'Concluída', 2, 4, 2),
('2025-05-06', '2025-05-07', 200.00, 'Concluída', 2, 4, 3),
('2025-05-09', '2025-05-11', 500.00, 'Em andamento', 1, 3, 3),
('2025-03-15', '2025-03-20', 1000.00, 'Concluída', 1, 2, 1),
('2025-01-10', '2025-01-15', 450.00, 'Concluída', 2, 5, 4);

#Serviços
INSERT INTO ServicoAdicional (NomeServico, Descricao, Preco) VALUES
('Café da Manhã', 'Buffet completo', 30.00),
('Spa', 'Massagem relaxante', 100.00),
('Lavanderia', 'Serviço de lavagem', 50.00);

#Contratações (últimas 24h e diversas reservas)
INSERT INTO Contrata (FkReserva, FkServicoAdicional) VALUES
(1, 1),
(1, 2),
(6, 1),
(6, 3),
(2, 1);


