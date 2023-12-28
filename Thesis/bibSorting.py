import fitz  # PyMuPDF
import re

def find_citations(text):
    citation_pattern = re.compile(r'\[(\d+)\]', re.IGNORECASE)
    citations = citation_pattern.findall(text)
    unique_citations = sorted(set(citations), key=lambda x: citations.index(x))
    return unique_citations

def order_citations(text, citations):
    citation_order = {citation: index + 1 for index, citation in enumerate(citations)}
    for citation, order in citation_order.items():
        text = re.sub(r'\[{}\]'.format(re.escape(citation)), str(order), text, flags=re.IGNORECASE)
    return text, citation_order

def extract_text_from_pdf(pdf_path, start_page=None, end_page=None):
    doc = fitz.open(pdf_path)
    text = ''
    
    if start_page is None:
        start_page = 0
    if end_page is None:
        end_page = doc.page_count - 1

    for page_num in range(start_page, min(end_page + 1, doc.page_count)):
        page = doc[page_num]
        text += page.get_text()
    
    doc.close()
    return text

def find_chapter_pages(pdf_path, chapter_names):
    doc = fitz.open(pdf_path)
    chapter_pages = {}

    for page_num in range(doc.page_count):
        page = doc[page_num]
        text = page.get_text()
        
        for chapter_name in chapter_names:
            if chapter_name.lower() in text.lower():
                chapter_pages[chapter_name] = page_num + 1
    
    doc.close()
    return chapter_pages

def extract_citations_from_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Use a regular expression to find LaTeX \bibitem commands
    bibitem_pattern = re.compile(r'\\bibitem\{([^}]+)\}((?:(?!\\bibitem|\\end\{thebibliography\}).)+)', re.DOTALL)
    matches = bibitem_pattern.findall(content)
    
    # Extract citation keys and corresponding text
    citations = {key: text.strip() for key, text in matches}
    return citations

def order_bibliography(bibItems, output_file_path, citations):
    # Automatically generate the citation order based on the order of appearance
    citation_order = list(bibItems.keys())

    intCitations = [int(x) for x in citations]
 
    sorted_order = []
    for i in range(len(intCitations)):
        sorted_order.append(citation_order[intCitations[i]-1])
    
    # Write the ordered bibItems to the output file
    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        output_file.write('\\begin{thebibliography}{99}\n')
        output_file.write('\n')
        for key in sorted_order:
            output_file.write(f'\\bibitem{{{key}}}{bibItems[key]}\n')
            output_file.write('\n')
        output_file.write('\\end{thebibliography}')




def main():
    #####Specify user variables
    pdf_file_path = 'sablona-prace.pdf'
    bibliography_file_path = 'text/bibliografie.tex'
    bibliographyOutput_file_path = 'text/bibliografie_Ordered.tex'
    
    # Find pages for chapters named "Úvod" and "Závěr"
    chapter_names = ["Úvod", "Závěr"]
    #####End Specify user variables

    chapter_pages = find_chapter_pages(pdf_file_path, chapter_names)
    
    if not chapter_pages:
        print("Chapters not found in the PDF.")
        return
    
    # Extract text from the PDF using the found chapter pages
    start_page = min(chapter_pages.values()) - 1
    end_page = max(chapter_pages.values()) - 1
    pdf_text = extract_text_from_pdf(pdf_file_path, start_page, end_page)
    
    # Perform citation processing on the extracted text (find_citations, order_citations)
    citations = find_citations(pdf_text)
    ordered_text, citation_order = order_citations(pdf_text, citations)
    
    print("Ordered Text:")
    print(ordered_text)
    
    print("\nCitation Order:")
    print(citation_order)

    # Load all citations from the "text/bibliografie.tex" file
    
    bibItems = extract_citations_from_file(bibliography_file_path)
    
    # Order the bibliography based on the order they appear in the "text/bibliografie.tex" file
    order_bibliography(bibItems, bibliographyOutput_file_path, citations)
    
    print("Bibliography ordered and saved to " + bibliographyOutput_file_path)
    input("Zmáčkněte klávesu enter pro ukončení aplikace")

if __name__ == "__main__":
    main()