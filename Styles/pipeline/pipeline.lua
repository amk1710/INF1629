-- The functions

--function read_file: l� arquivo.txt inteiro numa string e a retorna
--Parametros: filename - nome do arquivo a ser lido
--Retorno: string com texto do arquivo
--PRE: filename � o nome de um arquivo.txt existente no diret�rio
--POS: string retornada � o texto que est� no arquivo

function read_file(filename)
	local str = ""
	for line in io.lines(filename) do
		str = str..line.."\n"
	end
	return str
end

--retorna uma string com todos os caracteres n�o-alfanum�ricos substitu�dos por espa�os em branco

function filter_chars_and_normalize(str_data)

    local str = string.gsub(str_data, "[^%w]", " ")
	return str
end



--Takes a string and scans for words, returning a list of lowercased words.
function scan(str_data)

	local str_vec = {}
	local i = 0;
	for s in string.gmatch(str_data, "%S+") do
		str_vec[i] = string.lower(s);
		i = i +1;
	end

	return str_vec

end

--Recebe uma lista de palavras e uma lista de stop-words retorna uma copia com todas as stop-words removidas

function remove_stop_words(word_list, stop_list)

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

	return word_list

end

--recebe uma lista de palavras e retorna um dicion�rio associando as palavras com suas frequencias de ocorr�ncia

function frequencies(word_list)

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

    return word_freqs

end


--recebe um dicionario(table de table) de palavras e suas frequencias e retorna um array de tables onde as entradas est�o ordenadas por frequencia.
function dictionary_sort(dictionary)

    local sorted_array = {}
	for index in pairs(dictionary) do
		table.insert(sorted_array, dictionary[index])
	end

	table.sort(sorted_array, function(a,b) return a.frequency > b.frequency end)

	return sorted_array

end

--recebe um array ordenado de pares palavra-frequencia imprime n posi��es do mesmo
function print_all(n, word_freqs)

	if n > #word_freqs then n = #word_freqs end

	local count = 1;

	for index in pairs(word_freqs) do
		if count > n then break else count = count + 1 end
		print(word_freqs[index].word, word_freqs[index].frequency)
	end

end


--The main function

print_all(25, dictionary_sort(frequencies(remove_stop_words(scan(filter_chars_and_normalize(read_file("../pride-and-prejudice.txt"))), scan(filter_chars_and_normalize(read_file("../stop_words.txt")))))))
