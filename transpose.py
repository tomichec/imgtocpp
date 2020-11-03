import textwrap

with open(filename, 'r') as reader:
    text = reader.read()

list_of_strings = [''.join(chars) for chars in zip(*text.splitlines())]

for string_i in list_of_strings:
    print(string_i)
