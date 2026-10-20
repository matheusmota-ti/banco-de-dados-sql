-- Adiciona uma coluna BLOB para armazenar imagens dos suspeitos.
-- Execute somente se a coluna IMAGE ainda não existir.
ALTER TABLE suspects
ADD image BLOB;
