def process_names_section(dom, json_dict):
    names_sections = dom.xpath("names")
    if len(names_sections) > 0:
        names_section = names_sections[0]
        json_dict["names"] = {}
        for name in names_section.xpath("name"):
            try:
                name_id = name.attrib["id"]
            except:
                continue
            json_dict["names"][name_id] = {"id": name_id}
            for field in [
                "abbr",
                "short",
                "long"
            ]:
                field_nodes = name.xpath(field)
                if len(field_nodes) > 0:
                    json_dict["names"][name_id][field] = str(field_nodes[0].text)
