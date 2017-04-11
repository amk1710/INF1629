
-- Trabalho da disciplina Princípios de Engenharia de Sofware(INF1629), com o professor Júlio
-- Autor: André Mazal Krauss, data de criação: 04/04/2017
-- Data da última versão: 10/04/2017
-- Tamanho: 232 linhas

-- No programa a seguir, implementarei métodos simples de criptografia/decriptografia de strings. Os métodos serão aplicados sobre caracteres alfabéticos. Caracteres numéricos e de acentuação não são afetados.


--function main: funcionamento do programa: pergunta ao usuário se quer criptografar ou decriptografar arquivo, e o seu nome
-- Parametros:  nenhum

-- Retorno: 0 se sem falhas
--PRE: nada
--POS: alguma ação de (de)criptografia foi tomada, com criação de arquivos no diretório corrente.

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

--FUNÇÔES AUXILIARES: leitura e escrita de arquivos

--function readFile: lê arquivo.txt inteiro numa string e a retorna
--Parametros: filename - nome do arquivo a ser lido
--Retorno: string com texto do arquivo
--PRE: filename é o nome de um arquivo.txt existente no diretório
--POS: string retornada é o texto que está no arquivo

function readFile(filename)
	local str = ""
	for line in io.lines(filename) do
		str = str..line.."\n"
	end
	return str
end

--funtion writeFile: escreve string passada no arquivo.txt com o nome passado. Se arquivo não existe, ele é criado
--Parametros: str - a string a ser escrita
--			  filename - nome do arquivo de escrita
--Retorno: 0 se sem problemas
--PRE: str é uma string. filename é uma string terminada em .txt
--POS: arquivo filename.txt foi criado ou sobrescrito para armazenar a string

function writeFile(str, filename)
	local out  = io.output (filename, w)
	io.write(str)
	io.close()
end


--FIM funções auxiliares: leitura e escrita de arquivos



-- FUNçÕES AUXILIARES - manipulação de strings

--function parse: separa informação lida de string em array de inteiros. O separador usado são vírgulas. Os valores no array são o oposto dos na string para já obtermos a chave de decriptografação
--Parametros: str - string a ser parseada
--Retorno: array de inteiros
--PRE: str é uma string com um ou mais valores separados por vírgulas
--POS: é retornado um array com o oposto dos valores parseados de str
function parseOposite(str)
	local array = {}
	for match in str:gmatch("([%d%.%+%-]+),?") do
		array[#array + 1] = -tonumber(match)
	end
	return array
end

-- FIM. FUNçÕES AUXILIARES - manipulação de strings


-- FUNÇõES AUXILIARES - números pseudo-aleatórios

--function randomArray: usa gerador de números pseudo-aleatórios para gerar um array de tamanho lenght com números de 0 a 25
-- Parametros: lenght - tamanho do array desejado
-- Retorno:    array de tamanho lenght inicializado com numeros pseudo-aleatórios entre 0 e 25
--PRE: lenght é um inteiro >0
--POS: retorno é array de tamanho lenght de números entre 0 e 25 gerados

function randomArray(lenght)
	local key = {}
	math.randomseed( os.time() )
	math.random(); math.random(); math.random()

	for i = 1, lenght do
		table.insert(key, math.random(0,25))
	end
	return key
end

-- FIM. FUNÇõES AUXILIARES - números pseudo-aleatórios

--FUNÇÕES DE CRIPTOGRAFIA:

-- function shift_char: shifta um caracter alfabético c de uma constante n. Se o carater não é alfabético do ASCII padrão, é retornado igual
-- Parametros:  c é o carater a ser shiftado,
--              n um valor inteiro.
-- Retorno: caracter shiftado
-- PRE: c é um caractere. N é um inteiro entre -26 e 26
-- POS: é retornado o caractere shiftado em n


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



-- function PolyAlphabetic: (Des)Aplica um cifro polialfabético na string passada. Ou seja, shifta toda a string s de uma array de inteiros. Se o array é menos que a string, começa-se a repetir os numeros em ordem. Nesse caso, a mensagem poderá ser decriptografado analisando os padrões resultantes.
-- obs: se numbers é um inteiro somente, obtemos o cifro de César
-- Parametros:  s é a string a ser (de)criptografada,
--              n um valor inteiro.

-- Retorno: string criptografada
--PRE: s é uma string. numbers é um array de números inteiros
--POS: string criptografada usando os números em numbers é retornada

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

-- function cryptFile: lê um arquivo txt e cria dois novos arquivos: um que contém o seu texto cryptografado usando o cifro polialfabético, e outro que contem os numeros aleatorios usados para tal
-- Repare que formatações, sinais de pontuação e caracteres diferentes de letras incluidas no ASCII(inclusive caracteres acentuados) não serão criptografados.
-- Além disso, o nome do txt tampouco será criptografado
-- Parametros: filename é o nome do arquivo a ser criptografado
-- Retorno: nome da criptografia.(usado para decriptografar)
-- PRE: filename é o nome.txt de um arquivo texto existente no diretório
-- POS: novo arquivo .txt com nome cryptedXXXX.txt foi criado, e também outro arquivo keysXXXX.txt com a chave usada.
function cryptFile(filename)

	-- lê em string mensagem a ser criptografada
	local message  = readFile(filename)

	--obtem chaves de criptografia
	local key = randomArray(string.len(message))

	--criptografa a string usando o cifro polialfabético
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

--function decryptFile: decriptografa o arquivo de nome filename, onde filename é um string com um inteiro de 1000 a 9999. Supõem a existencia dos arquivos keyXXXX.txt e cryptedXXXX.txt
-- Parametros: filename: string com XXXX usado para identificar arquivos
-- Retorno: 0 se ok
-- PRE: filename é uma string da forma XXXX onde X = 0..9
-- POS: novo arquivo decriptografado corretamente foi criado com o nome de decryptedXXXX.txt
function decryptFile(filename)

	-- lê arquivo keyXXXX.txt com as chaves separadas por vírgulas para string secret
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

--FIM. FUNÇÕES DE CRIPTOGRAFIA:

--executa main
main()

--FIM DE cypher.lua. AMK, 2017
