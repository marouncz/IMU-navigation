import os

def generate_dirtree(path, indent=0):
    """Recursively generates LaTeX dirtree code for the given directory."""
    latex_lines = []
    files_and_dirs = sorted(os.listdir(path))
    for index, name in enumerate(files_and_dirs):
        full_path = os.path.join(path, name)
        if os.path.isdir(full_path):
            latex_lines.append(" " * indent + f".{name}/")
            latex_lines.extend(generate_dirtree(full_path, indent + 2))
        else:
            latex_lines.append(" " * indent + f".{name}")
    return latex_lines

def create_latex_dirtree(base_dir, output_file):
    """Creates a LaTeX dirtree document from the given directory and writes it to the output file."""
    latex_header = r"""
\documentclass{article}
\usepackage{dirtree}
\begin{document}
\dirtree{%"""
    
    latex_footer = r"""
}
\end{document}
"""

    dirtree_lines = generate_dirtree(base_dir)
    dirtree_content = "\n".join(dirtree_lines)

    latex_content = f"{latex_header}\n{dirtree_content}\n{latex_footer}"

    with open(output_file, 'w') as f:
        f.write(latex_content)

if __name__ == "__main__":
    base_dir = "elektronická příloha práce"  # specify the directory you want to generate the dirtree for
    output_file = "dirtree.tex"  # specify the output LaTeX file name
    create_latex_dirtree(base_dir, output_file)
    print(f"LaTeX dirtree file generated: {output_file}")
