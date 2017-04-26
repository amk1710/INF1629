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


--Recebe uma lista de palavras e retorna uma copia com todas as stop-words removidas

function remove_stop_words(word_list)


    with open('../stop_words.txt') as f:
        stop_words = f.read().split(',')
    # add single-letter words
    stop_words.extend(list(string.ascii_lowercase))
    return [w for w in word_list if not w in stop_words]

end

--[[

function frequencies(word_list)

    Takes a list of words and returns a dictionary associating
    words with frequencies of occurrence

    word_freqs = {}
    for w in word_list:
        if w in word_freqs:
            word_freqs[w] += 1
        else:
            word_freqs[w] = 1
    return word_freqs

end

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
