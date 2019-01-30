def process_root_atts(dom, json_dict):
    """
    Process root attributes
    """
    if "version" in dom.attrib:
        try:
            json_dict["version"] = float(dom.attrib["version"])
        except:
            pass
    if "id" in dom.attrib:
        json_dict["id"] = str(dom.attrib["id"])
    if "revision" in dom.attrib:
        json_dict["revision"] = str(dom.attrib["revision"])
