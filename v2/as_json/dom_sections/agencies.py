def process_agencies_section(dom, json_dict):
    agencies_sections = dom.xpath("agencies")
    if len(agencies_sections) > 0:
        agencies_section = agencies_sections[0]
        json_dict["agencies"] = {}
        for agency_type in ["rightsHolder", "rightsAdmin", "contributor"]:
            agency_elements = agencies_section.xpath("{0}[uid]".format(agency_type))
            if len(agency_elements) > 0:
                json_dict["agencies"][agency_type] = {}
                for agency in agency_elements:
                    agency_nodes = agencies_section.xpath("*[name()='rightsHolder' or name()='rightsAdmin' or name()='contributor']")
                    for agency_node in [n for n in agency_nodes if len(n.xpath("uid")) > 0]:
                        agency_uid = agency_node.xpath("uid")[0].text
                        json_dict["agencies"][agency_type][agency_uid] = {}
                        for text_child in [
                            "uid",
                            "abbr",
                            "url",
                            "nameLocal",
                            "name"
                        ]:
                            child_nodes = agency_node.xpath(text_child)
                            if len(child_nodes) > 0:
                                json_dict["agencies"][agency_type][agency_uid][text_child] = child_nodes[0].text
                        for bool_child in [
                            "content",
                            "publication",
                            "management",
                            "finance",
                            "qa"
                        ]:
                            child_nodes = agency_node.xpath(bool_child)
                            if len(child_nodes) > 0:
                                bool_value = child_nodes[0].text == "true"
                                json_dict["agencies"][agency_type][agency_uid][bool_child] = bool_value
