def process_canonical_content(dom, json_dict):
    canonical_contents = dom.xpath("canonicalContent")
    if len(canonical_contents) > 0:
        canonical_content = canonical_contents[0]
        json_dict["canonicalContent"] = []
        for book in canonical_content.xpath("book"):
            if "code" in book.attrib:
                json_dict["canonicalContent"] += [book.attrib["code"]]
