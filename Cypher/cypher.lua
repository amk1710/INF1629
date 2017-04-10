
-- Trabalho da disciplina Princípios de Engenharia de Sofware(INF1629), com o professor Júlio
-- Autor: André Mazal Krauss, data: 04/04/2017

-- No programa a seguir, implementarei métodos simples de criptografia/decriptografia de strings. Os métodos serão aplicados sobre caracteres alfabéticos. Caracteres numéricos e de acentuação não são afetados.

-- métodos implementados:
  -- Ceaser Cipher(shift Cipher): caso básico de criptografia, a função shifta todas os caracteres alfabéticos em uma string de um número constante



-- function shift_char: shifta um caracter alfabético c de uma constante n
-- Parametros:  c é o carater a ser shiftado,
--              n um valor inteiro.
-- Retorno: caracter shiftado





function shift_char(c, n)

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


-- function Caesar: Aplica um código de César na string passada. Ou seja, shifta toda a string s de um inteiro constante n
-- Parametros:  s é a string a ser shiftada,
--              n um valor inteiro.
-- Retorno: string shiftada

function Caesar(s, n)
    local caesar = ""
    local len = string.len(s)
    for i = 1, len-1 do
      caesar = caesar..shift_char(string.sub(s,i,i),n)
    end
    caesar = caesar..shift_char(string.sub(s,len),n)
    return caesar
end

-- function PolyAlphabetic: (Des)Aplica um cifro polialfabético na string passada. Ou seja, shifta toda a string s de uma array de inteiros. Se o array é menos que a string, começa-se a repetir os numeros em ordem. Nesse caso, a mensagem poderá ser decriptografado analisando os padrões resultantes.
-- Parametros:  s é a string a ser (de)criptografada,
--              n um valor inteiro.

-- Retorno: string criptografada

function PolyAlphabetic(s, numbers)
	local poly = ""
	local size = table.getn(numbers)
	local len = string.len(s)
	for i = 1, len-1 do
		poly = poly..shift_char(string.sub(s,i,i), numbers[math.mod(i,size)+1])
	end
	poly = poly..shift_char(string.sub(s, len), numbers[math.mod(len,size)+1])
	return poly
end

-- function cryptFile: lê um arquivo txt e cria dois novos arquivos: um que contém o seu texto cryptografado usando o cifro polialfabético, e outro que contem os numeros aleatorios usados para tal
-- Repare que formatações, sinais de pontuação e caracteres diferentes de letras incluidas no ASCII(inclusive caracteres acentuados) não serão criptografados.
-- Além disso, o nome do txt tampouco será criptografado
-- Parametros: filename é o nome do arquivo a ser criptografado
-- Retorno: nome da criptografia.(usado para decriptografar)

function cryptFile(filename)
	local message  = ""
	for line in io.lines(filename) do
		message = message..line.."\n"
	end

	local key = {}
	math.randomseed( os.time() )
	math.random(); math.random(); math.random()

	for i = 1, string.len(message) do
		table.insert(key, math.random(0,25))
	end

	local crypted = PolyAlphabetic(message, key)

	local name = tostring(math.random(1,1000))

	local out  = io.output ("crypted"..name..".txt", w)
	io.write(crypted)

--~ 	local out2 = io.open("key"..name..".bin", "wb")
--~ 	local str = ""
--~ 	for i = 1, table.getn(key) do
--~  		str = str..string.char(key[i])
--~ 	end
--~ 	out2:write(str)
--~ 	out2:close()
--~
--~
--~
	local out2 = io.output("key"..name..".txt",w)
	for i = 1, table.getn(key) do
 		io.write(key[i]..",")
	end

	return name

end

--function cryptFile: decriptografa o arquivo de nome filename, onde filename é um string com um inteiro de 1 a 1000. Supõem a existencia dos arquivos keyXXXX.bin e cryptedXXXX.txt
function decryptFile(filename)
--~ 	local input = io.open("key"..filename..".bin", rb)
--~ 	local key = {}
--~ 	while true do
--~ 		local byte = input:read(1)
--~ 		if not byte then break end
--~ 		table.insert(key, byte)
--~ 	end
--~ 	input:close()

	-- lê arquivos com as chaves para string secret

	local secret = ""
	for line in io.lines("key"..filename..".txt") do
		secret = secret..line
	end

	--separa informação lida em table key de inteiros
	local key = {}
	for match in secret:gmatch("([%d%.%+%-]+),?") do
		key[#key + 1] = -tonumber(match)
	end

	local message  = ""
	for line in io.lines("crypted"..filename..".txt") do
		message = message..line.."\n"
	end

	print(message)
	for i = 1, table.getn(key) do
 		print(key[i])
	end


	local decrypted = PolyAlphabetic(message, key)

	print(decrypted)

	local out  = io.output ("decrypted"..filename..".txt", w)
	io.write(decrypted)





end

--cryptFile("alice.txt")

decryptFile(286)

--~ key4 = {-4,-8,-3,-21,0}
--~ message4 = "idvae"
--~ decrypted4 = PolyAlphabetic(message4, key4)
--~ print(decrypted4)

--~ print(Caesar("andre mazal krauss", 26))
--~ c = Caesar("andre mazal krauss", 17)
--~ print(c)
--~ print(Caesar(c, -17))

--~ keys = {17,22,11,2,7}
--~ deKeys = {-17,-22,-11,-2,-7}
--~ s = "Andre Mazal Krauss"
--~ print("poly:")
--~ d = PolyAlphabetic(s, keys)
--~ dc = PolyAlphabetic(d, deKeys)
--~ print(dc)


