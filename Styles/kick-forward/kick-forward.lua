--kick-forward style:
	--estilo baseado em funcinua��o. Cada fun��o tem como ultimo argumento func(fun��o de funcinuation).
	--Esse argumento � uma outra fun��o que ser� chamada ao t�rmino desta tendo o seu antigo retorno como parametro


--global constansts

--numero de palavras impressas
N = 25

-- The functions

--function read_file: l� arquivo.txt inteiro numa string
--Parametros: filename - nome do arquivo a ser lido
--PRE: filename � o nome de um arquivo.txt existente no diret�rio
--POS: string retornada � o texto que est� no arquivo

function read_file(filename, func)
	local str = ""
	for line in io.lines(filename) do
		str = str..line.."\n"
	end
	func(str, scan)
end

--retorna uma string com todos os caracteres n�o-alfanum�ricos substitu�dos por espa�os em branco

function filter_chars_and_normalize(str_data, func)

    local str = string.gsub(str_data, "[^%w]", " ")
	func(str, remove_stop_words)
end



--Takes a string and scans for words, obtem lista de lowercased words.
function scan(str_data, func)

	local str_vec = {}
	local i = 0;
	for s in string.gmatch(str_data, "%S+") do
		str_vec[i] = string.lower(s);
		i = i +1;
	end

	func(str_vec, frequencies)

end


--Recebe uma lista de palavras e uma lista de stop-words, obtem uma copia com todas as stop-words removidas

function remove_stop_words(word_list, func)

	--recupera stop-list de stop_words.txt
	local str = ""
	for line in io.lines("../stop_words.txt") do
		str = str..line.."\n"
	end

	str = string.gsub(str, "[^%w]", " ")

	local stop_list = {}
	local i = 0;
	for s in string.gmatch(str, "%S+") do
		stop_list[i] = string.lower(s);
		i = i +1;
	end


	--adiciona todas as letras minusculas nas stop-words
	for ascii = 97, 122 do
		table.insert(stop_list, string.char(ascii))
	end

	for i = #word_list,1,-1 do
		for j, stop_word in ipairs(stop_list) do
			if(word_list[i] == stop_word) then
				table.remove(word_list, i)
			end

		end

	end

	func(word_list, dictionary_sort)

end

--recebe uma lista de palavras e obtem um dicion�rio associando as palavras com suas frequencias de ocorr�ncia

function frequencies(word_list, func)

	--table de palavras com frequencias
    local word_freqs = {}
    for i, word in pairs(word_list) do
		if(word_freqs[word] == nil) then
			--cria entrada para nova palavra
			word_freqs[word] = {["word"] = word, ["frequency"] = 1}
		else
			--entrada j� existe. incrementa frequencia
			word_freqs[word].frequency = word_freqs[word].frequency + 1
		end
	end

    func(word_freqs, print_all)

end


--recebe um dicionario(table de table) de palavras e suas frequencias e obtem um array de tables onde as entradas est�o ordenadas por frequencia.
function dictionary_sort(dictionary, func)

    local sorted_array = {}
	for index in pairs(dictionary) do
		table.insert(sorted_array, dictionary[index])
	end

	table.sort(sorted_array, function(a,b)  return a.frequency > b.frequency end)

	func(sorted_array, function() end)

end

--recebe um array ordenado de pares palavra-frequencia e imprime n posi��es do mesmo
function print_all(word_freqs, func)

	local n = N

	if n > #word_freqs then n = #word_freqs end

	local count = 1;

	for index in ipairs(word_freqs) do
		if count > n then break else count = count + 1 end
		print(word_freqs[index].word, word_freqs[index].frequency)
	end

	func()

end

--come�o da execu��o encadeada
read_file("../pride-and-prejudice.txt", filter_chars_and_normalize)
