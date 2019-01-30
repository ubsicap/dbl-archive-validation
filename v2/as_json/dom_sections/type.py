def process_type_section(dom, json_dict):
    type_sections = dom.xpath("type")
    if len(type_sections) > 0:
        type_section = type_sections[0]
        json_dict["type"] = {}
        for string_field in [
            "medium",
            "iso",
            "name",
            "nameLocal",
            "projectType",
            "dramatization",
            "translationType",
            "audience",
        ]:
            field_nodes = type_section.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["type"][string_field] = str(field_nodes[0].text)
        for bool_field in [
            "hasCharacters",
            "isTranslation",
            "isExpression",
            "isConfidential"
        ]:
            field_nodes = type_section.xpath(bool_field)
            if len(field_nodes) > 0:
                json_dict["type"][bool_field] = field_nodes[0].text == "true"
