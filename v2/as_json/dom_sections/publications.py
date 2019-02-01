from .countries import process_countries_section
from .canonical_content import process_canonical_content
from .structure import process_structure


def process_publications_section(dom, json_dict):
    publications_sections = dom.xpath("publications")
    if len(publications_sections) > 0:
        json_dict["publications"] = {}
        for publication in publications_sections[0].xpath("publication"):
            if "id" in publication.attrib:
                publication_id = publication.attrib["id"]
                json_dict["publications"][publication_id] = {"id": publication_id}
                process_publication(publication, json_dict["publications"][publication_id])


def process_publication(dom, json_dict):
    if "default" in dom.attrib:
        json_dict["default"] = dom.attrib["default"] == "true"
    for field in [
        "name",
        "nameLocal",
        "abbreviation",
        "abbreviationLocal",
        "description",
        "descriptionLocal",
        "scope"
    ]:
        field_nodes = dom.xpath(field)
        if len(field_nodes) > 0:
            json_dict[field] = str(field_nodes[0].text)
    process_canon_spec(dom, json_dict)
    process_countries_section(dom, json_dict)
    process_canonical_content(dom, json_dict)
    process_structure(dom, json_dict)


def process_canon_spec(dom, json_dict):
    canon_specs = dom.xpath("canonSpec")
    if len(canon_specs) > 0:
        canon_spec = canon_specs[0]
        json_dict["canonSpec"] = {}
        if "type" in canon_spec.attrib:
            json_dict["canonSpec"]["type"] = str(canon_spec.attrib["type"])
        components = canon_spec.xpath("component")
        if len(components) > 0:
            json_dict["canonSpec"]["components"] = []
            for component in components:
                json_dict["canonSpec"]["components"] += [str(component.text)]
