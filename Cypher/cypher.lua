
-- Trabalho da disciplina Princ�pios de Engenharia de Sofware(INF1629), com o professor J�lio
-- Autor: Andr� Mazal Krauss, data de cria��o: 04/04/2017
-- Data da �ltima vers�o: 10/04/2017
-- Tamanho: 232 linhas

-- No programa a seguir, implementarei m�todos simples de criptografia/decriptografia de strings. Os m�todos ser�o aplicados sobre caracteres alfab�ticos. Caracteres num�ricos e de acentua��o n�o s�o afetados.


--function main: funcionamento do programa: pergunta ao usu�rio se quer criptografar ou decriptografar arquivo, e o seu nome
-- Parametros:  nenhum

-- Retorno: 0 se sem falhas
--PRE: nada
--POS: alguma a��o de (de)criptografia foi tomada, com cria��o de arquivos no diret�rio corrente.

function main()

	local answer
	repeat
	   io.write("Deseja criptografar ou decriptografar? (c/d)? ")
	   io.flush()
	   answer=io.read()
	until answer=="c" or answer=="d"

	--criptografar
	if (answer == "c") then
		io.write("Nome do arquivo?(sem .txt)")
		io.flush()
		answer=io.read()
		cryptFile(answer..".txt")
		print("Criptado\n")

	elseif(answer == "d") then
		io.write("Nome do arquivo?(sem .txt)")
		io.flush()
		answer=io.read()
		decryptFile(answer)
		print("Decriptado\n")
	end

end

--FUN��ES AUXILIARES: leitura e escrita de arquivos

--function readFile: l� arquivo.txt inteiro numa string e a retorna
--Parametros: filename - nome do arquivo a ser lido
--Retorno: string com texto do arquivo
--PRE: filename � o nome de um arquivo.txt existente no diret�rio
--POS: string retornada � o texto que est� no arquivo

function readFile(filename)
	local str = ""
	for line in io.lines(filename) do
		str = str..line.."\n"
	end
	return str
end

--funtion writeFile: escreve string passada no arquivo.txt com o nome passado. Se arquivo n�o existe, ele � criado
--Parametros: str - a string a ser escrita
--			  filename - nome do arquivo de escrita
--Retorno: 0 se sem problemas
--PRE: str � uma string. filename � uma string terminada em .txt
--POS: arquivo filename.txt foi criado ou sobrescrito para armazenar a string

function writeFile(str, filename)
	local out  = io.output (filename, w)
	io.write(str)
	io.close()
end


--FIM fun��es auxiliares: leitura e escrita de arquivos



-- FUN��ES AUXILIARES - manipula��o de strings

--function parse: separa informa��o lida de string em array de inteiros. O separador usado s�o v�rgulas. Os valores no array s�o o oposto dos na string para j� obtermos a chave de decriptografa��o
--Parametros: str - string a ser parseada
--Retorno: array de inteiros
--PRE: str � uma string com um ou mais valores separados por v�rgulas
--POS: � retornado um array com o oposto dos valores parseados de str
function parseOposite(str)
	local array = {}
	for match in str:gmatch("([%d%.%+%-]+),?") do
		array[#array + 1] = -tonumber(match)
	end
	return array
end

-- FIM. FUN��ES AUXILIARES - manipula��o de strings


-- FUN��ES AUXILIARES - n�meros pseudo-aleat�rios

--function randomArray: usa gerador de n�meros pseudo-aleat�rios para gerar um array de tamanho lenght com n�meros de 0 a 25
-- Parametros: lenght - tamanho do array desejado
-- Retorno:    array de tamanho lenght inicializado com numeros pseudo-aleat�rios entre 0 e 25
--PRE: lenght � um inteiro >0
--POS: retorno � array de tamanho lenght de n�meros entre 0 e 25 gerados

function randomArray(lenght)
	local key = {}
	math.randomseed( os.time() )
	math.random(); math.random(); math.random()

	for i = 1, lenght do
		table.insert(key, math.random(0,25))
	end
	return key
end

-- FIM. FUN��ES AUXILIARES - n�meros pseudo-aleat�rios

--FUN��ES DE CRIPTOGRAFIA:

-- function shift_char: shifta um caracter alfab�tico c de uma constante n. Se o carater n�o � alfab�tico do ASCII padr�o, � retornado igual
-- Parametros:  c � o carater a ser shiftado,
--              n um valor inteiro.
-- Retorno: caracter shiftado
-- PRE: c � um caractere. N � um inteiro entre -26 e 26
-- POS: � retornado o caractere shiftado em n


function shiftChar(c, n)

  if(math.abs(n) > 26) then return '_' end
  local numZ = string.byte("z")
  local numA = string.byte("a")
  c = c:lower()
  local tempc = string.byte(c)
  if(string.byte(c) > numZ or string.byte(c) < numA) then return c end
  tempc = tempc + n
  --tratamento de casos looparound no alfabeto. -1 e +1 servem para contar o "pulo" como um passo dado
  if (tempc > string.byte("z")) then
    tempc = string.byte("a") - string.byte("z") + tempc - 1
  elseif(tempc < string.byte("a")) then
    tempc = string.byte("z") -string.byte("a") + tempc + 1
  end

  return string.char(tempc)
end



-- function PolyAlphabetic: (Des)Aplica um cifro polialfab�tico na string passada. Ou seja, shifta toda a string s de uma array de inteiros. Se o array � menos que a string, come�a-se a repetir os numeros em ordem. Nesse caso, a mensagem poder� ser decriptografado analisando os padr�es resultantes.
-- obs: se numbers � um inteiro somente, obtemos o cifro de C�sar
-- Parametros:  s � a string a ser (de)criptografada,
--              n um valor inteiro.

-- Retorno: string criptografada
--PRE: s � uma string. numbers � um array de n�meros inteiros
--POS: string criptografada usando os n�meros em numbers � retornada

function PolyAlphabetic(s, numbers)
	local poly = ""
	local size = table.getn(numbers)
	local len = string.len(s)
	for i = 1, len-1 do
		poly = poly..shiftChar(string.sub(s,i,i), numbers[math.mod(i,size)+1])
	end
	poly = poly..shiftChar(string.sub(s, len), numbers[math.mod(len,size)+1])
	return poly
end

-- function cryptFile: l� um arquivo txt e cria dois novos arquivos: um que cont�m o seu texto cryptografado usando o cifro polialfab�tico, e outro que contem os numeros aleatorios usados para tal
-- Repare que formata��es, sinais de pontua��o e caracteres diferentes de letras incluidas no ASCII(inclusive caracteres acentuados) n�o ser�o criptografados.
-- Al�m disso, o nome do txt tampouco ser� criptografado
-- Parametros: filename � o nome do arquivo a ser criptografado
-- Retorno: nome da criptografia.(usado para decriptografar)
-- PRE: filename � o nome.txt de um arquivo texto existente no diret�rio
-- POS: novo arquivo .txt com nome cryptedXXXX.txt foi criado, e tamb�m outro arquivo keysXXXX.txt com a chave usada.
function cryptFile(filename)

	-- l� em string mensagem a ser criptografada
	local message  = readFile(filename)

	--obtem chaves de criptografia
	local key = randomArray(string.len(message))

	--criptografa a string usando o cifro polialfab�tico
	local crypted = PolyAlphabetic(message, key)

	-- obtem nome aleatorio para mensagem
	local name = tostring(math.random(1000,9999))

	--escreve mensagem em arquivo
	writeFile(crypted, "crypted"..name..".txt")

	--escreve chave em arquivo
	local sKeys = ""
	for i = 1, table.getn(key) do
 		sKeys = sKeys..key[i]..","
	end
	writeFile(sKeys, "key"..name..".txt")

	return name

end

--function decryptFile: decriptografa o arquivo de nome filename, onde filename � um string com um inteiro de 1000 a 9999. Sup�em a existencia dos arquivos keyXXXX.txt e cryptedXXXX.txt
-- Parametros: filename: string com XXXX usado para identificar arquivos
-- Retorno: 0 se ok
-- PRE: filename � uma string da forma XXXX onde X = 0..9
-- POS: novo arquivo decriptografado corretamente foi criado com o nome de decryptedXXXX.txt
function decryptFile(filename)

	-- l� arquivo keyXXXX.txt com as chaves separadas por v�rgulas para string secret
	local secret = readFile("key"..filename..".txt")

	--parseia string e obtem array com as chaves de descriptografia
	key = parseOposite(secret)

	--le mensagem criptografada de cryptedXXXX.txt
	local message = readFile("crypted"..filename..".txt")

	--usa chave e mensagem criptografada para obter mensagem original
	local decrypted = PolyAlphabetic(message, key)

	--escreve mensagem original em arquivo
	writeFile(decrypted, "decrypted"..filename..".txt")

	return 0
end

--FIM. FUN��ES DE CRIPTOGRAFIA:

--executa main
main()

--FIM DE cypher.lua. AMK, 2017
