-- The shared mutable data
data = {}
words = {}
word_freqs = {}
stop_list = {}

-- The procedures

-- Takes a path to a file and assigns the entire contents of the file to the global variable data
function read_file(path_to_file)

    local str = ""
	for line in io.lines(path_to_file) do
		str = str..line.."\n"
	end
	data = str
end
-- Replaces all nonalphanumeric chars in data with white space

function filter_chars_and_normalize()

    data = string.gsub(data, "[^%w]", " ")
end
-- Scans data for words, filling the global variable words
function scan()

    local str_vec = {}
	local i = 0;
	for s in string.gmatch(data, "%S+") do
		str_vec[i] = string.lower(s);
		i = i +1;
	end

	words = str_vec
end

-- Scans data for words, filling the global variable stop_list

function scan_stop()

    local str_vec = {}
	local i = 0;
	for s in string.gmatch(data, "%S+") do
		str_vec[i] = string.lower(s);
		i = i +1;
	end

	stop_list = str_vec
end
--Recebe uma lista de palavras e uma lista de stop-words retorna uma copia com todas as stop-words removidas

function remove_stop_words()
    for ascii = 97, 122 do
		table.insert(stop_list, string.char(ascii))
	end

	for i = #words,1,-1 do
		for j, stop_word in ipairs(stop_list) do
			if(words[i] == stop_word) then
				table.remove(words, i)
			end

		end

	end

	return word_list
end
--Creates a list of pairs associating words with frequencies

function frequencies()
    for i, word in pairs(words) do
		if(word_freqs[word] == nil) then
			--cria entrada para nova palavra
			word_freqs[word] = {["word"] = word, ["frequency"] = 1}
		else
			--entrada já existe. incrementa frequencia
			word_freqs[word].frequency = word_freqs[word].frequency + 1
		end
	end

end

--Sorts word_freqs by frequency

function sort()
    local sorted_array = {}
	for index in pairs(word_freqs) do
		table.insert(sorted_array, word_freqs[index])
	end

	table.sort(sorted_array, function(a,b) return a.frequency > b.frequency end)

	word_freqs = sorted_array
end

--recebe um array ordenado de pares palavra-frequencia imprime n posições do mesmo
function print_all(n)

	if n > #word_freqs then n = #word_freqs end

	local count = 1;

	for index in ipairs(word_freqs) do
		if count > n then break else count = count + 1 end
		print(word_freqs[index].word, word_freqs[index].frequency)
	end

end

-- The main function

read_file("../pride-and-prejudice.txt")
filter_chars_and_normalize()
scan()
read_file("../stop_words.txt")
filter_chars_and_normalize()
scan_stop()
remove_stop_words()
frequencies()
sort()

print_all(25)
