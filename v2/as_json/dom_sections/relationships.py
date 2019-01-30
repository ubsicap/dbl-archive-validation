def process_relationships_section(dom, json_dict):
    relationships_sections = dom.xpath("relationships")
    if len(relationships_sections) > 0:
        relationship_section = relationships_sections[0]
        json_dict["relationships"] = {}
        relation_nodes = relationship_section.xpath("relation")
        for relation_node in relation_nodes:
            if "id" in relation_node.attrib and "revision" in relation_node.attrib:
                relation_key = "{0}/{1}".format(relation_node.attrib["id"], relation_node.attrib["revision"])
                json_dict["relationships"][relation_key] = {}
                for att in [
                    "relationType",
                    "type",
                    "id",
                    "publicationId"
                ]:
                    if att in relation_node.attrib:
                        json_dict["relationships"][relation_key][att] = str(relation_node.attrib[att])
                if "revision" in relation_node.attrib:
                    json_dict["relationships"][relation_key]["revision"] = int(relation_node.attrib["revision"])
