def process_language_section(dom, json_dict):
    language_sections = dom.xpath("language")
    if len(language_sections) > 0:
        language_section = language_sections[0]
        json_dict["language"] = {}
        for field in [
            "iso",
            "name",
            "nameLocal",
            "ldml",
            "rod",
            "numerals",
            "scriptCode",
            "script",
            "scriptDirection"
        ]:
            field_nodes = language_section.xpath(field)
            if len(field_nodes) > 0:
                json_dict["language"][field] = str(field_nodes[0].text)
