USE HotelHease;

# 1. Hospedes e seus contatos
SELECT 
	p.PrimeiroNome, 
	p.UltimoNome, 
	pc.Telefone, 
	pc.Email 
FROM Pessoa p
	JOIN PessoaContato pc ON pc.FkPessoa = p.ID 
WHERE p.ID IN (SELECT FkPessoa FROM Hospede);

# 2. Reservas em andamento
SELECT 
	r.DataCheckIn, 
	r.DataCheckOut 
FROM Reserva r
WHERE Status = "Em andamento";

# 3. Quartos disponiveis por categoria em um hotel
SELECT 
	q.Categoria,
	count(*) 
FROM Quarto q
WHERE q.Status = "Disponível" 
	AND FkHotel = 1
	GROUP BY Categoria

# 4. Hospedes com reservas a partir de 7 dias atrás
SELECT 
	p.PrimeiroNome, 
	p.UltimoNome, 
	r.ValorPago 
FROM Pessoa p
	JOIN Reserva r ON r.FkHospede = p.ID 
WHERE r.DataCheckIn >= '2025-05-05';

# 5. Pessoas com mais de 3 reservas nos ultimos 12 meses
SELECT 
	PrimeiroNome, 
	UltimoNome 
FROM Pessoa 
	JOIN Reserva ON Pessoa.ID = Reserva.FkHospede 
WHERE Reserva.DataCheckIn >= '2024-05-05' 
GROUP BY Pessoa.ID HAVING count(Reserva.ID) > 3

# 6. Número de reservas por hotel desde o mês passado
SELECT 
	Hotel.ID,
	Hotel.Nome,
	count(Reserva.ID) 
FROM Hotel 
	JOIN Reserva ON Reserva.FkHotel = Hotel.ID 
WHERE Reserva.DataCheckIn >= '2025-04-05'
	GROUP BY Hotel.ID;

# 7. Hotéis com mais de 90% de ocupação
SELECT 
	Hotel.Nome 
FROM Hotel 
	JOIN Quarto ON Quarto.FkHotel = Hotel.ID 
GROUP BY Hotel.ID, Hotel.Capacidade 
HAVING (count(CASE WHEN Quarto.Status = "Ocupado" THEN 1 END) / Hotel.Capacidade) > 0.5;

# 8. Serviços adicionais contratados para reservas recentes
SELECT 
	* 
FROM ServicoAdicional s
	JOIN Contrata c ON c.FkServicoAdicional = s.ID 
WHERE c.FkReserva IN (SELECT r.ID FROM Reserva r WHERE DataCheckIn >= '2025-05-08');

# 9. Receita por hotel incluindo serviços adicionais (Ultimos 6 meses)
SELECT
    h.Nome,
    SUM(r.ValorPago) + IFNULL(SUM(s.Preco), 0) AS FaturamentoTotal
FROM Hotel h
	JOIN Reserva r ON r.FkHotel = h.ID
	LEFT JOIN Contrata c ON c.FkReserva = r.ID
	LEFT JOIN ServicoAdicional s ON s.ID = c.FkServicoAdicional
WHERE r.DataCheckIn >= '2024-11-12'
	GROUP BY h.ID, h.Nome;

# 10. Pessoas que nunca cancelaram reservas
SELECT 
	Pessoa.PrimeiroNome, 
	Pessoa.UltimoNome 
FROM Pessoa 
	JOIN Hospede ON Pessoa.ID = Hospede.FkPessoa 
WHERE Hospede.FkPessoa NOT IN (SELECT FkHospede FROM Reserva WHERE Status = "Cancelada");

# 11. Dados de reservas com hóspede e hotel
SELECT 
	p.PrimeiroNome, 
	p.UltimoNome, 
	h.Nome, 
	r.DataCheckIn, 
	r.DataCheckOut 
FROM Reserva r
	JOIN Hotel h ON h.ID = r.FkHotel 
	LEFT JOIN Pessoa p ON r.FkHospede = p.ID

# 12. Quantidade de serviços adicionais por hotel
SELECT 
	Hotel.Nome, 
	count(ServicoAdicional.ID) 
FROM Hotel 
	JOIN Reserva ON Reserva.FkHotel = Hotel.ID 
	JOIN Contrata ON Contrata.FkReserva = Reserva.ID 
	JOIN ServicoAdicional ON ServicoAdicional.ID = Contrata.FkServicoAdicional 
GROUP BY Hotel.ID





