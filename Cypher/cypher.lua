
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
-- Retorno: caracter shiftado

function Caesar(s, n)
    local caesar = ""
    local len = string.len(s)
    for i = 1, len-1 do
      caesar = caesar..shift_char(string.sub(s,i,i),n)
    end
    caesar = caesar..shift_char(string.sub(s,len),n)
    return caesar
end


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



print(Caesar("andre mazal krauss", 26))
c = Caesar("andre mazal krauss", 17)
print(c)
print(Caesar(c, -17))

keys = {17,22,11,2,7}
deKeys = {-17,-22,-11,-2,-7}
s = "Andre Mazal Krauss"
print("poly:")
d = PolyAlphabetic(s, keys)
dc = PolyAlphabetic(d, deKeys)
print(dc)
