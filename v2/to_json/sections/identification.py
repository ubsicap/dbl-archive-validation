def process_identification_section(dom, json_dict):
    identification_sections = dom.xpath("identification")
    if len(identification_sections) > 0:
        identification_section = identification_sections[0]
        json_dict["identification"] = {}
        for field in [
            "name",
            "nameLocal",
            "abbreviation",
            "abbreviationLocal",
            "description",
            "descriptionLocal",
            "scope",
            "dateCompleted",
            "bundleProducer"
        ]:
            field_nodes = identification_section.xpath(field)
            if len(field_nodes) > 0:
                json_dict["identification"][field] = str(field_nodes[0].text)
            process_canon_spec(identification_section, json_dict["identification"])
            system_ids = identification_section.xpath("systemId")
            if len(system_ids) > 0:
                json_dict["identification"]["systemIds"] = {}
                for system_id in identification_section.xpath("systemId"):
                    process_system_id(system_id, json_dict["identification"]["systemIds"])

def process_canon_spec(dom, json_dict):
    canon_specs = dom.xpath("canonSpec")
    if len(canon_specs) > 0:
        canon_spec = canon_specs[0]
        json_dict["canonSpec"] = {}
        if "type" in canon_spec.attrib:
            json_dict["canonSpec"]["type"] = str(canon_spec.attrib["type"])
        components = canon_spec.xpath("component")
        if len(components) > 0:
            json_spec["canonSpec"]["components"] = []
            for component in components:
                json_spec["canonSpec"]["components"] += str(component.text)

def process_system_id(dom, json_dict):
    if "type" in dom.attrib:
        json_dict[str(dom.attrib["type"])] = {}
        for child in [
            "id",
            "name",
            "fullName",
            "csetId",
            "baseId",
            "baseName"
            ]:
            child_nodes = dom.xpath(child)
            if len(child_nodes) > 0:
                json_dict[str(dom.attrib["type"])][child] = str(child_nodes[0].text)