def process_structure(dom, json_dict):
    structure_elements = dom.xpath("structure")
    if len(structure_elements) > 0:
        structure_element = structure_elements[0]
        json_dict["structure"] = []
        for structure_child in structure_element.xpath("*[name()='content' or name()='division']"):
            if structure_child.tag == "division":
                process_division(structure_child, json_dict["structure"])
            else:
                process_resource(structure_child, json_dict["structure"])


def process_division(dom, json_array):
    """
    dom is for division, json_array is for parent.
    """
    division_object = {}
    if "name" in dom.attrib:
        division_name = dom.attrib["name"]
        json_array += [{"name": division_name}]
        if "role" in dom.attrib:
            json_array[-1]["role"] = dom.attrib["role"]
        children = dom.xpath("*[name()='content' or name()='division']")
        if len(children) > 0:
            json_array[-1]["contains"] = []
            for child in children:
                if child.tag == "division":
                    process_division(child, json_array[-1]["contains"])
                else:
                    process_resource(child, json_array[-1]["contains"])


def process_resource(dom, json_array):
    """
    dom is for division, json_array is for parent.
    """
    resource_object = {}
    if "src" in dom.attrib:
        resource_src = dom.attrib["src"]
        json_array += [{"src": resource_src}]
        for att in ["role", "name", "srcPart"]:
            if att in dom.attrib:
                json_array[-1][att] = dom.attrib[att]
