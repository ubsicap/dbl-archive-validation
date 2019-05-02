def process_agencies_section(dom, json_dict):
    agencies_sections = dom.xpath("agencies")
    if len(agencies_sections) > 0:
        agencies_section = agencies_sections[0]
        json_dict["agencies"] = []
        for agency in agencies_section:
            agency_record = {"type": agency.tag}
            for text_child in [
                "uid",
                "abbr",
                "url",
                "nameLocal",
                "name"
            ]:
                child_nodes = agency.xpath(text_child)
                if len(child_nodes) > 0:
                    agency_record[text_child] = child_nodes[0].text
            for bool_child in [
                "content",
                "publication",
                "management",
                "finance",
                "qa"
            ]:
                child_nodes = agency.xpath(bool_child)
                if len(child_nodes) > 0:
                    bool_value = child_nodes[0].text == "true"
                    agency_record[bool_child] = bool_value
            json_dict["agencies"] += [agency_record]
