import re

def sort_abbreviations(input_file_path, output_file_path):
    # Read the content of the input file
    with open(input_file_path, 'r') as file:
        content = file.read()

    # Extract the lines containing \acro{...}{...}
    abbreviation_lines = re.findall(r'\\acro\{(.*?)}(?:\[(.*?)\])?\s*\{(.*?)\}', content, re.DOTALL)

    # Sort the abbreviation lines alphabetically
    sorted_lines = sorted(abbreviation_lines, key=lambda x: x[0].lower())

    # Generate the new content with sorted lines
    new_content = '\n'.join([f'\\acro{{{abbr}}}{{{brackets}{definition}{brackets}}}' if brackets else f'\\acro{{{abbr}}}{{{definition}}}' for abbr, brackets, definition in sorted_lines])

    # Write the sorted content to the output file
    with open(output_file_path, 'w') as output_file:
        output_file.write(new_content)

# Specify the paths to your input and output LaTeX files
input_latex_file_path = 'zkratky.tex'
output_latex_file_path = 'zkratkyOrder.tex'

# Call the function to sort the abbreviations and write to a different file
sort_abbreviations(input_latex_file_path, output_latex_file_path)
