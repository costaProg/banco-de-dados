-- 1. Hospedes e seus contatos
SELECT 
    Pessoa.PrimeiroNome, 
    Pessoa.UltimoNome, 
    PessoaContato.Telefone, 
    PessoaContato.Email 
FROM Pessoa 
JOIN PessoaContato ON PessoaContato.FkPessoa = Pessoa.ID 
WHERE Pessoa.ID IN (
    SELECT FkPessoa FROM Hospede
);

-- 2. Reservas em andamento
SELECT 
    DataCheckIn, 
    DataCheckOut 
FROM Reserva 
WHERE Status = "Em andamento";

-- 3. Quartos disponíveis por categoria em um hotel
SELECT 
    Categoria, 
    COUNT(*) 
FROM Quarto 
WHERE Status = "Disponível" 
  AND FkHotel = -ID do hotel- 
GROUP BY Categoria;

-- 4. Hospedes com reservas a partir de 7 dias atrás
SELECT 
    Pessoa.PrimeiroNome, 
    Pessoa.UltimoNome, 
    Reserva.ValorPago 
FROM Pessoa 
JOIN Reserva ON Reserva.FkHospede = Pessoa.ID 
WHERE Reserva.DataCheckIn >= "Data de hoje com 7 dias a menos";

-- 5. Pessoas com mais de 3 reservas desde o mesmo dia do ano passado
SELECT 
    PrimeiroNome, 
    UltimoNome 
FROM Pessoa 
JOIN Reserva ON Pessoa.ID = Reserva.ID 
WHERE Reserva.DataCheckIn >= "Data de hoje no ano passado" 
GROUP BY Pessoa.ID 
HAVING COUNT(Reserva.ID) > 3;

-- 6. Número de reservas por hotel desde o mês passado
SELECT 
    Hotel.Nome, 
    COUNT(Reserva.ID) 
FROM Hotel 
JOIN Reserva ON Reserva.FkHotel = Hotel.ID 
WHERE Reserva.DataCheckIn >= "Data de hoje no mês passado" 
GROUP BY Hotel.ID;

-- 7. Hotéis com mais de 90% de ocupação
SELECT 
    Hotel.Nome 
FROM Hotel 
JOIN Quarto ON Quarto.FkHotel = Hotel.ID 
GROUP BY Hotel.ID, Hotel.Capacidade 
HAVING (
    COUNT(CASE WHEN Quarto.Status = "Ocupado" THEN 1 END) / Hotel.Capacidade
) > 0.9;

-- 8. Serviços adicionais contratados para reservas recentes
SELECT 
    ServicoAdicional.* 
FROM ServicoAdicional 
JOIN Contrata ON Contrata.FkServicoAdicional = ServicoAdicional.ID 
WHERE Contrata.FkReserva IN (
    SELECT Reserva.ID 
    FROM Reserva 
    WHERE DataCheckIn >= "2025-05-09"
);

-- 9. Receita por hotel incluindo serviços adicionais (últimos 6 meses)
SELECT 
    Hotel.Nome, 
    (SUM(Reserva.ValorPago) + SUM(ServicoAdicional.Preco)) 
FROM Hotel 
JOIN Reserva ON Reserva.FkHotel = Hotel.ID 
LEFT JOIN Contrata ON Contrata.FkReserva = Reserva.ID 
LEFT JOIN ServicoAdicional ON ServicoAdicional.ID = Contrata.FkServicoAdicional 
WHERE Reserva.DataCheckIn >= "Data dos últimos 6 meses" 
GROUP BY Hotel.ID;

-- 10. Pessoas que nunca cancelaram reservas
SELECT 
    Pessoa.PrimeiroNome, 
    Pessoa.UltimoNome 
FROM Pessoa 
JOIN Hospede ON Pessoa.ID = Hospede.FkPessoa 
WHERE Hospede.FkPessoa NOT IN (
    SELECT FkHospede 
    FROM Reserva 
    WHERE Status = "Cancelada"
);

-- 11. Dados de reservas com hóspede e hotel
SELECT 
    Pessoa.PrimeiroNome, 
    Pessoa.UltimoNome, 
    Hotel.Nome, 
    Reserva.DataCheckIn, 
    Reserva.DataCheckOut 
FROM Reserva 
JOIN Hotel ON Hotel.ID = Reserva.FkHotel 
LEFT JOIN Pessoa ON Reserva.FkHospede = Pessoa.ID;

-- 12. Quantidade de serviços adicionais por hotel
SELECT 
    Hotel.Nome, 
    COUNT(ServicoAdicional.ID) 
FROM Hotel 
JOIN Reserva ON Reserva.FkHotel = Hotel.ID 
LEFT JOIN Contrata ON Contrata.FkReserva = Reserva.ID 
LEFT JOIN ServicoAdicional ON ServicoAdicional.ID = Contrata.FkServicoAdicional 
GROUP BY Hotel.ID;