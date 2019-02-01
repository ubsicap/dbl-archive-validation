from .canonical_content import process_canonical_content
from .structure import process_structure
from .canonical_content import process_canonical_content


def process_source_section(dom, json_dict):
    source_sections = dom.xpath("source")
    if len(source_sections) > 0:
        source_section = source_sections[0]
        json_dict["source"] = {}
        process_canonical_content(source_section, json_dict["source"])
        process_structure(source_section, json_dict["source"])
