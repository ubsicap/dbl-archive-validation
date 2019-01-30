def process_progress_section(dom, json_dict):
    progress_sections = dom.xpath("progress")
    if len(progress_sections) > 0:
        progress_section = progress_sections[0]
        json_dict["progress"] = {}
        for book in progress_section.xpath("book"):
            try:
                book_code = book.attrib["code"]
            except:
                continue
            json_dict["progress"][book_code] = {"code": book_code}
            try:
                book_stage = int(book.attrib["stage"])
            except:
                continue
            json_dict["progress"][book_code]["stage"] = book_stage
