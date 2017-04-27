-- The functions

--function read_file: lê arquivo.txt inteiro numa string e a retorna
--Parametros: filename - nome do arquivo a ser lido
--Retorno: string com texto do arquivo
--PRE: filename é o nome de um arquivo.txt existente no diretório
--POS: string retornada é o texto que está no arquivo

function read_file(filename)
	local str = ""
	for line in io.lines(filename) do
		str = str..line.."\n"
	end
	return str
end

--retorna uma string e retorna uma string com todos os caracteres não-alfanuméricos substituídos por espaços em branco

function filter_chars_and_normalize(str_data)


    str = string.gsub(str_data, "[^%w]", " ")
	return str
end



--Takes a string and scans for words, returning a list of words
function scan(str_data)

	local str_vec = {}
	local i = 0;
	for s in string.gmatch(str_data, "%S+") do
		str_vec[i] = s;
		print(s)
		i = i +1;
	end

end


--function read_file: lê stop_words.txt numa string e a retorna
--Parametros:
--Retorno: lista de stop_words
--PRE: filename é o nome de um arquivo.txt existente no diretório
--POS: string retornada é o texto que está no arquivo

function read_file()
	local str = ""
	for line in io.lines("stop_words.txt") do
		str = str..line.."\n"
	end
	return str
end

--Recebe uma lista de palavras e uma lista de stop-words retorna uma copia com todas as stop-words removidas

function remove_stop_words(word_list, stop_list)

    --adiciona todas as letras minusculas nas stop-words
	for ascii = 97, 122 do
		table.insert(stop_list, string.char(ascii))
	end

	--indexes for removal
	--rem = {}

    for i, word in ipairs(word_list) do
		for j, stop in ipairs(stop_list) do
			if(word == stop) then
				print(word, i)
				table.remove(word_list, i)
			end

		end

	end

	return word_list

end


list = {"abc", "cde", "fgt", "word", "renan", "vagner", "abc"}
stop = {"abc", "cde", "vagner"}

list2 = remove_stop_words(list, stop)

for i, word in ipairs(list2) do
	print(word)
end

--recebe uma lista de palavras e retorna um dicionário associando as palavras com suas frequencias de ocorrência

function frequencies(word_list)

	found = 0
    word_freqs = {}
    for i, word1 in ipairs(word_list) do
        for j, word2 in ipairs(word_freqs) do
			if (word1 == word2) then
				word_freqs[word1] = word_freqs[word1] + 1
				found = 1
				break;
			end

			if(not found) then
				word_freqs[word1] = 1
			end
			found = 0

		end
	end

    return word_freqs

end

--[[

--recebe um dicionario de palavras e suas frequencia e retorna uma lista de pares onde as entradas estão ordenadas por frequencia.
function sort(word_freq)

    Takes a dictionary of words and their frequencies
    and returns a list of pairs where the entries are
    sorted by frequency

    return sorted(word_freq.iteritems(), key=operator.itemgetter(1), reverse=True)

end



function print_all(word_freqs)

    Takes a list of pairs where the entries are sorted by frequency and print them recursively.

    if(len(word_freqs) > 0)
        print word_freqs[0][0], ' - ', word_freqs[0][1]
        print_all(word_freqs[1:]);
end




--]]

--The main function

--print_all(sort(frequencies(remove_stop_words(scan(filter_chars_and_normalize(read_file(sys.argv[1]))))))[0:25])
